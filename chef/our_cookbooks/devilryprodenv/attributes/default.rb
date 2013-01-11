# The branch, tag or commitID to check out
node.default["devilryprodenv"]["devilry_version"] = "master"


# The username and group
node.default["devilryprodenv"]["username"] = "devilryrunner"
node.default["devilryprodenv"]["groupname"] = "devilryrunner"
node.default["devilryprodenv"]["homedir"] = "/home/#{node.devilryprodenv.username}"

# Supervisor
node.default["devilryprodenv"]["gunicorn"] = {}
node.default["devilryprodenv"]["supervisor"] = {}

# Devilry settings
node.default["devilryprodenv"]["devilry"]["use_university_terms"] = true
node.default["devilryprodenv"]["devilry"]["database"]["ENGINE"] = "django.db.backends.postgresql_psycopg2"
node.default["devilryprodenv"]["devilry"]["settings"]["DEVILRY_FSHIERDELIVERYSTORE_ROOT"] = "/devilry-filestorage"
