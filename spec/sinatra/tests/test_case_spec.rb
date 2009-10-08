
require "#{File.dirname(File.dirname(File.expand_path(__FILE__)))}/../spec_helper"


describe "Sinatra" do 
  
  it_should_behave_like "MyTestApp"
  
  # it_should_behave_like "debug => app.methods"
  
  describe "Tests" do 
    
    describe "#self.version" do 
      
      it "should return a string with the version number" do 
        Sinatra::Tests.version.should match(/Sinatra::Tests v\d\.\d\.\d/)
      end
      
    end #/ #version
    
    
    describe "TestCase" do 
      
      describe "#h" do 
        
        it "should be possible to escape output code in tests" do 
          erb_app "<%= 'Unescaped <br> html' %>"
          h(body).should == 'Unescaped &lt;br&gt; html'
        end
        
      end #/ #h
      
      describe "#body" do 
        
        it "should be a shorter way of writing 'last_response.body'" do 
          erb_app "<%= 'Ignored content' %>"
          body.should == 'Ignored content' # just testing to make sure it's OK
          body.should == last_response.body
        end
        
      end #/ #body
      
      describe "#status" do 
        
        it "should be a shorter way of writing 'last_response.status'" do 
          erb_app "<%= 'Ignored content' %>"
          status.should == 200 # just testing the format
          status.should == last_response.status
        end
        
      end #/ #status
      
      describe "#response" do 
        
        it "should be a shorter way of writing 'last_response'" do 
          erb_app "<%= 'Ignored content' %>"
          response.should be_a_kind_of(Rack::MockResponse) # just testing the format
          response.should == last_response
        end
        
      end #/ #response
      
      describe "#erb_app" do 
        
        it "should return the passed output" do 
          erb_app "<%= Time.now.strftime('%Y%d%m') %>"
          body.should == Time.now.strftime("%Y%d%m")
        end
        
        it "should work with a custom layout" do 
          erb_app "<%= Time.now.strftime('%Y%d%m') %>", :layout => "<CUSTOM><%= yield %></CUSTOM>"
          body.should == "<CUSTOM>#{Time.now.strftime("%Y%d%m")}</CUSTOM>"
        end
        
        it "should work with a custom URL" do 
          class MyTestApp
            get '/custom-erb-url' do
              erb "<customurl>#{params[:view]}</customurl>"
            end
          end
          
          erb_app "<%= 'custom-erb-url'.upcase %>", :url => "/custom-erb-url"
          last_request.path_info.should == "/custom-erb-url"
          body.should == "<customurl>CUSTOM-ERB-URL</customurl>"
        end
        
      end #/ #erb_app
      
      describe "#haml_app" do 
        
        it "should return the passed output" do 
          haml_app "= Time.now.strftime('%Y%d%m')"
          body.should == "#{Time.now.strftime("%Y%d%m")}\n"
        end
        
        it "should work with a custom layout" do 
          haml_app "= Time.now.strftime('%Y%d%m')", :layout => "%CUSTOM= yield "
          body.should == "<CUSTOM>#{Time.now.strftime("%Y%d%m")}</CUSTOM>\n"
        end
        
        it "should work with a custom URL" do 
          pending "these tests does not really work. Find out why"
          class MyTestApp
            get '/custom-haml-url' do
              haml "%customurl= @params[:view]"
            end
          end
          
          haml_app "CUSTOM-URL ", :url => "/custom-haml-url"
          last_request.path_info.should == "/custom-haml-url"
          body.should == "<customurl>CUSTOM-URL</customurl>\n"
        end
        
      end #/ #haml_app
      
      
    end #/ TestCase
  end #/ Tests
end #/ Sinatra