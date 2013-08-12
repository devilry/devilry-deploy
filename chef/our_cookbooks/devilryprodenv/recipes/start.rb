init_service_name = "#{node.devilryprodenv.supervisord_servicename}"

# Enable the service (make it start at boot), and start
service "#{init_service_name}" do
  action [ :enable, :start ]
end
