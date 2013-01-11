#
# Cookbook Name:: django_nginx
# Recipe:: default
#

sitename = "#{node.django_nginx.sitename}"

# Install nginx using system packages if not installed
include_recipe "nginx::default"

# Configure the site
template "/etc/nginx/sites-available/#{sitename}" do
  source "nginx.conf.erb"
  owner "root"
  mode "0644"
  variables({
    :statichome => "#{node.django_nginx.statichome}",
    :listenaddr => "#{node.django_nginx.listenaddr}",
    :gunicorn_port => "#{node.django_nginx.gunicorn_port}"
  })
end

# Enable the site
link "/etc/nginx/sites-enabled/#{sitename}" do
  to "/etc/nginx/sites-available/#{sitename}"
  link_type :symbolic
end

# Restart nginx
service "nginx" do
  action [ :restart ]
end
