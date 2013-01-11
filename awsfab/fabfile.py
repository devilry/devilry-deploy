from os.path import dirname, abspath, join
from fabric.api import sudo
from fabric.api import task
from fabric.api import run
from fabric.api import cd
from fabric.api import abort
from fabric.contrib.console import confirm
from awsfabrictasks.ec2.api import ec2_rsync_upload
from awsfabrictasks.ec2.api import Ec2InstanceWrapper


this_dir = dirname(abspath(__file__))

#: Path to /reporoot/deploy
LOCAL_CHEFDIR = join(dirname(this_dir), 'chef') # ../chef/

#: The remote tempdir where we store deployment files. This can safely be
#: removed at any time (will just be re-synced on next deploy).
REMOTE_TEMPDIR = '/tmp/awsfab-deploy-temp'
REMOTE_CHEFDIR = join(REMOTE_TEMPDIR, 'chef')


@task
def install_chefclient():
    """
    Install chef-client using the official opscode installer.
    """
    sudo('curl -L http://www.opscode.com/chef/install.sh | sudo bash')


def _create_remote_tempdir():
    run('mkdir -p {0}'.format(REMOTE_TEMPDIR))

def _create_chefsolo_cachedir():
    sudo('mkdir -p /tmp/chef-solo-cache')


@task
def rsync_deploydir():
    """
    Creates a tempdir, and rsyncs the ``/reporoot/chef/`` dir into it.
    """
    _create_remote_tempdir()
    ec2_rsync_upload(LOCAL_CHEFDIR, REMOTE_CHEFDIR,
                     sync_content=True,
                     rsync_args=('-av --delete'))

@task
def chef_deploy(nodeconf):
    """
    Deploy the specified ``nodeconf``.

    :param nodeconf: The name of a file in ``../chef/nodes/``.
    """
    from os.path import exists

    localpath = join(LOCAL_CHEFDIR, 'nodes', nodeconf)
    if not exists(localpath):
        abort('The specified node-config ({0}) does not exist.'.format(localpath))



    # Confirm deploy
    print '{sep} About to deploy {nodeconf} {sep}'.format(sep='='*20, nodeconf=nodeconf)
    print open(localpath, 'rb').read()
    print '<'*20
    instancewrapper = Ec2InstanceWrapper.get_from_host_string()
    nametag = instancewrapper.instance.tags.get('Name')
    confirmmsg = 'Really deploy "{nodeconf}" on EC2 instance "{nametag}"?'.format(nodeconf=nodeconf, nametag=nametag)
    if not confirm(confirmmsg, default=True):
        abort('Aborted')

    # The actual deploy code
    rsync_deploydir()
    _create_chefsolo_cachedir()
    with cd(REMOTE_CHEFDIR):
        sudo('chef-solo -c {chefdir}/chefsolo.rb -j {chefdir}/nodes/{nodeconf}'.format(chefdir=REMOTE_CHEFDIR, nodeconf=nodeconf))

    print 'Deploy of {nametag} complete. Visit the instance at:'.format(**vars())
    print
    print '    http://{0}'.format(instancewrapper.instance.public_dns_name)
    print
    print 'Login with:'
    print '   username: grandma'
    print '   password: test'


@task
def cleanup_deploytemp():
    """
    Remove the remote tempdir. This is harmless, but only useful for debugging.
    If the cache (which is part up the tempdir) is removed, subsequent deploys
    will take extra time.
    """
    sudo('rm -r {0}'.format(REMOTE_TEMPDIR))





#####################
# Import awsfab tasks
#####################
from awsfabrictasks.ec2.tasks import *
from awsfabrictasks.regions import *
from awsfabrictasks.conf import *
