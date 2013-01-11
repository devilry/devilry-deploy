Description
===========
Set up the devilry platform. It follows the steps described in the *Build
devilry* chapter of the devilry-deploy docs.


Requirements
============
No requirements.

Attributes
==========

- ``node["devilryprodenv"]["git_branch_or_ref"]`` - The branch or git ref (tag,
  commitID, ...) to check out. Defaults to ``"prod"``.

Usage
=====

Add ``"run_list": [ "recipe[devilryprodenv]" ]``.
