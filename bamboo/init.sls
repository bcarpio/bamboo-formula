{%- from 'zookeeper/settings.sls' import zk with context %}
{%- from 'bamboo/settings.sls' import bamboo with context %}

bamboo_container:
  docker.pulled:
    - name: bcarpio/bamboo
    - tag: {{ bamboo.tag }}
    - require:
       - pip: docker-py

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
       - "80/tcp"
       - "443/tcp"

bamboo_service:
  docker.running:
    - name: bamboo
    - port_bindings:
        "8000/tcp":
            HostIp: ""
            HostPort: "8000"
        "80/tcp":
            HostIp: ""
            HostPort: "80"
        "443/tcp":
            HostIp: ""
            HostPort: "443"
