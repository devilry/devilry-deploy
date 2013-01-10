.. _buildout-init:

Intialize
=========

Create a directory that will be used to configure Devilry::

    $ mkdir devilry

Create a configuration file named ``buildout.cfg`` in the directory. Add the
following to the configuration file::

    [buildout]
    extends = buildout-base.cfg

Then CD to the directory and run the following commands to download Devilry and
all dependencies into a Python virtualenv. The end result is a
selfcontained devilry buildout that only depends on the availability of a 
compatible Python interpreter to run. The virtualenv is not affected by
other Python packages installed globally::

    $ cd devilry/
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


Update devilry
==============

1. Update the ``rev`` in the ``[devilry]`` section of your ``buildout.cfg``. The
   ``rev`` is a GIT devision ID.
2. Run buildout::

       bin/buildout "buildout:parts=download-devilryrepo" && bin/buildout
