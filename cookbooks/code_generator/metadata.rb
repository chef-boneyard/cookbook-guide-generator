name             'code_generator'
maintainer       'Partner Engineering at Chef Software, Inc.'
maintainer_email 'partnereng@chef.io'
license          'Apache-2.0'
description      'Generates the a cookbook for the cookbook-guide'
long_description 'Generates the a cookbook for the cookbook-guide'
version          '1.1.2'

%w[aix amazon centos fedora freebsd debian oracle mac_os_x redhat suse opensuse opensuseleap ubuntu windows zlinux].each do |os|
  supports os
end

issues_url 'https://github.com/chef-partners/cookbook-guide-generator/issues'
source_url 'https://github.com/chef-partners/cookbook-guide-generator'
