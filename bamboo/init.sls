{%- from 'bamboo/settings.sls' import bamboo with context %}

docker.io:
  pkg.installed

python-pip:
  pkg.installed

docker-py:
  pip.installed:
    - require:
      - pkg: python-pip

bamboo_container:
  docker.pulled:
    - name: bcarpip/bamboo
    - tag: {{ bamboo.tag }}

bamboo_service:
  docker.running:
    - container: bcarpio/bamboo
    - port_bindings:
        "8000/tcp":
            HostIp: ""
            HostPort: "8000"

