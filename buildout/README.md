## Build for debugging for the configs


Create cache directories
-------------------------
    
    $ mkdir -p buildoutcache/dlcache buildoutcache/eggs

Build buildout
--------------------

    $ virtualenv .
    $ bin/easy_install zc.buildout==1.7.1
    $ bin/buildout
