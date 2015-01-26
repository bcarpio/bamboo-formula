# for serverspec documentation: http://serverspec.org/
require_relative 'spec_helper'

packages = ['docker-py']

packages.each do | package |
  describe package("#{package}") do
    it{ should be_installed }
  end
end


describe file("/etc/bamboo/haproxy_template.cfg") do
  it{ should be_file }
  it{ should contain 'redirect prefix http://www.localhost.com code 301 if { hdr(host) -i localhost.com'}
end
