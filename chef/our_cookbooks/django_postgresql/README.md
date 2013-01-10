Description
===========
Set up postgres for Django.


Requirements
============

- ``"recipe[postgresql::client]"``
- ``"recipe[postgresql::server]"``

Attributes
==========

- ``node["django_postgresql"]["dbname"]`` - The postgres database. Created if it does not exist.
- ``node["django_postgresql"]["username"]`` - The postgres username. A user (role) with this name is created if it does not exist.
- ``node["django_postgresql"]["password"]`` - The password of the user specified by the username-attribute.

Usage
=====

Add ``"run_list": [ "recipe[django_postgresql]" ]``.
