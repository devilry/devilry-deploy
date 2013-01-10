
#
# System packages required by devilry
#
package "build-essential"   # Required to compile python c/c++ modules (like Pillow)
package "python-dev"        # Required to compile python c/c++ modules (like Pillow)
package "libjpeg62-dev"     # Required by PIL (Pillow)
package "zlib1g-dev"        # Required by PIL (Pillow)
package "libfreetype6-dev"  # Required by PIL (Pillow)
package "liblcms1-dev"      # Required by PIL (Pillow)
package "python-virtualenv" # Required to create a virtualenv in virtualenv_buildout
package "git"               # Required to check out sources from the repo
#package "sqlite3"           # Needed to backup sqlite databases
package "s3cmd"             # Needed to copy backups to S3


username = "#{node.devilryprodenv.username}"
groupname = "#{node.devilryprodenv.groupname}"
homedir = "#{node.devilryprodenv.homedir}"
prodenvdir = "#{node.devilryprodenv.prodenvdir}"


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
# Clone devilry git repo into $HOME/devilry/
#
git "#{homedir}/devilry" do
  repository "https://github.com/devilry/devilry-django.git"
  reference "#{node.devilryprodenv.git_branch_or_ref}" # The branch, tag or commitID to check out
  action :sync # Update the source to the specified revision, or get a new clone/checkout
  user "#{username}" # System user to own the checked out code
  group "#{groupname}" # System group to own the checked out code
end


#
# Create:
# - a virtualenv (for a completely clean and protected environment).
# - initialize and run bootstrap
#       - Downloads all dependencies
#       - Creates a wrapper for Django manage.py that uses the virtualenv for
#         the python executable and bootstrap dependencies as PYTHONPATH.
#
script "clean_virtualenv_buildout" do
  interpreter "bash"
  user "#{username}"
  cwd "#{prodenvdir}"
  code <<-EOH
  rm -rf venv
  virtualenv venv
  venv/bin/python ../bootstrap.py -d
  bin/buildout
  bin/django.py collectstatic --noinput
  EOH
end
