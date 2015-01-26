# for serverspec documentation: http://serverspec.org/
require_relative 'spec_helper'


describe file("/etc/bamboo/haproxy_template.cfg") do
  it{ should be_file }
  # This line redirects traffic from localhost.com to www.localhost.com and
  # resolves some issues with asset serving.
  it{ should contain 'redirect prefix http://www.localhost.com code 301 if { hdr(host) -i localhost.com'}
end
