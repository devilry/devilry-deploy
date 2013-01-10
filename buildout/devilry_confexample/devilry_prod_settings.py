from os.path import join, abspath, dirname

# Import the default settings from devilry
from devilry_settings.default_settings import *

# The directory containing _this_ file - useful if you configure paths relative to this directory
this_dir = abspath(dirname(__file__))

# Make this unique, and don't share it with anybody.
SECRET_KEY = '+g$%**q(w78xqa_2)(_+%v8d)he-b_^@d*pqhq!#2p*a7*9e9h'

## Nice to have this set to True while you are setting up devilry, however set
## it to False for production
DEBUG = True
EXTJS4_DEBUG = DEBUG
TEMPLATE_DEBUG = DEBUG


#############################################
# Configure the database
#############################################
DATABASES = {}

## Example config for SQLite (see also PostgreSQL below)
DATABASES["default"] = {
    'ENGINE': 'django.db.backends.sqlite3',

    # Path to sqlite database file - created by syncdb if it does not exist
    #'NAME': '/path/to/mydb.sqlite3'
    'NAME': join(this_dir, 'mydb.sqlite3') # put the DB in the same dir as this file - probably no a good idea in production
}

## Example config for PostgreSQL
#DATABASES["default"] = {
   #'ENGINE': 'django.db.backends.postgresql_psycopg2',
   #'NAME': 'devilry', # Name of the database
   #'USER': 'devilryuser', # Database user
   #'PASSWORD': 'supersecret', # Password of database user
   #'HOST': 'localhost',
   #'PORT': '', # Set to empty string for default.
#}


###############################
# Configure file upload storage
###############################
## Where do we store files that students deliver?
#DEVILRY_FSHIERDELIVERYSTORE_ROOT = '/var/devilry-filestorage'
# put the files in a subdirectory of the directory containing this file - probably not a good idea in production
DEVILRY_FSHIERDELIVERYSTORE_ROOT = join(this_dir, 'filestorage')


#####################################################################
# Syncsystem - name of a system that dumps data into Devilry
#####################################################################
## You can dump students and examiners into devilry. This setting is where
## the system tells users that this data comes from.
#DEVILRY_SYNCSYSTEM = 'FS (Felles Studentsystem)'


##################################################################################
# Make Devilry speak in typical university terms (semester instead of period, ...)
##################################################################################
INSTALLED_APPS += ['devilry_university_translations']
DEVILRY_JAVASCRIPT_LOCALE_OVERRIDE_APPS = ('devilry_university_translations',)


#######################################################
# Email
# - The default is to "send" emails to stdout. This is useful when
#   checking if email works, however you should change it to SMTP in production
#######################################################
#EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
#EMAIL_HOST = 'smtp.example.com'
#EMAIL_PORT = 25

## Email addresses
#DEVILRY_EMAIL_DEFAULT_FROM = 'devilry-support@example.com'
#DEVILRY_SYSTEM_ADMIN_EMAIL = 'devilry-admin@example.com'

## The urlscheme+domain where devilry is located. Used when sending links to users via email.
## DEVILRY_SCHEME_AND_DOMAIN+DEVILRY_URLPATH_PREFIX is the absolute URL to the devilry
## instance. WARNING: must not end with /
#DEVILRY_SCHEME_AND_DOMAIN = 'https://devilry.example.com'
