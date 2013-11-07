# The branch, tag or commitID to check out
node.default["devilryprodenv"]["devilry_version"] = "latest-stable"
node.default["devilryprodenv"]["devilry_rev"] = "origin/latest-stable"

node.default["devilryprodenv"]["install_whoosh"] = false

# The username and group
node.default["devilryprodenv"]["username"] = "devilryrunner"
node.default["devilryprodenv"]["groupname"] = "devilryrunner"
node.default["devilryprodenv"]["homedir"] = "/home/#{node.devilryprodenv.username}"
node.default["devilryprodenv"]["devilrybuild_dir"] = "#{node.devilryprodenv.homedir}/devilrybuild"


# Supervisor
node.default["devilryprodenv"]["gunicorn"] = {}
node.default["devilryprodenv"]["variables"] = {}
node.default["devilryprodenv"]["variables"]["logdir"] = "/var/log/devilry"
node.default["devilryprodenv"]["supervisord_servicename"] = "supervisord"
node.default["devilryprodenv"]["supervisor"] = {}
node.default["devilryprodenv"]["supervisor"]["pidfile"] = "/var/run/#{node.devilryprodenv.supervisord_servicename}.pid"

# Devilry settings
node.default["devilryprodenv"]["devilry"]["use_university_terms"] = true
node.default["devilryprodenv"]["devilry"]["use_insecure_fast_passwordhasher"] = false
node.default["devilryprodenv"]["devilry"]["database"]["ENGINE"] = "django.db.backends.postgresql_psycopg2"
node.default["devilryprodenv"]["devilry"]["settings"]["DEVILRY_FSHIERDELIVERYSTORE_ROOT"] = "/devilry-filestorage"
node.default["devilryprodenv"]["devilry"]["extra_installed_apps"] = []
node.default["devilryprodenv"]["devilry"]["extra_urls"] = []
