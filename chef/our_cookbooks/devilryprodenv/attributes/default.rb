# The branch, tag or commitID to check out
node.default["devilryprodenv"]["devilry_version"] = "master"


# The username and group
node.default["devilryprodenv"]["username"] = "devilryrunner"
node.default["devilryprodenv"]["groupname"] = "devilryrunner"
node.default["devilryprodenv"]["homedir"] = "/home/#{node.devilryprodenv.username}"

# Settings
node.default["devilryprodenv"]["settings"]["SECRET_KEY"] = "" # set this to something random, and keep it secret
node.default["devilryprodenv"]["settings"]["DEBUG"] = "True"
node.default["devilryprodenv"]["settings"]["DBBACKEND"] = "django.db.backends.postgresql_psycopg2"
node.default["devilryprodenv"]["settings"]["DBNAME"] = "" # Required
node.default["devilryprodenv"]["settings"]["DBUSER"] = "" # Required for backends except sqlite3
node.default["devilryprodenv"]["settings"]["DBPASSWORD"] = "" # Required for backends except sqlite3
node.default["devilryprodenv"]["settings"]["DBHOST"] = "localhost"
node.default["devilryprodenv"]["settings"]["DBPORT"] = "" # not required - defaults to the default database port for the backend
node.default["devilryprodenv"]["settings"]["DEVILRY_SYNCSYSTEM"] = "The Devilry demo syncsystem"
node.default["devilryprodenv"]["settings"]["DEVILRY_FSHIERDELIVERYSTORE_ROOT"] = "/devilry-filestorage"
node.default["devilryprodenv"]["settings"]["USE_UNIVERSITY_TERMS"] = true
