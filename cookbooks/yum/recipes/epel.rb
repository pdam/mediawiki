
major = node['platform_version'].to_i
epel  = node['yum']['epel_release']


remote_file "#{Chef::Config[:file_cache_path]}/epel-release-#{epel}.noarch.rpm" do
  source "http://download.fedoraproject.org/pub/epel/#{major}/i386/epel-release-#{epel}.noarch.rpm"
  not_if "rpm -qa | egrep -qx 'epel-release-#{epel}(|.noarch)'"
  notifies :install, "rpm_package[epel-release]", :immediately
end

rpm_package "epel-release" do
  source "#{Chef::Config[:file_cache_path]}/epel-release-#{epel}.noarch.rpm"
  only_if {::File.exists?("#{Chef::Config[:file_cache_path]}/epel-release-#{epel}.noarch.rpm")}
  action :nothing
end

file "epel-release-cleanup" do
  path "#{Chef::Config[:file_cache_path]}/epel-release-#{epel}.noarch.rpm"
  action :delete
end
