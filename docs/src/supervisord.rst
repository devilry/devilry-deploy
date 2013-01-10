.. _supervisord-configure:

=============================================
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
