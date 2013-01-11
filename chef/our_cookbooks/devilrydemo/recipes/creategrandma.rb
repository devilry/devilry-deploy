#
# Cookbook Name:: devilrydemo
# Recipe:: creategrandma
#

username = "#{node.devilryprodenv.username}"
devilrybuild_dir = "#{node.devilryprodenv.devilrybuild_dir}"

bash "create_grandma_user" do
  user "#{username}"
  cwd "#{devilrybuild_dir}"
  # We ignore failure because this fails if the user exists
  ignore_failure true
  code <<-EOH
  bin/django.py devilry_useradd --email="grandma@example.com" --full_name="Elvira Granma" --superuser --password test grandma
  EOH
end
