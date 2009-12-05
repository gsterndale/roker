require 'rubygems'
require 'test/unit'
require 'ruby-debug'
require 'shoulda'
require 'mocha'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'roker'

class Test::Unit::TestCase
  
  def stub_weather_service
    Roker.any_instance.stubs(:weather_xml).returns(File.open(File.join(File.dirname(__FILE__), 'weather_xml.xml'), "r").read)
  end
  
end
