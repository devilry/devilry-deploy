Build docs
##########
::

    $ virtualenv .
    $ bin/easy_install zc.buildout
    $ bin/buildout
    $ bin/sphinxbuilder

The output ends up in ``parts/docs/html/index.html``.
