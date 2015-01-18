{%- from 'zookeeper/settings.sls' import zk with context %}
{%- from 'bamboo/settings.sls' import bamboo with context %}

docker-repo:
  pkgrepo.managed:
    - humanname: Docker PPA
    - name: deb https://get.docker.com/ubuntu docker main
    - file: /etc/apt/sources.list.d/docker.list
    - keyid: 36A1D7869245C8950F966E92D8576A8BA88D21E9
    - keyserver: keyserver.ubuntu.com 
    - require_in:
      - pkg: lxc-docker

lxc-docker:
  pkg.installed

python-pip:
  pkg.installed

docker-py:
  pip.installed:
    - require:
       - pkg: python-pip

bamboo_container:
  docker.pulled:
    - name: bcarpio/bamboo
    - tag: {{ bamboo.tag }}
    - require:
       - pkg: docker-py

bamboo_container_installed:
  docker.installed:
    - name: bamboo
    - image: bcarpio/bamboo:{{ bamboo.tag }}
    - environment:
       - "MARATHON_ENDPOINT": "{{ bamboo.marathon_endpoint }}"
       - "BAMBOO_ENDPOINT": "http://localhost:{{ bamboo.bind_port }}"
       - "BAMBOO_ZK_HOST": {{ zk.connection_string }}
       - "BAMBOO_ZK_PATH": {{ bamboo.zookeeper_path }}
       - "BIND": :{{ bamboo.bind_port }}
       - "CONFIG_PATH": "config/production.example.json"
    - ports:
       - "8000/tcp"

bamboo_service:
  docker.running:
    - name: bamboo
    - port_bindings:
        "80/tcp":
            HostIp: ""
            HostPort: "8000"
