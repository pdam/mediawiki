
include_recipe "yum::epel"

major = node['platform_version'].to_i
ius   = node['yum']['ius_release']

remote_file "#{Chef::Config[:file_cache_path]}/ius-release-#{ius}.ius.el#{major}.noarch.rpm" do
  source "http://dl.iuscommunity.org/pub/ius/stable/Redhat/#{major}/i386/ius-release-#{ius}.ius.el#{major}.noarch.rpm"
  not_if "rpm -qa | grep -q '^ius-release-#{ius}'"
  notifies :install, "rpm_package[ius-release]", :immediately
end

rpm_package "ius-release" do
  source "#{Chef::Config[:file_cache_path]}/ius-release-#{ius}.ius.el#{major}.noarch.rpm"
  only_if {::File.exists?("#{Chef::Config[:file_cache_path]}/ius-release-#{ius}.ius.el#{major}.noarch.rpm")}
  action :nothing
end

file "ius-release-cleanup" do
  path "#{Chef::Config[:file_cache_path]}/ius-release-#{ius}.ius.el#{major}.noarch.rpm"
  action :delete
end
