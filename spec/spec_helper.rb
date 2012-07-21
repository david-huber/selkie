lib_dir = File.join(File.dirname(__FILE__), '..', 'lib', 'selkie')


RSpec.configure do |config|
  config.libs = [lib_dir]
end
