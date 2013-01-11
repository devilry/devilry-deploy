
#
# System packages required by devilry
#
package "build-essential"   # Required to compile python c/c++ modules (like psycopg2)
package "python-dev"        # Required to compile python c/c++ modules (like psycopg2)
package "python-virtualenv" # Required to create a virtualenv in virtualenv_buildout
package "git"               # Required to check out sources from the repo


username = "#{node.devilryprodenv.username}"
groupname = "#{node.devilryprodenv.groupname}"
homedir = "#{node.devilryprodenv.homedir}"
init_script = "/etc/init.d/devilry-supervisord"


#
# Stop the Devilry services
# - ignored if this is the first time we run the recipe and the init-script
#   does not exist.
#
service "devilry-supervisord" do
  action [ :stop ]
end


#
# Create the #{username} group, user and home directory
#
group "#{username}" do
    system false
end
user "#{username}" do
  comment "User that runs the devilry server"
  gid "#{username}"
  home "#{homedir}"
  shell "/bin/bash"
  # Note: We do not set a password for the user - we login using "su #{username}" from the system user.
end
directory "#{homedir}" do
  owner "#{username}"
  group "#{groupname}"
  mode "0755"
  action :create
end



#
# Create /etc/devilry
#
directory "/etc/devilry" do
  owner "root"
  mode "0755"
  action :create
end
template "/etc/devilry/__init__.py" do
  source "etc/devilry/__init__.py.erb"
  owner "root"
  mode "0644"
end
template "/etc/devilry/devilry_prod_settings.py" do
  source "etc/devilry/devilry_prod_settings.py.erb"
  owner "root"
  mode "0644"
  variables({
    :secret_key=> "#{node.devilryprodenv.settings.SECRET_KEY}",
    :debug=> "#{node.devilryprodenv.settings.DEBUG}",
    :dbbackend=> "#{node.devilryprodenv.settings.DBBACKEND}",
    :dbname=> "#{node.devilryprodenv.settings.DBNAME}",
    :dbuser=> "#{node.devilryprodenv.settings.DBUSER}",
    :dbpassword=> "#{node.devilryprodenv.settings.DBPASSWORD}",
    :dbhost=> "#{node.devilryprodenv.settings.DBHOST}",
    :dbport=> "#{node.devilryprodenv.settings.DBPORT}",
    :syncsystem=> "#{node.devilryprodenv.settings.DEVILRY_SYNCSYSTEM}",
    :deliverystore_root=> "#{node.devilryprodenv.settings.DEVILRY_FSHIERDELIVERYSTORE_ROOT}",
    :use_university_terms=> "#{node.devilryprodenv.settings.USE_UNIVERSITY_TERMS}"
  })
end


#
# Create directory for the files uploaded by students
#
directory "#{node.devilryprodenv.settings.DEVILRY_FSHIERDELIVERYSTORE_ROOT}" do
  owner "#{username}"
  group "#{groupname}"
  mode "0755"
  action :create
end




#
# Create the devilrybuild directory and buildout.cfg
#
devilrybuild = "#{homedir}/devilrybuild"
directory "#{devilrybuild}" do
  owner "#{username}"
  group "#{groupname}"
  mode "0755"
  action :create
end
template "#{homedir}/devilrybuild/buildout.cfg" do
  source "buildout.cfg.erb"
  owner "#{username}"
  group "#{groupname}"
  mode "0644"
  variables({
    :devilry_version => "#{node.devilryprodenv.devilry_version}",
    :username => "#{username}"
  })
end



#
# Initialize the buildout
#
script "initialize_buildout" do
  interpreter "bash"
  user "#{username}"
  cwd "#{homedir}/devilrybuild"
  code <<-EOH
  mkdir -p buildoutcache/dlcache
  virtualenv --no-site-packages .
  bin/easy_install zc.buildout
  bin/buildout "buildout:parts=download-devilryrepo" && bin/buildout
  bin/django.py syncdb --noinput
  bin/django.py collectstatic --noinput
  EOH
end




#
# Create init script
#
template "#{init_script}" do
  source "etc/init.d/devilry-supervisord.erb"
  owner "#{username}"
  group "#{groupname}"
  mode "0755"
  variables({
    :username => "#{username}",
    :daemon => "#{homedir}/devilrybuild/bin/supervisord",
    :pidfile => "#{homedir}/devilrybuild/var/supervisord.pid"
  })
end

# Enable the service (make it start at boot), and restart
service "devilry-supervisord" do
  action [ :enable, :start ]
end
