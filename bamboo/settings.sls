{% set p    = salt['pillar.get']('bamboo', {}) %}
{% set pc   = p.get('config', {}) %}
{% set g    = salt['grains.get']('bamboo', {}) %}
{% set gc   = g.get('config', {}) %}

{%- set bamboo = {} %}
{%- do bamboo.update( {
  'tag'                 : gc.get('tag', pc.get('tag', '0.2.4')),
  'marathon_endpoint'   : gc.get('marathon_endpoint', pc.get('marathon_endpoint', 'http://localhost:8080')),
  'bind_port'           : gc.get('bind_port', pc.get('bind_port', '8000')),
  'zookeeper_path'      : gc.get('zookeeper_path', pc.get('zookeeper_path', '/bamboo')),
  'public_dns'          : gc.get('public_dns', pc.get('public_dns', 'localhost.com')),
  'bamboo_host'         : salt['grains.get']('ip_interfaces:eth0', 'localhost')
  }) %}
