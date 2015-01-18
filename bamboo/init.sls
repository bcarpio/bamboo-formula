{%- from 'bamboo/settings.sls' import bamboo with context %}

docker.io:
  pkg.installed

python-pip:
  pkg.installed

docker-py:
  pip.installed:
    - require:
      - pkg: python-pip

bamboo:
  docker.pulled:
    - name: bcarpip/bamboo
    - tag: {{ bamboo.tag }}
