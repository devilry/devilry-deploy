.. _supervisord-configure:

=============================================
Configure supervisord (logging, pidfile, ...)
=============================================
We handle all logging through Supervisord, so you will probably at least want
to configure where we log to.

Supervisor variables are now iniatially defined in the ``variables``
section in ``buildout-base.cfg`` and can be overridden by adding a ``variables``
section in your own buildout config file. Logging directory and rotation parameters
should be redefined accordingly.


    [variables]
    # The full path to the supervisord log directory.
    # Defaults to /path/to/devilrybuild/var/log/
    # Note: This setting is added by our buildout-base.cfg, and not by the
    #       supervisor buildout recipe.
    #logdir = 

    # Where logs are placed on the filesystem
    logdir = ${buildout:directory}/var/log
    
    Max number of bytes in a single log
    logfile-maxbytes = 50MB
    
    # Number of times a log rotates - note that each program running under
    # supervisor has 2 logs (stdout and stderr), and each log will consume
    # ``logfile-maxbytes * logfile-backups`` of disk space.
    logfile-backups = 30

Rebuild the Supervisord config (output in ``parts/supervisor/supervisord.conf``)::

    $ bin/buildout

And restart supervisord.

See the `Buildout recipe <http://pypi.python.org/pypi/collective.recipe.supervisor/>`_
and the `Supervisord docs <http://supervisord.org/>`_ for more details.


.. _supervisord-initscript:

Init script
===========
The following init script works well. You need to adjust the ``DAEMON``-variable (`download <_static/supervisord>`_):

.. literalinclude:: /_static/supervisord
    :language: bash


Harden supervisord
==================

The default configuration if for a dedicated server. Supervisorctl uses a
password with the local Supervisord server, which needs to be a better password
in a shared environment. This should not be a problem since it is madness to 
host Devilry on a shared host in any case, but if you need to harden Supervisord,
refer to the docs linked above.
