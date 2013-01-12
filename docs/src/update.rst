.. _update:

==============
Update devilry
==============

.. seealso:: 

1. Update the ``extends``-attribute in the ``[buildout]`` section of your
   ``buildout.cfg``. The last path-segment before ``buildout-base.cfg``
   is the GIT revision (CommmitID, branch or tag).

2. Stop Supervisord. You will find the PID in ``/path/to/devilrybuild/var/supervisord.pid`` unless
   you have configured it to be places somewhere else. See: :ref:`supervisord-configure`.

3. Run buildout::

    $ bin/buildout "buildout:parts=download-devilryrepo" && bin/buildout
    $ bin/django.py collectstatic --noinput

4. Start Supervisord. See :ref:`run-supervisord-for-production`.
