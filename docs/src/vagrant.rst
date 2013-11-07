.. _vagrant:

=================================
Test Devilry locally with Vagrant
=================================

You can deploy a complete Devilry demo in a local VirtualBox machine
with just a couple of commands.


Install VirtualBox and Vagrant
==============================
See `the Vagrant website <http://www.vagrantup.com/>`_. The getting started
guide explains about VirtualBox and where to download it.


Get the sources
===============
Clone the sources for ``devilry-deploy``. You find them at our `GitHub project
page <https://github.com/devilry/devilry-deploy>`_


Create a vagrant box
====================
::

  $ cd vagrant/
  $ vagrant up

When the box is up, you can visit Devilry at http://localhost:9090. Login
with one of::

- ``thor`` (student, examiner and courseadmin) - Since the current release is focused on the subject admin UI, this is probably the user you want to be using.
- ``dewey`` (student) - Use this instead of thor if you really want to test the student UI.
- ``donald`` (examiner)
- ``grandma`` (superuser)

or go to http://localhost:9090/devilry_sandbox/createsubject-intro.


Tips
====
Re-provisioning a lot, and tired of waiting for ``dev_autodb``? Edit
``chef/our_cookbooks/devilrydemo/recipes/default.rb``, and change the
``dev_autodb``-line to::

  bin/django.py dev_autodb --no-groups > /tmp/devilrydemo-dev_autodb.log

Just make sure you do not commit this change.
