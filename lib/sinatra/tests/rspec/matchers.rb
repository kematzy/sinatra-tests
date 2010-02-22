

module Sinatra 
  module Tests
    
    module RSpec
      
      module Matchers 
        
        ##
        # A simple matcher that tests for an even number
        #  
        # ==== Examples
        #   
        #   1.should_not be_even
        #   2.should be_even
        #   
        # @api public
        def be_even 
          simple_matcher("an even number") { |given| given % 2 == 0 }
        end
        
        ##
        # A simple matcher that tests for a <head> with a <title> tag
        # with the given text.
        #  
        # ==== Examples
        # 
        #   body.should have_a_page_title("Home | Default Site Title")
        # 
        #   body.should have_a_page_title(/Home/)
        # 
        # @api public
        def have_a_page_title(expected) 
          simple_matcher("have a page title in the <head> element with [#{expected}]") do |given, matcher|
            given.should have_tag('head > title', expected)
          end
        end
        
        ##
        # A simple matcher that tests for <h(1..6)> header tag with the given text.
        #  
        # NB! Throws an Exception when there's more than one page header on the page.
        # 
        # ==== Examples
        # 
        #   body.should have_a_page_header('Page Header')
        # 
        #   body.should have_a_page_header(/Contact Information/, 'h1')
        # 
        # @api public
        def have_a_page_header(expected, tag = 'h2') 
          simple_matcher("have an '#{tag}' page header with [#{expected.inspect}]") do |given, matcher|
            given.should have_tag(tag, expected, :count => 1)
          end
        end
        
        ##
        # TODO: add some comments here
        #  
        # ==== Examples
        # 
        # 
        # @api private
        def have_a_td_actions(model, buttons = %w(delete edit)) 
          simple_matcher do |given, matcher|
            tag = "table##{model.to_s.plural}-table > tbody > tr > td.actions"
            given.should have_tag(tag) do |td|
              td.attributes['id'].should match(/#{model.to_s.singular}-actions-\d+/)
            end
            buttons.each do |btn|
              given.should have_a_ui_btn(tag, btn.to_sym, model)
            end
          end
        end
        
        ##
        # A simple matcher that tests for a <tt><a href></tt> tag with class 'ui-btn'
        # and a number of other specific values.
        # 
        # 
        # ==== Examples
        # 
        #   body.should have_a_ui_btn('div', :edit, :article, 'Edit') =>
        #   
        #     => returns true when there is a <a href="/articles/:id/edit" class="ui-btn edit-link" title="edit article">Edit</a>
        #     
        #   
        #   body.should have_a_ui_btn('div', :delete, :article) =>
        #   
        #     => returns true when there is a <a href="/articles/:id" class="ui-btn delete-link" title="delete article">DELETE</a>
        #     
        # 
        # @api private
        def have_a_ui_btn(tag, type, model, text=nil) 
          text = type.to_s.upcase if text.nil?
          simple_matcher("have a #{tag} with a ui-btn as a #{type}-btn for a [#{model}] with text #{text}") do |given, matcher|
            given.should have_tag(tag + ' > a.ui-btn',text) do |a|
              a.attributes['class'].should match(/#{type}-link/)
              a.attributes['title'].should match(/#{type} #{model.to_s.singular}/)
              if type == 'edit'
                a.attributes['href'].should match(/\/#{model.to_s.plural}\/\d+\/edit/)
              else
                a.attributes['href'].should match(/\/#{model.to_s.plural}\/\d+/)
              end
            end
          end
        end
        
        ##
        # A simple matcher that tests for a <tt><a href></tt> tag with class 'ui-btn edit-link'
        #  
        # ==== Examples
        # 
        #   body.should have_an_edit_btn('td.actions', :post)
        #   
        #   body.should have_an_edit_btn('td.actions', :post, 'Custom Btn Text')
        # 
        # @api private
        def have_an_edit_btn(tag, model, text="EDIT") 
          have_a_ui_btn(tag, :edit, model, text)
        end
        
        ##
        # A simple matcher that tests for a <tt><a href></tt> tag with class 'ui-btn delete-link'
        #  
        # ==== Examples
        # 
        #   body.should have_a_delete_btn('td.actions', :post)
        #   
        #   body.should have_a_delete_btn('td.actions', :post, 'Custom Btn Text')
        #   
        # @api private
        def have_a_delete_btn(tag, model, text="DELETE") 
          have_a_ui_btn(tag, :delete, model, text)
        end
        
        ##
        # A simple matcher that tests for a <tt><a href></tt> tag with class 'ui-btn show-link'
        #  
        # ==== Examples
        # 
        #   body.should have_a_show_btn('td.actions', :post)
        #   
        #   body.should have_a_show_btn('td.actions', :post, 'Custom Btn Text')
        #   
        # @api private
        def have_a_show_btn(tag, model, text="SHOW") 
          have_a_ui_btn(tag, :show, model, text)
        end
        
        # :stopdoc:
        
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
        
        ##
        # TODO: add some comments here
        #  
        # ==== Examples
        # 
        # 
        # @api private
        def have_an_ui_form_header(model, options = {} ) 
          
        end
        
        ##
        # TODO: add some comments here
        #  
        # ==== Examples
        # 
        # 
        # @api private
        def have_a_ui_form_message(state, msg = nil) 
          simple_matcher do |given, matcher|
            if msg.nil?
              given.should have_tag("form > div.ui-form-message.#{state} > p") #ignoring message
            else  
              given.should have_tag("form > div.ui-form-message.#{state} > p", msg)
            end
          end
        end
        
        ##
        # TODO: add some comments here
        #  
        # ==== Examples
        # 
        # 
        # @api private
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
        
        # :doc:
        
        
      end #/module Matchers
      
    end #/module RSpec
    
  end #/module Tests
end #/module Sinatra
