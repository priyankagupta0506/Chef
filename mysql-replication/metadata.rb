name 'mysql-replication'
maintainer 'Pavel Yudin'
maintainer_email 'pyudin@parallels.com'
license 'Apache 2.0'
description 'Installs/Configures mysql-replication'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.0.0'
issues_url 'https://github.com/parallels-cookbooks/mysql-replication/issues'
source_url 'https://github.com/parallels-cookbooks/mysql-replication'

supports 'amazon'
supports 'redhat'
supports 'centos'
supports 'scientific'
supports 'fedora'
supports 'debian'
supports 'ubuntu'

depends 'mysql'
