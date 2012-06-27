
template "/etc/yum.conf" do
  source "yum-rhel#{node[:platform_version].to_i}.conf.erb"
end
