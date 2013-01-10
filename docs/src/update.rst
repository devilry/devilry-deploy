==============
Update devilry
==============

1. Update the ``extends``-attribute in the ``[buildout]`` section of your
   ``buildout.cfg``. The last path-segment before ``buildout-base.cfg``
   is the GIT revision (CommmitID, branch or tag).
2. Run buildout::

       $ bin/buildout "buildout:parts=download-devilryrepo" && bin/buildout
       $ bin/django.py collectstatic --noinput
