{% set p    = salt['pillar.get']('bamboo', {}) %}
{% set pc   = p.get('config', {}) %}
{% set g    = salt['grains.get']('bamboo', {}) %}
{% set gc   = g.get('config', {}) %}

{%- set bamboo = {} %}
{%- do bamboo.update( {
  'tag'                 : pc.get('tag', 'v0.2.8-01'),
  'marathon_endpoint'   : pc.get('marathon_endpoint', 'http://10.0.2.15:8080'),
  'bind_port'           : pc.get('bind_port', '8000'),
  'zookeeper_path'      : pc.get('zookeeper_path', '/bamboo')
  }) %}
