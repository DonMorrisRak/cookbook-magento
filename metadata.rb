name             "magento"
maintainer       "Yevgeniy Viktorov"
maintainer_email "craftsman@yevgenko.me"
license          "Apache 2.0"
description      "Magento app stack"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.2"
recipe           "magento", "Prepares app stack for magento deployments"

%w{ debian ubuntu centos redhat fedora amazon }.each do |os|
  supports os
end

%w{ apt yum apache2 mysql openssl percona-install php firewall memcached varnish vim }.each do |cb|
  depends cb
end
