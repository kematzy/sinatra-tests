

module Sinatra 
  module Tests
    
    module RSpec
      
      # == Shared Specs
      # 
      # === DEBUG
      # 
      # * <b><tt>it_should_behave_like "debug => app.methods"</tt></b>
      #   
      #   dumps a list of methods for the current <tt>app</tt>
      #   
      # * <b><tt>it_should_behave_like "debug"</tt></b>
      #   
      #   tests the body output for a <tt><debug></tt> tag.
      # 
      # 
      # === RESPONSE
      #   
      # * <b><tt>it_should_behave_like "HTTP headers"</tt></b>
      #   
      #   checks that we got a 200 status (OK), and content-type is <tt>text/html</tt>
      # 
      # * <b><tt>it_should_behave_like "HTML"</tt></b>
      #   
      #   checks that we got a 200 status (OK), and content-type is <tt>text/html</tt>
      # 
      # * <b><tt>it_should_behave_like "CSS"</tt></b>
      #   
      #   checks that we got a 200 status (OK), and content-type is <tt>text/css</tt>
      # 
      # 
      # === HTML OUTPUT
      # 
      # * <b><tt>it_should_behave_like "div#main-content"</tt></b>
      #   
      #   checks that the page has a <tt><div id="main-content"></div></tt>
      # 
      # * <b><tt>it_should_behave_like "div#main-content > h2"</tt></b>
      #   
      #   checks that the page has an <tt><h2></tt> tag within the <tt><div id="main-content"></div></tt> 
      # 
      # 
      # ==== ADMIN SECTION
      # 
      # * <b><tt>it_should_behave_like "div.admin-section-header > div.actions > h4 with HELP"</tt></b>
      #   
      #   checks that the page has an...
      # 
      # 
      # ==== FORMS
      # 
      # * <b><tt>it_should_behave_like "forms > faux method > input.hidden"</tt></b>
      #   
      #   checks that the page has a form with a <tt><input type="hidden"...></tt> tag
      # 
      module SharedSpecs 
        
        include Sinatra::Tests::RSpec::Matchers
        
        # :stopdoc:
         
        share_examples_for 'MyTestApp' do 
          
          before(:each) do 
            class ::Test::Unit::TestCase 
              def app; ::MyTestApp.new ; end
            end
            @app = app
          end
          
          after(:each) do 
            class ::Test::Unit::TestCase 
              def app; nil ; end
            end
            @app = nil
          end
          
          describe "Sanity" do 
            
            it "should be a MyTestApp kind of app" do 
              #  FIXME:: HACK to prevent errors due to stupid Rack::CommonLogger error, when testing.
              unless app.class == MyTestApp
                pending "app.class returns [#{app.class}]"
              else
                app.class.should == MyTestApp
              end
            end
            
            # it_should_behave_like "debug => app.methods"
            
          end #/ Sanity
          
        end
        
        share_examples_for 'MyAdminTestApp' do 
          
          before(:each) do 
            class ::Test::Unit::TestCase 
              def app; ::MyAdminTestApp.new ; end
            end
            @app = app
          end
          
          after(:each) do 
            class ::Test::Unit::TestCase 
              def app; nil ; end
            end
            @app = nil
          end
          
          describe "Sanity" do 
            
            it "should be a MyAdminTestApp kind of app" do 
              #  FIXME:: HACK to prevent errors due to stupid Rack::CommonLogger error, when testing.
              unless app.class == MyAdminTestApp
                pending "app.class returns [#{app.class}]"
              else
                app.class.should == MyAdminTestApp
              end
            end
            
            # it_should_behave_like "debug => app.methods"
            
          end #/ Sanity
          
        end
        
        # :startdoc:
        
        # it_should_behave_like "debug => app.methods"
        # 
        share_examples_for "debug => app.methods" do 
          it "app should have the right methods" do 
            app.methods.sort.should == 'debug => app.methods.sort'
          end
        end
        
        share_examples_for "debug" do 
          
          it "should output the whole html" do
            body.should have_tag('debug')
          end
          
        end #/debug
        
        share_examples_for "HTTP headers" do 
          
          it "should return status: 200" do 
            assert response.ok?
          end
          
          it "should return 'text/html'" do 
            response.headers['Content-Type'].should == 'text/html'
            # assert_equal('text/html', last_response.headers['Content-Type'])
          end
          
        end #/headers
        
        share_examples_for "HTML" do 
          
          it "should return status: 200" do 
            assert response.ok?
          end
          
          it "should return 'text/html'" do 
            response.headers['Content-Type'].should == 'text/html'
          end
          
        end #/HTML
        
        share_examples_for "CSS" do 
          
          it "should return status: 200" do 
            assert response.ok?
          end
          
          it "should return 'text/css'" do 
            response.headers['Content-Type'].should == 'text/css'
          end
          
        end #/HTML
        
        
        ###### HTML OUTPUT #######
        
        share_examples_for 'div#main-content' do 
          it "should have a div#main-content tag" do 
            body.should have_tag('div#main-content')
          end
        end #/div
        
        share_examples_for 'div#main-content > h2' do 
          it "should have a div#main-content h2 tag" do 
            body.should have_tag('div#main-content > h2', :count => 1)
          end
        end #/share_examples_for
        
        
        ###### ADMIN SECTIONS #######
        
        share_examples_for 'div.admin-section-header > div.actions > h4 with HELP' do 
          it "should have div.admin-section-header > div.actions > h4 with HELP" do 
            body.should have_tag('div.admin-section-header > div.actions > h4') do |h4|
              h4.inner_text.should match(/\s*HELP$/)
            end
          end
        end
        
        
        ###### FORMS ########
        
        # share_examples_for 'forms > faux method > input.hidden[@value=put|delete]' do
        share_examples_for 'forms > faux method > input.hidden' do
          it "should have a faux method input hidden with method = PUT or DELETE" do
            body.should match(/<input (name="_method"\s*|type="hidden"\s*|value="(put|delete)"\s*){3}>/)
          end
        end
        
        
        ###### CSS ########
        
        share_examples_for 'get_all_css_requests("/css")' do 
          
          it_should_behave_like "CSS [screen, print]"
          
          it_should_behave_like "CSS [ie]"
          
        end
        
        share_examples_for 'get_all_css_requests("/css") (NO IE)' do 
          
          it_should_behave_like "CSS [screen, print]"
          
        end
        
        share_examples_for 'CSS [screen, print]' do 
          
          describe "CSS - GET /css/screen.css" do 
            
            before(:each) do 
              get("/css/screen.css")
            end
            
            it "should return status: 200" do 
              assert response.ok?
            end
            
            it "should return 'text/css'" do 
              # response.headers['Content-Type'].should == 'text/css;charset=utf-8'
              response.headers['Content-Type'].should == 'text/css'
            end
            
            describe "the CSS" do 
              
              # it_should_behave_like "debug"
              
              it "should NOT have a Sass::SyntaxError" do 
                body.should_not match(/Sass::SyntaxError/)
              end
              
              #  TODO:: Need to write further tests here
              # it "should have further tests"
              
            end #/ the CSS
            
          end #/CSS - GET /css/screen.css
          
          describe "CSS - GET /css/print.css" do 
            
            before(:each) do 
              get("/css/print.css")
            end
            
            it "should return status: 200" do 
              assert response.ok?
            end
            
            it "should return 'text/css'" do  
              # response.headers['Content-Type'].should == 'text/css;charset=utf-8'
              response.headers['Content-Type'].should == 'text/css'
            end
            
            describe "the CSS" do 
              
              # it_should_behave_like "debug"
              
              it "should NOT have a Sass::SyntaxError" do 
                body.should_not match(/Sass::SyntaxError/)
              end
              
              #  TODO:: Need to write further tests here
              # it "should have further tests"
              
            end #/ the CSS
            
          end #/CSS - GET /css/print.css
          
        end
        
        share_examples_for 'CSS [ie]' do 
          
          describe "CSS - GET /css/ie.css" do 
            
            before(:each) do 
              get("/css/ie.css")
            end
            
            it "should return status: 200" do 
              assert response.ok?
            end
            
            it "should return 'text/css'" do 
              # response.headers['Content-Type'].should == 'text/css;charset=utf-8' # tilt version
              response.headers['Content-Type'].should == 'text/css'
            end
            
            describe "the CSS" do 
              
              # it_should_behave_like "debug"
              
              it "should NOT have a Sass::SyntaxError" do 
                body.should_not match(/Sass::SyntaxError/)
              end
              
              #  TODO:: Need to write further tests here
              # it "should have further tests"
              
            end #/ the CSS
            
          end #/CSS - GET /css/print.css
          
        end
        
        
      end #/module SharedSpecs
    end #/module RSpec
  end #/module Tests
end #/module Sinatra
