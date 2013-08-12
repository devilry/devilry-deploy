homedir = "#{node.devilryprodenv.homedir}"
pidfile = "#{homedir}/devilrybuild/var/supervisord.pid"
init_service_name = "#{node.devilryprodenv.supervisord_servicename}"

#
# Stop the Devilry services
# - ignored if this is the first time we run the recipe and the init-script
#   does not exist.
#
service "#{init_service_name}" do
  only_if = "test -e #{pidfile}"
  action [ :stop ]
end
