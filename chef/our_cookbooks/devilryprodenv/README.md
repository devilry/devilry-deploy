Description
===========
Set up the devilry platform. Creates:

- The ``devilryrunner`` user and group with ``/home/devilryrunner/`` as home
  directory.
- Checks out the git repo.
- Create a virtualenv and initialize the devilry platform using buildout in
  ``prodenv_#{node.devilryprodenv.prodenvname}`` (see attributes).

Requirements
============
No requirements.

Attributes
==========

- ``node["devilryprodenv"]["git_branch_or_ref"]`` - The branch or git ref (tag,
  commitID, ...) to check out. Defaults to ``"prod"``.
- ``node["devilryprodenv"]["prodenvname"]`` - The string to add to ``prodenv_`` to determine
  the production environment to deploy. Defaults to ``default``, which means that
  we use ``prodenv_default/`` by default.

Usage
=====

Add ``"run_list": [ "recipe[devilryprodenv]" ]``.
