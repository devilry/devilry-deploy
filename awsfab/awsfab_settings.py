DEFAULT_REGION = 'eu-west-1'
DEFAULT_ZONE = 'a'
ami = {'ubuntu-12.04-lts': 'ami-c1aaabb5'}

def make_launch_config(description,
                       instance_type,
                       ami):
    return {'description': description,

            # Ami ID (E.g.: ami-fb665f8f)
            'ami': ami,

            # One of: m1.small, m1.large, m1.xlarge, c1.medium, c1.xlarge, m2.xlarge, m2.2xlarge, m2.4xlarge, cc1.4xlarge, t1.micro
            'instance_type': instance_type,

            # List of security groups
            'security_groups': ['default'],

            # Use the ``list_regions`` task to see all available regions
            'region': DEFAULT_REGION,

            # The name of the key pair to use for instances (See http://console.aws.amazon.com -> EC2 -> Key Pairs)
            'key_name': 'devilrydemo',

            # The availability zone in which to launch the instances. This is
            # automatically prefixed by ``region``.
            'availability_zone': 'a',

            # Tags to add to the instances. You can use the ``ec2_*_tag`` tasks or
            # the management interface to manage tags. Special tags:
            #   - Name: Should not be in this dict. It is specified when launching
            #           an instance (needs to be unique for each instance).
            #   - awsfab-ssh-user: The ``awsfab`` tasks use this user to log into your instance.
            'tags': {'awsfab-ssh-user': 'ubuntu'}
           }

EC2_LAUNCH_CONFIGS = {'ubuntu-MICRO': make_launch_config('Ubuntu 12.04 - Micro instance',
                                                         ami=ami['ubuntu-12.04-lts'],
                                                         instance_type='t1.micro'),
                      'ubuntu-SMALL': make_launch_config('Ubuntu 12.04 - Small instance',
                                                         ami=ami['ubuntu-12.04-lts'],
                                                         instance_type='m1.small')}
