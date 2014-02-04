# General settings
default[:magento][:download_url] = "http://www.magentocommerce.com/downloads/assets/1.7.0.2/magento-1.7.0.2.tar.gz"
default[:magento][:dir] = "/var/www/vhosts/#{node[:magento][:hostname]}"
default[:magento][:use_sample_data] = false
default[:magento][:sample_data_url] = 'http://www.magentocommerce.com/downloads/assets/1.6.1.0/magento-sample-data-1.6.1.0.tar.gz'
default[:magento][:run_type] = "store"
default[:magento][:run_codes] = Array.new
default[:magento][:session][:save] = 'db' # db, memcache, or files
default[:magento][:system_user] = 'magento'
default[:magento][:encryption_key] = ''

# Firewall configuration - Ports must be integers
default[:magento][:firewall][:http] = 80
default[:magento][:firewall][:https] = 443
default[:magento][:firewall][:interface] = 'eth0'

# Magento Website Conifiguration
default[:magento][:locale] = "en_US"
default[:magento][:timezone] = "America/Chicago"
default[:magento][:default_currency] = "USD"
default[:magento][:admin_frontname] = "admin"
default[:magento][:url] = "http://example.com/"
default[:magento][:use_rewrites] = "yes"
default[:magento][:use_secure] = "yes"
default[:magento][:secure_base_url] = "https://example.com/"
default[:magento][:use_secure_admin] = "yes"
default[:magento][:enable_charts] = "yes"

# Required packages
case node[:platform_family]
when "rhel"
  default[:magento][:packages] = ['php53u-cli', 'php53u-common', 'php53u-curl', 'php53u-gd', 'php53u-mysql', 'php53u-pear', 'php53u-pecl-apc', 'php53u-xml', 'php53u-xmlrpc', 'php53u-soap', 'php53u-fpm', 'php53u-mcrypt', 'libmcrypt', 'ruby-devel']
when "fedora"
  default[:magento][:packages] = ['php53u-cli', 'php53u-common', 'php53u-curl', 'php53u-gd', 'php53u-mysql', 'php53u-pear', 'php53u-pecl-apc', 'php53u-xml', 'php53u-xmlrpc', 'php53u-soap', 'php53u-fpm', 'php53u-mcrypt', 'libmcrypt', 'ruby-devel']
else
  default[:magento][:packages] = ['php5-cli', 'php5-common', 'php5-curl', 'php5-gd', 'php5-mcrypt', 'php5-mysql', 'php-pear', 'php-apc']
end

# Web Server
default[:magento][:webserver] = 'apache'
default[:apache][:listen_ports] = %w[8080]
default[:apache][:docroot_dir] = '/var/www/vhosts'
default[:apache][:default_site_enabled] = true
default[:apache][:default_modules] = %w[ status alias auth_basic authn_file authz_default authz_groupfile authz_host authz_user autoindex dir env mime negotiation setenvif headers expires log_config logio]

# Database Credentials & Connection Settings
::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default[:magento][:db][:database] = 'magento'
default[:magento][:db][:prefix] = ''
default[:magento][:db][:username] = 'magentouser'
set_unless[:magento][:db][:password] = secure_password

# Options for configurating Magento connectivity to database.
default[:magento][:db][:initStatements] = 'SET NAMES utf8'
default[:magento][:db][:model] = 'mysql4'
default[:magento][:db][:type] = 'pdo_mysql'
default[:magento][:db][:pdoType] = ''
default[:magento][:db][:active] = '1'

# Database settings
default[:mysql][:bind_address] = "localhost"
default[:mysql][:port] = 3306
default[:mysql][:interface] = "eth1"
default[:mysql][:tunable][:max_allowed_packet]   = "32M"

# Magento Admin User
default[:magento][:admin_user][:firstname] = 'Admin' # Required
default[:magento][:admin_user][:lastname] = 'User' # Required
default[:magento][:admin_user][:email] = 'admin@example.org' # Required
default[:magento][:admin_user][:username] = 'MagentoAdmin' # Required
default[:magento][:admin_user][:password] = 'magPass.123' # Required

# Memcached Server Session Settings
default[:magento][:memcached][:sessions][:memory] = 512
default[:magento][:memcached][:sessions][:port] = 11211
default[:magento][:memcached][:sessions][:maxconn] = 2048 
default[:magento][:memcached][:sessions][:listen] = "127.0.0.1"
default[:magento][:memcached][:sessions][:interface] = "eth1"
default[:magento][:memcached][:sessions][:logfilename] = "memcached.log"
default[:magento][:memcached][:clients] = []

# Memcached Server Slow Backend Settings
default[:magento][:memcached][:slow_backend][:memory] = 1536
default[:magento][:memcached][:slow_backend][:port] = 11212
default[:magento][:memcached][:slow_backend][:maxconn] = 2048
default[:magento][:memcached][:slow_backend][:listen] = "127.0.0.1"
default[:magento][:memcached][:slow_backend][:interface] = "eth1"
default[:magento][:memcached][:slow_backend][:logfilename] = "memcached.log"

# Memcached Server, used for configuring client servers
default[:magento][:memcached][:servers][:sessions][:servers] = "127.0.0.1"
default[:magento][:memcached][:servers][:sessions][:server_port] = 11211

default[:magento][:memcached][:servers][:slow_backend][:servers] = "127.0.0.1"
default[:magento][:memcached][:servers][:slow_backend][:server_port] = 11212
default[:magento][:memcached][:servers][:slow_backend][:persistent] = 1
default[:magento][:memcached][:servers][:slow_backend][:weight] = 1
default[:magento][:memcached][:servers][:slow_backend][:timeout] = 1
default[:magento][:memcached][:servers][:slow_backend][:retry_interval] = 15
default[:magento][:memcached][:servers][:slow_backend][:compression] = 0

# Varnish config
default[:magento][:varnish][:use_varnish] = true
default[:magento][:varnish][:backend_http] = 8080
default[:magento][:varnish][:memory] = "#{(node['memory']['total'].to_i / 4) / (1024)}M"

# Page cache servers
default[:magento][:pagecache][:servers] = []
