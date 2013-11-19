
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
devilrybuild_dir = "#{node.devilryprodenv.devilrybuild_dir}"
buildoutconfig = "#{node.devilryprodenv.buildoutconfig}"
init_service_name = "#{node.devilryprodenv.supervisord_servicename}"
init_script = "/etc/init.d/#{init_service_name}"
pidfile = "#{homedir}/devilrybuild/var/supervisord.pid"


#
# Create init script
#
template "#{init_script}" do
  source "etc/init.d/supervisord.erb"
  owner "#{username}"
  group "#{groupname}"
  mode "0755"
  variables({
    :username => "#{username}",
    :daemon => "#{homedir}/devilrybuild/bin/supervisord",
    :pidfile => "#{pidfile}",
    :init_service_name => "#{init_service_name}"
  })
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
    :database => node[:devilryprodenv][:devilry][:database],
    :settings => node[:devilryprodenv][:devilry][:settings],
    :use_university_terms => node[:devilryprodenv][:devilry][:use_university_terms],
    :use_insecure_fast_passwordhasher => node[:devilryprodenv][:devilry][:use_insecure_fast_passwordhasher],
    :extra_installed_apps => node[:devilryprodenv][:devilry][:extra_installed_apps]
  })
end
template "/etc/devilry/devilry_prod_urls.py" do
  source "etc/devilry/devilry_prod_urls.py.erb"
  owner "root"
  mode "0644"
  variables({
    :extra_urls => node[:devilryprodenv][:devilry][:extra_urls]
  })
end


#
# Create directory for the files uploaded by students
#
directory "#{node.devilryprodenv.devilry.settings.DEVILRY_FSHIERDELIVERYSTORE_ROOT}" do
  owner "#{username}"
  group "#{groupname}"
  mode "0755"
  action :create
end



#
# Create the logdir
#
directory "#{node.devilryprodenv.variables.logdir}" do
  owner "#{username}"
  group "#{groupname}"
  mode "0755"
  action :create
end



#
# Create the devilrybuild directory and buildout.cfg
#
directory "#{devilrybuild_dir}" do
  owner "#{username}"
  group "#{groupname}"
  mode "0755"
  action :create
end
template "#{devilrybuild_dir}/buildout.cfg" do
  source "buildout.cfg.erb"
  owner "#{username}"
  group "#{groupname}"
  mode "0644"
  variables({
    :devilry_version => "#{node.devilryprodenv.devilry_version}",
    :username => "#{username}",
    :pidfile => "#{pidfile}",
    :supervisor => node[:devilryprodenv][:supervisor],
    :variables => node[:devilryprodenv][:variables],
    :gunicorn => node[:devilryprodenv][:gunicorn],
    :extra_sources => node[:devilryprodenv][:extra_sources],
    :extra_eggs => node[:devilryprodenv][:extra_eggs],
  })
end



#
# Initialize the buildout
#
script "initialize_buildout" do
  interpreter "bash"
  user "#{username}"
  cwd "#{devilrybuild_dir}"
  code <<-EOH
  mkdir -p buildoutcache/dlcache
  virtualenv --no-site-packages .
  bin/easy_install distribute==0.6.45
  bin/easy_install zc.buildout==1.7.1
  #bin/buildout "buildout:parts=download-devilryrepo" -c #{buildoutconfig}
  bin/buildout -c #{buildoutconfig}
  bin/django.py syncdb --noinput --migrate
  bin/django.py collectstatic --noinput
  EOH
end
