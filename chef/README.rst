We use `Librarian <https://github.com/applicationsonline/librarian>`_ to manage
our cookbooks.  This means that you should not touch any cookbooks in
``cookbooks/``, but rather use Librarian to manage them. To add new chef
cookbooks to Librarian, add them to ``Cheffile``, and run::

    $ cd /path/to/repo/deploy/chef/
    $ librarian-chef install

Refer to the Librarian docs for details, and install instructions.
