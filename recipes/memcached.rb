####### Session Caching #######
node.set[:magento][:session][:save] = 'memcache'

node.set[:memcached][:memory] = node[:magento][:memcached][:sessions][:memory]
node.set[:memcached][:port] = node[:magento][:memcached][:sessions][:port]
node.set[:memcached][:listen] = node[:magento][:memcached][:sessions][:listen]
node.set[:memcached][:maxconn] = node[:magento][:memcached][:sessions][:maxconn]

package "memcached"
package "libmemcached-devel"

  service "memcached" do
    action :disable
    notifies :stop, "service[memcached]", :immediately
  end

  node.set[:memcache][:config_dir] = "/etc/sysconfig"
  file "/etc/sysconfig/memcached" do
    action :delete
  end
  file "/etc/init.d/memcached" do
    action :delete
  end

  # Build init scripts
  template "/etc/init.d/memcached_sessions" do
    source "memcached-init.erb"
    mode 0755
    owner "root"
    group "root"
    variables(
      :instance => "sessions",
      :port => node[:magento][:memcached][:sessions][:port],
      :user => node[:memcached][:user],
      :maxconn => node[:magento][:memcached][:sessions][:maxconn],
      :memory => node[:magento][:memcached][:sessions][:memory],
      :listen => node[:magento][:memcached][:sessions][:listen],
      :logfilename => node[:magento][:memcached][:sessions]['logfilename']
    )
  end

  template "/etc/init.d/memcached_backend" do
    source "memcached-init.erb"
    mode 0755
    owner "root"
    group "root"
    variables(
      :instance => "backend",
      :port => node[:magento][:memcached][:slow_backend][:port],
      :user => node[:memcached][:user],
      :maxconn => node[:magento][:memcached][:slow_backend][:maxconn],
      :memory => node[:magento][:memcached][:slow_backend][:memory],
      :listen => node[:magento][:memcached][:slow_backend][:listen],
      :logfilename => node[:magento][:memcached][:slow_backend]['logfilename']
    )
  end

template "#{node[:memcache][:config_dir]}/memcached_sessions.conf" do
    source "memcached.sysconfig.redhat.erb"
     variables(
      :memory => node[:memcached][:memory],
      :port => node[:memcached][:port],
      :user => node[:memcached][:user],
      :listen => node[:memcached][:listen],
      :maxconn => node[:memcached][:maxconn],
      :logfilename => node[:memcached][:logfilename]
   )
  end

template "#{node[:memcache][:config_dir]}/memcached_backend.conf" do
    source "memcached.sysconfig.redhat.erb"
     variables(
      :memory => node[:magento][:memcached][:slow_backend][:memory],
      :port => node[:magento][:memcached][:slow_backend][:port],
      :user => node[:memcached][:user],
      :group => node[:memcached][:group],
      :listen => node[:magento][:memcached][:slow_backend][:listen],
      :maxconn => node[:magento][:memcached][:slow_backend][:maxconn],
      :logfilename => node[:magento][:memcached][:slow_backend][:logfilename]   
   )
  end

service "memcached_sessions" do
  action [ :enable, :start ]
  supports :status => true, :start => true, :stop => true, :restart => true
end

service "memcached_backend" do
  action [ :enable, :start ]
  supports :status => true, :start => true, :stop => true, :restart => true
 end
