.. _deploy:

==============
Build devilry
==============
Devilry does not come pre-packaged. Instead, we deploy using `buildout <http://www.buildout.org/>`_.
There is several reasons for that:

- It is easier to maintain deployment through buildout.
- It is easier to customize Devilry when we do not have to force defaults on
  people. With the current method of deployment, admins can easily intergrate
  local devilry addons.
- The method we are using seems to work very well for the Plone CMS.

What this means for you is that you have to setup a very minimal
buildout-config instead of downloading an archive and unzipping it.


Configure buildout
==================
Create a directory that will be used to configure your Devilry build::

    $ mkdir devilrybuild

Create a configuration file named ``buildout.cfg`` in the directory. Add the
following to the configuration file::

    [buildout]
    extends = https://raw.github.com/devilry/devilry-deploy/REVISION/buildout/buildout-base.cfg

Replace ``REVISION`` (in the extends url) with the Devilry version you want to
use (E.g.: ``1.2.1``).


Install required system packages
================================
See :ref:`required-system-packages`.


Intialize the buildout
======================

CD to the directory and run the following commands to download Devilry and
all dependencies into a Python virtualenv. The end result is a
selfcontained devilry build that only depends on the availability of a 
compatible Python interpreter to run. The virtualenv is not affected by
other Python packages installed globally::

    $ cd devilrybuild/
    $ mkdir -p buildoutcache/dlcache
    $ virtualenv --no-site-packages .
    $ bin/easy_install zc.buildout
    $ bin/buildout "buildout:parts=download-devilryrepo" && bin/buildout


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
When you have configured a database in ``devilry_production_settings.py``, you
can use the following command to create your database::

    $ cd /path/to/devilrybuild
    $ bin/django.py syncdb

The script will ask you to create a superuser. Choose a strong password - this
user will have complete access to everything in Devilry.


Test the install
================
See :ref:`debug-devilry-problems`.



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

.. warning::
    Do NOT run supervisord as root. Run it as an unpriviledged used, preferably
    a user that is only used for Devilry. Use the ``supervisord-user``, as shown
    in :ref:`supervisord-configure`, to define a user if running supervisord as
    root.


Configure your webserver
------------------------
You need to configure your webserver to act as a reverse proxy for all URLS
except for the ``/static/``-url. The proxy should forward requests to the
Devilry WSGI server (gunicorn). Gunicorn runs  on ``127.0.0.0:8002``.

The webserver should use SSL.

.. seealso:: :ref:`nginx`.
