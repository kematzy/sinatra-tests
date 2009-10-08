require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'sinatra/tests'

Spec::Runner.configure do |config|
  config.include RspecHpricotMatchers
  config.include Sinatra::Tests::SharedSpecs
end


# quick convenience methods..

def fixtures_path
  "#{File.dirname(File.expand_path(__FILE__))}/fixtures"
end

class MyTestApp < Sinatra::Base
  register(Sinatra::Tests)
end
  
class MyAdminTestApp < MyTestApp
  # register(Sinatra::Tests)
end


class Test::Unit::TestCase
  include Sinatra::Tests::TestCase
  
  Sinatra::Base.set :environment, :test
  
end
