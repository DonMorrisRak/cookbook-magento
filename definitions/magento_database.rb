define :magento_database do
 
   include_recipe "percona-install::server"
   include_recipe "percona-install::client"

  service "mysql" do
    action [:enable, :start]
  end

  execute "mysql-install-mage-privileges" do
    command "/usr/bin/mysql -u root -h localhost -P #{node[:mysql][:port]} < /etc/mage-grants.sql"
    action :nothing
  end

  # Initialize permissions and users
  template "/etc/mage-grants.sql" do
    path "/etc/mage-grants.sql"
    source "grants.sql.erb"
    owner "root"
    group "root"
    mode "0600"
    variables(
      :database => node[:magento][:db],
      :rootpasswd => node['mysql']['server_root_password'],
      :port => node['mysql']['port']
    )
    notifies :run, resources(:execute => "mysql-install-mage-privileges"), :immediately
  end

  execute "create #{node[:magento][:db][:database]} database" do
    command "/usr/bin/mysqladmin -u root -h localhost -P #{node[:mysql][:port]} -p#{node[:mysql][:server_root_password]} create #{node[:magento][:db][:database]}"
    end

  # Setup /root/.my.cnf for easier management
  template "/root/.my.cnf" do
    source "dotmy.cnf.erb"
    owner "root"
    group "root"
    mode "0600"
    variables(
      :rootpasswd => node['mysql']['server_root_password'],
      :port => node['mysql']['port']
    )
  end

  # save node data after writing the MYSQL root password, so that a failed chef-client run that gets this far doesn't cause an unknown password to get applied to the box without being saved in the node data.
  unless Chef::Config[:solo]
    ruby_block "save node data" do
      block do
        node.save
      end
      action :create
    end
  end

end
