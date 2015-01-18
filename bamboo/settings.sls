{% set p    = salt['pillar.get']('mesosphere', {}) %}
{% set pc   = p.get('config', {}) %}
{% set g    = salt['grains.get']('mesosphere', {}) %}
{% set gc   = g.get('config', {}) %}

{%- set bamboo = {} %}
{%- do bamoo.update( {
  'tag'		            : p.get('tag', 'v0.2.8'),
  }) %}
