
require "#{File.dirname(File.dirname(File.expand_path(__FILE__)))}/../spec_helper"


describe "Sinatra" do 
  
  it_should_behave_like "MyTestApp"
  
  describe "Tests" do 
    
    describe "VERSION" do 
      
      it "should return the VERSION string" do 
        Sinatra::Tests::VERSION.should be_a_kind_of(String)
        Sinatra::Tests::VERSION.should match(/\d\.\d+\.\d+(\.\d)?/)
      end
      
    end #/ VERSION
    
    describe "#self.version" do 
      
      it "should return a string with the version number" do 
        Sinatra::Tests.version.should match(/Sinatra::Tests v\d\.\d\.\d/)
      end
      
    end #/ #version
    
  end #/ Tests
  
end #/ Sinatra
