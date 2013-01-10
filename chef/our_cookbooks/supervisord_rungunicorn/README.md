Description
===========
Set up a supervisord programs (in ``/etc/supervisor/conf.d/``) for gunicorn
and nginx.

Requirements
============
- ``devilryprodenv`` - We use the ``prodenvdir`` and ``username`` attributes from
  ``devilryprodenv``.

Attributes
==========
- ``node.supervisord_rungunicorn.gunicorn_port``: The port to run gunicorn on.

Usage
=====
Add ``"run_list": [ "recipe[supervisord_rungunicorn]" ]``.
