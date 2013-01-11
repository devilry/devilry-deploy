
dbname = "#{node.django_postgresql.dbname}"

#
# Create the postgres database if it does not exist
#
python "drop_postgresql_db" do
  user "postgres"
  code <<-EOH
from subprocess import check_call, check_output

dbname = '#{dbname}'
if not dbname in check_output(['psql', '-c', '\\list']):
    print "Database '{0}' does not exist"
else:
    cmd = ['dropdb', dbname]
    print 'Executing: "{0}"'.format(' '.join(cmd))
    check_call(cmd)
  EOH
end

