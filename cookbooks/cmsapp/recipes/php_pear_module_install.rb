
app = node.run_state[:current_app]

include_recipe "php" 

# This    is   the   main  backbone  of the   project  of     deploying a   modertely    complex  application  
# by applying DSL   Techniques 


node.default['apps'][app['id']][node.chef_environment]['run_migrations'] = false


local_settings_full_path = app['local_settings_file'] || 'LocalSettings.php' 
local_settings_file_name = local_settings_full_path.split(/[\\\/]/).last   #  Crap  cleanup

## First, install any application specific packages
if app['packages']
  app['packages'].each do |pkg,ver|
    package pkg do
      action :install
      version ver if ver && ver.length > 0
    end
  end
end

## Next, install any application specific gems
if app['pears']
  app['pears'].each do |pear,ver|
    php_pear pear do
      action :install
      version ver if ver && ver.length > 0
    end
  end
end

directory app['deploy_to'] do
  owner app['owner']
  group app['group']
  mode '0755'
  recursive true
end

directory "#{app['deploy_to']}/shared" do
  owner app['owner']
  group app['group']
  mode '0755'
  recursive true
end

if app.has_key?("deploy_key")
  ruby_block "write_key" do
    block do
      f = ::File.open("#{app['deploy_to']}/id_deploy", "w")
      f.print(app["deploy_key"])
      f.close
    end
    not_if do ::File.exists?("#{app['deploy_to']}/id_deploy"); end
  end

  file "#{app['deploy_to']}/id_deploy" do
    owner app['owner']
    group app['group']
    mode '0600'
  end

  template "#{app['deploy_to']}/deploy-ssh-wrapper" do
    source "deploy-ssh-wrapper.erb"
    owner app['owner']
    group app['group']
    mode "0755"
    variables app.to_hash
  end
end

if app["database_master_role"]
  dbm = nil
  # If we are the database master
  if node.run_list.roles.include?(app["database_master_role"][0])
    dbm = node
  else
  # Find the database master
    results = search(:node, "role:#{app["database_master_role"][0]} AND chef_environment:#{node.chef_environment}", nil, 0, 1)
    rows = results[0]
    if rows.length == 1
      dbm = rows[0]
    end
  end

  # Assuming we have one...
  if dbm
    template "#{app['deploy_to']}/shared/#{local_settings_file_name}" do
      source "#{local_settings_file_name}.erb"
      cookbook app["id"]
      owner app["owner"]
      group app["group"]
      mode "644"
      variables(
        :path => "#{app['deploy_to']}/current",
        :host => (dbm.attribute?('cloud') ? dbm['cloud']['local_ipv4'] : dbm['ipaddress']),
        :database => app['databases'][node.chef_environment],
        :app => app
      )
    end
  else
    Chef::Log.warn("No node with role #{app['database_master_role'][0]}, #{local_settings_file_name} not rendered!")
  end
end

## Note   that   some  of  these   have  been  shamelessly borrowed  ;(
deploy_revision app['id'] do
  revision app['revision'][node.chef_environment]
  repository app['repository']
  user app['owner']
  group app['group']
  deploy_to app['deploy_to']
  action app['force'][node.chef_environment] ? :force_deploy : :deploy
  ssh_wrapper "#{app['deploy_to']}/deploy-ssh-wrapper" if app['deploy_key']
  shallow_clone true
  purge_before_symlink([])
  create_dirs_before_symlink([])
  symlinks({})
  symlink_before_migrate({
    local_settings_file_name => local_settings_full_path
  })
end
