dbname = "#{node.django_postgresql.dbname}"
dbdump_path = "#{node.django_postgresql.dbdump_path}"
username = "#{node.django_postgresql.username}"


#
# Create the postgres database if it does not exist
#
python "load_posgres_dump" do
  user "postgres"
  code <<-EOH
from subprocess import check_call

dbdump_path = '#{dbdump_path}'
dbname = '#{dbname}'
cmd = ['psql', '-d', dbname, '-f', dbdump_path]
print 'Loading database from dumpfile "{0}". Executing: "{1}"'.format(dbdump_path, ' '.join(cmd))
check_call(cmd)
  EOH
end


python "set_correct_database_owner" do
  user "postgres"
  code <<-EOH
from subprocess import check_output, check_call

dbname = '#{dbname}'
username = '#{username}'
listtables_cmd = ['psql', '-qAt', '-c', "select tablename from pg_tables where schemaname = 'public';", dbname]
tables = check_output(listtables_cmd).strip().split()
if len(tables) == 0:
    raise Exception('No tables found by: {}'.format(' '.join(listtables_cmd)))
for table in tables:
    cmd = ['psql', '-c', 'alter table {} owner to {}'.format(table, username), dbname]
    check_call(cmd)
  EOH
end
