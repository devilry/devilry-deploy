**********
Build Trix
**********

.. seealso:: :ref:`vagrant_test_trix`.

    

What is Trix?
=============
Trix is a devilry application that gives students a voluntary "workbench" they
can use to keep track of their progress and coverage in a particular course or
topic. `Read more about Trix <https://github.com/devilry/trix>`_.


Build Trix for production deployment
====================================

Follow the :ref:`devilry deploy guide <deploy>`. When you have Devilry running successfully, follow the steps below.


Update buildout.cfg for Trix
----------------------------
Add the following to your ``buildout.cfg``::

    [buildout]
    ...
    eggs +=
        trix
        trix_simplified
        trix_restful
        trix_extjshelpers

    [devilrydeploy_sources]
    trix = git https://github.com/devilry/trix.git pushurl=git@github.com:devilry/trix.git
    trix_simplified = git https://github.com/devilry/trix_simplified.git pushurl=git@github.com:devilry/trix_simplified.git
    trix_restful = git https://github.com/devilry/trix_restful.git pushurl=git@github.com:devilry/trix_restful.git
    trix_extjshelpers = git https://github.com/devilry/trix_extjshelpers.git pushurl=git@github.com:devilry/trix_extjshelpers.git

You should already have a ``[buildout]``-section, so make sure you do not end
up with two of them.


.. warning:: Make sure you use ``eggs +=`` and NOT ``eggs =``.


Update ``devilry_prod_settings.py`` for Trix
--------------------------------------------
Add the following to your ``devilry_prod_settings.py``::


    INSTALLED_APPS += [
        'trix',
        'trix_extjshelpers',
        'trix_restful',
        'trix_simplified'
    ]

.. warning:: Make sure you use ``INSTALLED_APPS +=`` and NOT ``INSTALLED_APPS =``.


Add custom URLs for Trix
------------------------
Follow the :doc:`custom_root_urls`-guide, and add the following URL for Trix::

    url(r'^trix/', include('trix.urls')),


Update buildout
