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
To test that everything works as expected, you can use the Django devserver. First,
enable debug-mode in your ``devilry_production_settings.py``::

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



Update devilry
==============

1. Update the ``extends``-attribute in the ``[buildout]`` section of your
   ``buildout.cfg``. The last path-segment before ``buildout-base.cfg``
   is the GIT revision (CommmitID, branch or tag).
2. Run buildout::

       $ bin/buildout "buildout:parts=download-devilryrepo" && bin/buildout
       $ bin/django.py collectstatic --noinput
