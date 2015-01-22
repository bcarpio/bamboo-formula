{%- from 'zookeeper/settings.sls' import zk with context %}
{%- from 'bamboo/settings.sls' import bamboo with context %}

/etc/bamboo/haproxy_template.cfg:
  file.managed:
      - name: /etc/bamboo/haproxy_template.cfg
      - source: salt://bamboo/files/haproxy_template.cfg
      - makedirs: True

bamboo_container:
  docker.pulled:
    - name: itriage/bamboo
    - tag: {{ bamboo.tag }}
    - require:
       - pip: docker-py



bamboo_container_running:
  cmd.run:
    - name: |
        docker run \
        --name bamboo \
        --restart=always \
        -d \
        -p 80:80 \
        -p 443:443 \
        -p 9000:9000 \
        -p 8000:8000 \
        -p 8080:8080 \
        -v /etc/bamboo:/etc/bamboo \
        -e MARATHON_ENDPOINT="{{ bamboo.marathon_endpoint }}" \
        -e BAMBOO_ENDPOINT="http://localhost:{{ bamboo.bind_port }}" \
        -e BAMBOO_ZK_HOST="{{ zk.connection_string }}" \
        -e BAMBOO_ZK_PATH="{{ bamboo.zookeeper_path }}" \
        -e CONFIG_PATH="config/production.example.json" \
        -e HAPROXY_TEMPLATE_PATH="/etc/bamboo/haproxy_template.cfg" \
        itriage/bamboo:{{ bamboo.tag }} -bind=":8000"
    - unless: docker ps | egrep 'bamboo'

#Docker volume mounting is currently not working... Until then we will have to
#run the command via the command line
#https://github.com/saltstack/salt/issues/14089

# bamboo_container_installed:
#   docker.installed:
#     - name: bamboo
#     - command: '-bind=":8000"'
#     - image: itriage/bamboo:{{ bamboo.tag }}
#     - environment:
#       - "MARATHON_ENDPOINT": "{{ bamboo.marathon_endpoint }}"
#       - "BAMBOO_ENDPOINT": "http://localhost:{{ bamboo.bind_port }}"
#       - "BAMBOO_ZK_HOST": {{ zk.connection_string }}
#       - "BAMBOO_ZK_PATH": {{ bamboo.zookeeper_path }}
#       - "CONFIG_PATH": "config/production.example.json"
#       - "HAPROXY_TEMPLATE_PATH": "/etc/bamboo/haproxycfg.template"
#       - ports:
#         - "8000/tcp"
#         - "80/tcp"
#         - "443/tcp"
#         - "9000/tcp"
#
#
# bamboo_service:
#   docker.running:
#     - name: bamboo
#     - image: docker-prd.itriagehealth.com/bamboo:{{ bamboo.tag }}
#     - volumes:
#       /etc/bamboo:
#         bind: /etc/bamboo
#         ro: false
#     - port_bindings:
#         "8000/tcp":
#             HostIp: ""
#             HostPort: "8000"
#         "80/tcp":
#             HostIp: ""
#             HostPort: "80"
#         "443/tcp":
#             HostIp: ""
#             HostPort: "443"
#         "9000/tcp":
#             HostIp: ""
#             HostPort: "9000"
