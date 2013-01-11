Description
===========
Set up the devilry platform. It follows the steps described in the *Build
devilry* chapter of the devilry-deploy docs.

Overview of the steps:

- Create a user to run Deviley.


Requirements
============
No requirements.

Attributes
==========

Required
---------
- ``node["django_nginx"]["statichome"]`` - Path to a directory containing a
  subdirectory named ``static/`` where the static files collected by
  ``collectstatic`` is located.

Optional
--------
- ``node["django_nginx"]["gunicorn_port"]`` - The gunicorn port.
  Defaults to ``8002``.
- ``node["django_nginx"]["sitename"]`` - The name of the site
  config placed in ``/etc/nginx/sites-available/``.
  Defaults to ``django``.
- ``node["django_nginx"]["listenaddr"]`` - The listen-address
  for the nginx virtual host. Usually just a port number.
  Defaults to ``80``.



Usage
=====

Add ``"run_list": [ "recipe[devilryprodenv]" ]``. You need to, at least,
configure the ``statichome``-attribute.
