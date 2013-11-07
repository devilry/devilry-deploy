## Build for debugging for the configs

    $ virtualenv .
    $ bin/easy_install zc.buildout==2.2.1
    $ bin/buildout


The only real reason to do this instead or in addition to using the Vagrant
test setup, is when debugging the generated config files, like the Supervisord
configs. They are generated in ``parts/``.
