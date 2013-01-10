.. _buildout-init:


Requirements
============

Virtualenv
----------
TODO

PostgresSQL (or another database supported by Django)
-----------------------------------------------------
http://packages.python.org/psycopg2/install.html#install-from-source
TODO: Not using postgres section (``parts -= psycopg2``)


Configure buildout
==================
Create a directory that will be used to configure Devilry::

    $ mkdir devilrybuild

Create a configuration file named ``buildout.cfg`` in the directory. Add the
following to the configuration file::

    [buildout]
    extends = buildout-base.cfg



Intialize
=========

CD to the directory and run the following commands to download Devilry and
all dependencies into a Python virtualenv. The end result is a
selfcontained devilry buildout that only depends on the availability of a 
compatible Python interpreter to run. The virtualenv is not affected by
other Python packages installed globally::

    $ cd devilrybuild/
    $ mkdir -p buildoutcache/dlcache
    $ virtualenv --no-site-packages .
    $ bin/easy_install zc.buildout
    $ bin/buildout "buildout:parts=download-devilryrepo" && bin/buildout

Because everything in ``devilry/`` is generated from your ``buildout.cfg``,
which refers to a specific revision of the Devilry repository, you can safely
delete ``devilry/`` (as long as you backup your ``buildout.cfg``) and re-run
the commands above. This also means that you just need to backup the buildout
and django config files along with the files and the database to be able to
re-deploy an exact copy of the system.


Configure Devilry
=================
To configure Devilry, you need to create a Python module containing a
config-file named ``devilry_prod_settings.py``. First create a directory for
your Devilry configurations::

    $ mkdir /etc/devilry

turn the directory into a Python module::

    $ touch /etc/devilry/__init__.py

and add your own ``devilry_production_settings.py`` to the directory::

    TODO


Create the database
===================
When you have configured a database, you can use the following command to 
create your database::

    $ cd /path/to/devilrybuild
    $ bin/django.py syncdb

The script will ask you to create a superuser. Choose a strong password - this
user will have complete access to everything in Devilry.


Test the install
================
See :ref:`debug-devilry-problems`.



.. _debug-devilry-problems:

Debug Devilry problems
======================

To test that everything works as expected, you can use the Django devserver in
DEBUG-mode. The devserver serves static files, so you do not need a webserver.
It does not use SSL, so be VERY careful when running it on an extrnal NIC (like
the example with ``0.0.0.0`` below).

First, enable debug-mode in your ``devilry_production_settings.py``::

    DEBUG = True

Then run the devserver::

    $ bin/django.py runserver

and open http://localhost:8000. You can tell the testserver to allow external
connections, and to listen on another port with::

    $ bin/django.py runserver 0.0.0.0:9000 --insecure

.. warning::
    NEVER use the devserver or ``DEBUG=True`` in production. It is insecure and
    slow.

.. note::
    Some browsers have issues with loading the Devilry javascript sources
    from the devserver. We recommend that you use a recent version of
    Chrome, Firefox or Safari if you have problems.


Setup Devilry for production
============================
Collect all static files in the ``static/``-subdirectory::

    $ bin/django.py collectstatic


Make sure all services work as excpected
----------------------------------------
All Devilry services is controlled to Supervisord. This does not include your
database or webserver.

To run supervisord in the foreground for testing/debugging, enable DEBUG-mode
(see :ref:`debug-devilry-problems`), and  run::

    $ bin/supervisord -n

Make sure you disable DEBUG-mode afterwards.


Run Supervisord for production
-------------------------------

To run supervisord in the background with a PID, run::

    $ bin/supervisord

See :ref:`supervisord-configure` to see and configure where the PID-file is
written.


Configure your webserver
------------------------
You need to configure your webserver to act as a reverse proxy for all URLS
except for the ``/static/``-url. The proxy should forward requests to the
Devilry WSGI server (gunicorn). Gunicorn runs  on ``127.0.0.0:8002``.

The webserver should use SSL.


Configure Nginx
---------------
For Nginx, you should use something like this (not a complete config file, just
the location sections that you should add to your config)::

    location /static {
        # Show directory index.
        autoindex  on;

        # NOTE from: http://wiki.nginx.org/HttpCoreModule#root
        # Keep in mind that the root will still append the directory
        # to the request so that a request for "/i/top.gif" will not look
        # in "/spool/w3/top.gif" like might happen in an Apache-like alias
        # configuration where the location match itself is dropped. Use the
        # alias directive to achieve the Apache-like functionality.
        root /path/to/devilrybuild;
    }

    location / {
        proxy_pass       http://127.0.0.1:8002;
        proxy_set_header Host $host:$server_port;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-DEVILRY_USE_EXTJS true;

        # SSL options
        proxy_set_header X-FORWARDED-PROTOCOL ssl;
        proxy_set_header X-FORWARDED-SSL on;
        proxy_headers_hash_max_size 1024;
        proxy_headers_hash_bucket_size 256;
        proxy_set_header X-Forwarded-Proto https;
    }

We recommend Nginx because it is fast, lightweight, secure and easy to setup.



Update devilry
==============

1. Update the ``extends``-attribute in the ``[buildout]`` section of your
   ``buildout.cfg``. The last path-segment before ``buildout-base.cfg``
   is the GIT revision (CommmitID, branch or tag).
2. Run buildout::

       $ bin/buildout "buildout:parts=download-devilryrepo" && bin/buildout
       $ bin/django.py collectstatic --noinput




.. _supervisord-configure:

Configure supervisord (logging, pidfile, ...)
=============================================
We handle all logging through Supervisord, so you will probably at least want
to configure where we log to.

You configure supervisord through your ``buildout.cfg``. Add a
``supervisor``-section, and tune the settings::

    [supervisor]
    # The full path to the supervisord log file.
    # Defaults to /path/to/devilrybuild/var/log/supervisord.log
    #logfile = 

    # The full path of the directory where log files of processes managed by
    # Supervisor while be stored. Defaults to /path/to/devilrybuild/var/log
    #childlogdir =

    # The pid file of supervisord. Defaults to
    # /path/to/devilrybuild/var/supervisord.pid
    #pidfile =

    # The maximum number of bytes that may be consumed by the activity log file
    # before it is rotated. Defaults to 50MB.
    #logfile-maxbytes =

    # The number of backups to keep around resulting from activity log file
    # rotation. Defaults to 30.
    #logfile-backups = 

Rebuild the Supervisord config (output in ``parts/supervisor/supervisord.conf``)::

    $ bin/buildout

And restart supervisord.

See the `Buildout recipe <http://pypi.python.org/pypi/collective.recipe.supervisor/>`_
and the `Supervisord docs <http://supervisord.org/>`_ for more details.
