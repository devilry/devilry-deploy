.. _update:

==============
Update Devilry
==============

1. Update the ``REVISION`` in the ``extends``-attribute in the ``[buildout]`` section of your
   ``buildout.cfg`` as explained in :ref:`configure_buildout`.

2. Stop Supervisord. If you did not setup an init-script, you can use the PID-file
   in ``/path/to/devilrybuild/var/supervisord.pid`` unless you have configured
   it to be somewhere else. See: :ref:`supervisord-configure`.

3. Run buildout::

    $ bin/buildout "buildout:parts=download-devilryrepo" && bin/buildout
    $ bin/django.py collectstatic --noinput

4. Start Supervisord. If you have not created an init-script (see See:
   :ref:`supervisord-configure`), start Supervisord manually as explained in
   :ref:`run-supervisord-for-production`.
