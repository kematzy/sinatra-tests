

module Sinatra 
  module Tests
    
    module RSpecMatchers
      
      ## 
      # 
      def be_even
        simple_matcher("an even number") { |given| given % 2 == 0 }
      end
      
      ##
      # TODO: add some comments here
      #  
      # ==== Examples
      # 
      # 
      # @api public/private
      def have_a_page_title(expected) 
        simple_matcher do |given, matcher|
          given.should have_tag('title', expected)
        end
      end
      
      def have_a_page_header(expected) 
        simple_matcher("have an h2 page header with [#{expected.inspect}]") do |given, matcher|
          # matcher.description = "have an h2 page header with [#{expected.inspect}]"
          given.should have_tag('h2', expected, :count => 1)
        end
      end
      
      
      def have_a_td_actions(model, buttons = %w(delete edit)) 
        simple_matcher do |given, matcher|
          tag = "div##{model.to_s.plural}-div > table##{model.to_s.plural}-table > tbody > tr > td.actions"
          given.should have_tag(tag) do |td|
            td.attributes['id'].should match(/#{model.to_s.singular}-actions-\d+/)
          end
          buttons.each do |btn|
            given.should have_a_delete_btn(tag, model) if btn.to_s == 'delete'
            given.should have_an_edit_btn(tag, model) if btn.to_s == 'edit'
            #  TODO:: fix Show button 
            # td.should have_a_show_btn(model) if btn.to_s == 'show'
          end
        end
      end
      
      def have_an_edit_btn(tag, model) 
        simple_matcher do |given, matcher|
          given.should have_tag(tag + ' > a.edit-link.ui-btn','EDIT') do |a|
            a.attributes['href'].should match(/\/#{model.to_s.plural}\/\d+\/edit/)
          end
          given.should have_tag(tag + " > a.edit-link[@title=edit #{model.to_s.singular}]",'EDIT')
        end
      end
      
      def have_a_delete_btn(tag, model) 
        simple_matcher do |given, matcher|
          given.should have_tag(tag + ' > a.delete-link.ui-btn','DELETE') do |a|
            a.attributes['href'].should match(/\/#{model.to_s.plural}\/\d+/)
          end
          given.should have_tag(tag + " > a.delete-link[@title=delete #{model.to_s.singular}]",'DELETE')
        end
      end
      
      # def have_id_attribute(tag, id)
      #   simple_matcher do |given, matcher|
      #     given.should have_tag(tag).attributes['id'].should match(id)
      #   end
      # end
      
      # def have_link_title(title)
      #   simple_matcher do |given, matcher|
      #     given.attributes['title'].should == title 
      #   end
      # end
      
      def have_an_ui_form_header(model, options = {} )
        
      end
      
      def have_a_ui_form_message(state, msg = nil) 
        simple_matcher do |given, matcher|
          if msg.nil?
            given.should have_tag("form > div.ui-form-message.#{state} > p") #ignoring message
          else  
            given.should have_tag("form > div.ui-form-message.#{state} > p", msg)
          end
        end
      end
      
      
      def have_an_admin_header(options ={}) 
        simple_matcher do |given, matcher|
          matcher.description = "be an admin_header with [#{options.inspect}]"
          matcher.failure_message = "expected #{given} to have an admin-section-header with these values #{options.inspect}"
          
          given.should have_tag('div.admin-section-header')
          if options[:model]
            given.should have_tag('div.admin-section-header > div.section > h2', /#{options[:model].to_s}/i ) 
            if options[:add_new]
              given.should have_tag("div.admin-section-header > div.actions > h4 > a[@href=/#{options[:model].to_s.downcase}/new]", /ADD NEW #{options[:model].to_s.singular}:?/i )
            end
          end
        end
      end
      
      # def rhyme_with(expected)
      #   simple_matcher do |given, matcher|
      #     matcher.description = "rhyme with #{expected.inspect}"
      #     matcher.failure_message = "expected #{given.inspect} to rhyme with #{expected.inspect}"
      #     matcher.negative_failure_message = "expected #{given.inspect} not to rhyme with #{expected.inspect}"
      #     given.rhymes_with? expected
      #   end
      # end
      
      
      
    end #/module RSpecMatchers
    
    module SharedSpecs 
      
      include Sinatra::Tests::RSpecMatchers
      
      
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
            app.class.should == MyTestApp
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
      end
      
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
      
      share_examples_for 'faux method > input.hidden[@value=put|delete]' do
        it "should have a faux method input hidden with method = PUT or DELETE" do
          body.should match(/<input (name="_method"\s*|type="hidden"\s*|value="(put|delete)"\s*){3}>/)
        end
      end
      
      
    end #/module SharedSpecs
    
  end #/module Tests
end #/module Sinatra
