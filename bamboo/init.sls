{%- from 'zookeeper/settings.sls' import zk with context %}
{%- from 'bamboo/settings.sls' import bamboo with context %}

/etc/bamboo/haproxy_template.cfg:
  file.managed:
      - name: /etc/bamboo/haproxy_template.cfg
      - source: salt://bamboo/files/haproxy_template.cfg

bamboo_container:
  docker.pulled:
    - name: docker-prd.itriagehealth.com/bamboo
    - tag: {{ bamboo.tag }}
    - require:
       - pip: docker-py

bamboo_container_installed:
  docker.installed:
    - name: bamboo
    - image: docker-prd.itriagehealth.com/bamboo:{{ bamboo.tag }}
    - environment:
       - "MARATHON_ENDPOINT": "{{ bamboo.marathon_endpoint }}"
       - "BAMBOO_ENDPOINT": "http://localhost:{{ bamboo.bind_port }}"
       - "BAMBOO_ZK_HOST": {{ zk.connection_string }}
       - "BAMBOO_ZK_PATH": {{ bamboo.zookeeper_path }}
       - "BIND": :{{ bamboo.bind_port }}
       - "CONFIG_PATH": "config/production.example.json"
       - "HAPROXY_TEMPLATE_PATH": "/etc/bamboo/haproxycfg.template"
    - ports:
       - "8000/tcp"
       - "80/tcp"
       - "443/tcp"
       - "9000/tcp"

bamboo_service:
  docker.running:
    - name: bamboo
    - image: docker-prd.itriagehealth.com/bamboo:{{ bamboo.tag }}
    - volumes:
      - /etc/bamboo:/etc/bamboo
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
        "9000/tcp":
            HostIp: ""
            HostPort: "9000"
