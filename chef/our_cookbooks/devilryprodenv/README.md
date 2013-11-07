Description
===========
Set up the devilry platform. It follows the steps described in the *Build
devilry* chapter of the devilry-deploy docs.

Overview of the steps:

- Create a user to run Deviley.


Requirements
============
No requirements.

Attributes
==========

Devilry version
---------------
- ``node["devilryprodenv"]["devilry_version"]`` - The version of
  ``devilry-deploy`` to use. Can be branchname, tag or CommitID.
  Defaults to ``master``, which is our development branch, and should not be
  used in production.  We recommend that you use a tag-name (we tag each
  release, mirroring the Devilry version), and update the version manually.

System user
-----------
- ``node["devilryprodenv"]["username"]`` - The username of the system user
  that runs Devilry. This user will be created.
- ``node["devilryprodenv"]["groupname"]`` - The group of the user.
- ``node["devilryprodenv"]["homedir"]`` - The HOME-directory of the user.

Init script
-----------
- ``node["devilryprodenv"]["supervisord_servicename"]`` - The 
  name of the init-script (we create ``/etc/init.d/NAME``).
  Defaults to ``supervisord``.

Buildout
--------
- ``node["devilryprodenv"]["gunicorn"]`` - Map of overrides for the
  ``[gunicorn]``-section.
- ``node["devilryprodenv"]["supervisor"]`` - Map of overrides for the
  ``[supervisor]``-section.
- ``node["devilryprodenv"]["supervisor"]["pidfile"]`` -
  Defaults to ``/var/run/SERVICENAME.pid``. SERVICENAME is configured
  in ``node["devilryprodenv"]["supervisord_servicename"]``.
- ``node["devilryprodenv"]["variables"]["logdir"]`` - Defaults
  to ``/var/log/devilry``. Created if it does not exist.
  The ``node["devilryprodenv"]["username"]``-user must have write
  permissions to this directory.



Devilry settings
----------------
- ``node["devilryprodenv"]["devilry"]["settings"]`` - Map of Django settings
  for Devilry. The only types supported are boolean and strings, so complex
  settings that use lists or maps will require patching of this
  recipe.
- ``node["devilryprodenv"]["devilry"]["use_university_terms"]`` - Boolean
  that configures if we should include the settings that enable university
  terms. Defaults to ``true``.
- ``node["devilryprodenv"]["devilry"]["database"]`` - Map of Django database
  settings for the default database.
- ``node["devilryprodenv"]["devilry"]["database"]["ENGINE"]``
  Defaults to ``"django.db.backends.postgresql_psycopg2"``.
- ``node["devilryprodenv"]["devilry"]["extra_installed_apps"]``
  List of extra apps for the ``INSTALLED_APPS``-setting.
  This list is appended to the default list provided by Devilry.
- ``node["devilryprodenv"]["devilry"]["extra_urls"]``
  List of extra url-configs for the Devilry urlconf.

Unsafe settings - leave to their default unless you know what you are doing:
- ``node["devilryprodenv"]["devilry"]["use_insecure_fast_passwordhasher"]`` - Boolean
  that configures Devilry to use MD5 password hasher. This should never be
  used in production, but it is really nice for demos when you need to
  generate data because it speeds up generating data a log (at least 5x).



Usage
=====

Add ``"run_list": [ "recipe[devilryprodenv]" ]``. You need to, at least,
configure:

- the Devilry version. 
- the database.
- the ``SECRET_KEY`` - Make sure you choose a random the secret key, and keep
  it secret. If you secret key is compromized, all sessions will be
  vulnerable to attack.

Example:

    "devilryprodenv": {
      "devilry_version": "1.2.1",
      "devilry": {
        "database": {
          "NAME": "djangodb",
          "USER": "djangouser",
          "PASSWORD": "supersecret",
          "HOST": "localhost"
        },
        "settings": {
          "SECRET_KEY": "+g$%**q(w78xqa_2)(_+%v8d)he-b_^@d*pqhq!#2p*a7*9e9h"
        }
      }
    }


A more complete example:

    "devilryprodenv": {
      "devilry_version": "1.2.1",
      "supervisor": {
        "logfile-backups": 10,
        "logfile-maxbytes": "100MB",
        "logdir": "/var/log/devilry"
      },
      "gunicorn": {
        "address": "0.0.0.0",
        "workers": "4"
      },
      "devilry": {
        "database": {
          "NAME": "djangodb",
          "USER": "djangouser",
          "PASSWORD": "supersecret",
          "HOST": "localhost"
        },
        "settings": {
          "SECRET_KEY": "+g$%**q(w78xqa_2)(_+%v8d)he-b_^@d*pqhq!#2p*a7*9e9h",
          "DEBUG": true,
          "DEVILRY_SYNCSYSTEM": "The Devilry demo syncsystem"
        }
      }
    }
