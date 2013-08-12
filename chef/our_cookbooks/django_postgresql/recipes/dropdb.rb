
dbname = "#{node.django_postgresql.dbname}"

#
# Create the postgres database if it does not exist
#
python "drop_postgresql_db" do
  user "postgres"
  code <<-EOH
from subprocess import check_call, check_output

dbname = '#{dbname}'
if dbname in check_output(['psql', '-c', '\\list']):
    cmd = ['dropdb', dbname]
    check_call(cmd)
  EOH
end

