{% set p    = salt['pillar.get']('bamboo', {}) %}
{% set pc   = p.get('config', {}) %}
{% set g    = salt['grains.get']('bamboo', {}) %}
{% set gc   = g.get('config', {}) %}

{%- set bamboo = {} %}
{%- do bamboo.update( {
  'tag'		            : p.get('tag', 'v0.2.8'),
  'marathon_endpoint'   : p.get('marathon_endpoint', 'http://localhost:8080'),
  'bind_port'           : p.get('bind_port', '8000'),
  'zookeeper_path'      : p.get('zookeeper_path', '/bamboo')
  }) %}
