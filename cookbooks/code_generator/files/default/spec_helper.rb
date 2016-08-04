require 'chefspec'
require 'chefspec/berkshelf'

at_exit { ChefSpec::Coverage.report! }

LOG_LEVEL = :fatal
UBUNTU_OPTS = {
  platform: 'ubuntu',
  version: '16.04',
  log_level: LOG_LEVEL,
  file_cache_path: '/tmp'
}.freeze
