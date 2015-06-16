name             'abiquo-collectd'
maintainer       'Abiquo'
maintainer_email 'ignasi.barrera@abiquo.com'
license          'Apache 2.0'
description      'Installs and configures the Abiquo collectd plugin'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports 'centos'
supports 'ubuntu'

depends 'collectd'
