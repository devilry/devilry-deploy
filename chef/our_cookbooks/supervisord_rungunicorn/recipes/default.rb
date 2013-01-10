include_recipe "supervisord"

prodenvdir = "#{node.devilryprodenv.prodenvdir}"
username = "#{node.devilryprodenv.username}"
homedir = "#{node.devilryprodenv.homedir}"
gunicorn_port = "#{node.supervisord_rungunicorn.gunicorn_port}"
nginxdir = "#{homedir}/conf"
nginxconfigfile = "#{nginxdir}/nginx.conf"


#####################################
#
# Gunicorn
#
#####################################
gunicorn = supervisord_program "gunicorn" do
  command "#{prodenvdir}/bin/django.py run_gunicorn 127.0.0.1:#{gunicorn_port}"
  directory "#{prodenvdir}"
  autostart true
  user "#{username}"
  action [:supervise]
end


#####################################
#
# Nginx
#
#####################################

package "nginx"
service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [:disable]
end

directory "#{nginxdir}" do
  owner "#{username}"
  mode "0755"
  action :create
end

template "#{nginxconfigfile}" do
  source "nginx.conf.erb"
  mode 0644
  owner "#{username}"
  variables({
    :nginx_user => "#{node.devilryprodenv.username}",
    :statichome => "#{node.devilryprodenv.prodenvdir}",
    :gunicorn_port => "#{gunicorn_port}"
  })
end
nginx = supervisord_program "nginx" do
  command "nginx -c #{nginxconfigfile}"
  autostart true
  directory "#{nginxdir}"
  user "root"
  action [:supervise]
end




#####################################
#
# Restart
#
#####################################

ruby_block "restart supervisord processes" do
  block do
    gunicorn.run_action(:restart)
    nginx.run_action(:restart)
  end
end
