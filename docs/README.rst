Build docs
##########
::

    $ virtualenv .
    $ bin/pip install zc.buildout
    $ bin/pip install sphinx_rtd_theme
    $ bin/buildout
    $ bin/sphinxbuilder

The output ends up in ``parts/docs/html/index.html``.
