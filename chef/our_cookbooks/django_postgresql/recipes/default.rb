dbname = "#{node.django_postgresql.dbname}"
username = "#{node.django_postgresql.username}"
password = "#{node.django_postgresql.password}"



#
# Create the postgres database if it does not exist
#
python "create_postgresql_db" do
  user "postgres"
  code <<-EOH
from subprocess import check_call, check_output

dbname = '#{dbname}'
if dbname in check_output(['psql', '-c', '\\list']):
    print "Database '{0}' already exists"
else:
    cmd = ['createdb', '-E', 'UTF8', '-l', 'en_US.utf8', '-T', 'template0', dbname]
    print 'Executing: "{0}"'.format(' '.join(cmd))
    check_call(cmd)
  EOH
end

#
# Create the postgres user that Django will be using
#
python "add_postgresql_user" do
  user "postgres"
  code <<-EOH
from subprocess import call
cmd = ['createuser', '--no-createdb', '--no-superuser', '--no-createrole', '#{username}']
print 'Executing: "{0}"'.format(' '.join(cmd))
ok = call(cmd)
if not ok:
    print "'{0}' failed, which usually means that the user already exists (which is not an error).".format(' '.join(cmd))
  EOH
end

python "update_postgresql_password" do
  user "postgres"
  code <<-EOH
from subprocess import check_call
sql = "ALTER USER #{username} WITH PASSWORD '#{password}';"
cmd = ['psql', '-c', sql]
print 'Executing: "{0}"'.format(' '.join(cmd))
check_call(cmd)
  EOH
end

python "grant_postgresql_permissions" do
  user "postgres"
  code <<-EOH
from subprocess import check_call
sql = "GRANT ALL PRIVILEGES ON DATABASE #{dbname} TO #{username};"
cmd = ['psql', '-c', sql]
print 'Executing: "{0}"'.format(' '.join(cmd))
check_call(cmd)
  EOH
end
