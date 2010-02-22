
require "#{File.dirname(File.dirname(File.expand_path(__FILE__)))}/../../spec_helper"


describe "Sinatra" do 
  
  it_should_behave_like "MyTestApp"
  
  describe "Tests" do 
    
    describe "RSpec" do 
      
      describe "Matchers" do 
        
        describe "#be_even" do 
          
          it "should return true when even" do 
            1.should_not be_even
            2.should be_even
          end
          
          it "should raise an Exception when not even" do
            lambda { 1.should be_even }.should raise_error(Exception, /"an even number" but got 1/)
          end
          
        end #/ #be_even
        
        describe "#have_a_page_title" do 
          
          it "should return true when there is a page title" do 
            erb_app "<head><title>It works</title></head>"
            body.should have_a_page_title('It works')
            erb_app "<head><title>Home | Default Site Title</title></head>"
            body.should have_a_page_title('Home | Default Site Title')
          end
          
          it "should raise an Exception when the searched for page title contains entities" do 
            lambda { 
              erb_app "<head><title>Home &amp; Default Site Title</title></head>"
              body.should have_a_page_title('Home &amp; Default Site Title')
            }.should raise_error(Exception)
          end
          
          it "should NOT raise an Exception when the searched for page title contains decoded entities" do 
            lambda { 
              erb_app "<head><title>Home &amp; Default Site Title</title></head>"
              body.should have_a_page_title('Home & Default Site Title')
            }.should_not raise_error(Exception)
            
          end
          
          it "should raise an Exception when the page titles are NOT the same" do 
            erb_app "<head><title>It still works</title></head>"
            lambda { 
              body.should have_a_page_title('It works')
            }.should raise_error(Exception)
          end
          
          it "should return true when the page title is empty" do 
            erb_app "<head><title></title></head>"
            body.should have_a_page_title('')
          end
          
          it "should return true when given a RegExp that matches " do 
            erb_app "<head><title>It works</title></head>"
            body.should have_a_page_title(/^It /)
          end
          
          it "should raise an Exception when given a RegExp that does NOT match" do 
            erb_app "<head><title>It works</title></head>"
            lambda {
              body.should have_a_page_title(/^It does not match/) 
            }.should raise_error(Exception, /<head><title>It works<\/title><\/head>\nto have an element matching "head > title" with inner text \/\^It does not match\/, but found 0/m)
          end
          
          it "should raise an Exception when there is no <head> elment" do 
            erb_app "<title>It works</title>"
            lambda {
              body.should have_a_page_title(/^It works/) 
            }.should raise_error(Exception, /<title>It works<\/title>\nto have an element matching "head > title" with inner text \/\^It works\/, but did not/m)
          end
          
        end #/ #have_a_page_title
        
        describe "#have_a_page_header" do 
          
          it "should return true when there is a page header" do 
            erb_app "<%= '<h2>Page Header</h2>' %>"
            body.should have_a_page_header('Page Header')
            erb_app "<%= '<h2 class=\"page-header\">Page Header</h2>' %>"
            body.should have_a_page_header('Page Header')
          end
          
          it "should raise an error when the page headers are NOT the same" do 
            erb_app "<%= '<h2>Page Header</h2>' %>"
            lambda {
                body.should have_a_page_header('Different Page Header')
            }.should raise_error(Exception)
          end
          
          it "should return true when the page header is empty" do 
            erb_app "<h2></h2>"
            body.should have_a_page_header('')
          end
          
          it "should return true when given a RegExp that matches " do 
            erb_app "<h2>Page Header</h2>"
            body.should have_a_page_header(/^Page /)
          end
          
          it "should raise an Exception when given a RegExp that does NOT match" do 
            erb_app "<h2>Page Header</h2>"
            lambda {
              body.should have_a_page_header(/^Different Page Header/) 
            }.should raise_error(Exception, /<h2>Page Header<\/h2>\nto have 1 elements matching "h2" with inner text \/\^Different Page Header\/, but found 0/m)
          end
          
          it "should accept dynamic page headers" do 
            erb_app "<%= '<h1>Page Header</h1>' %>"
            body.should have_a_page_header('Page Header','h1')
            erb_app "<%= '<div id=\"main-content\"><h2>Page Header</h2></div>' %>"
            body.should have_a_page_header('Page Header','div#main-content > h2')
            erb_app "<%= '<span class=\"page-header\">Page Header</span>' %>"
            body.should have_a_page_header('Page Header','span.page-header')
          end
          
          it "should raise an Exception when there are more than one page header" do 
            erb_app "<h2>Page Header1</h2><h2>Page Header2</h2><h2>Page Header3</h2>"
            lambda {
              body.should have_a_page_header(/^Page Header/) 
            }.should raise_error(Exception, /<h2>Page Header1<\/h2><h2>Page Header2<\/h2><h2>Page Header3<\/h2>\nto have 1 elements matching "h2" with inner text \/\^Page Header\/, but found 3/m)
            
          end
          
        end #/ #have_a_page_header
        
        describe "#have_a_td_actions" do 
          
          before(:each) do 
@html = %Q[
<table id="posts-table">
  <tbody>
    <tr>
      <td id="post-actions-98" class="actions">
        <a href="/posts/98/edit" class="ui-btn edit-link" title="edit post">EDIT</a> | 
        <a href="/posts/98" class="ui-btn delete-link" title="delete post">DELETE</a>
      </td>
    </tr>
    <tr>
      <td id="post-actions-99" class="actions">
        <a href="/posts/99/edit" class="ui-btn edit-link" title="edit post">EDIT</a> | 
        <a href="/posts/99" class="ui-btn delete-link" title="delete post">DELETE</a>
      </td>
    </tr>
  </tbody>
</table>]
            
          end
          
          it "should return true when looking for a simple model only" do 
            erb_app @html
            # body.should have_tag(:debug)
            body.should have_a_td_actions(:post)
          end
          
          it "should return true when providing a buttons array" do 
            erb_app @html
            # body.should have_tag(:debug)
            body.should have_a_td_actions(:post, %w(edit))
          end
          
          it "should raise an Exception when asking for buttons that are NOT present" do 
            lambda { 
              erb_app @html
              # body.should have_tag(:debug)
              body.should have_a_td_actions(:post,%w(delete edit show))
            }.should raise_error(Exception)
          end
          
          it "should have more tests here...."
          
        end #/ #have_a_td_actions
        
        describe "#have_a_ui_btn" do 
          
          it "should return true for an Edit button with (div, :edit,:post, 'EDIT')" do 
            erb_app '<%= "<div><a href=\"/posts/99/edit\" class=\"ui-btn edit-link\" title=\"edit post\">EDIT</a></div>" %>'
            body.should have_a_ui_btn('div', :edit, :post, 'EDIT')
          end
          
          it "should return true for an Edit button without link text (div, :edit,:post)" do 
            erb_app '<%= "<div><a href=\"/posts/99/edit\" class=\"ui-btn edit-link some-other-class\" title=\"edit post with extra text\">EDIT</a></div>" %>'
            body.should have_a_ui_btn('div', :edit, :post)
          end
          
          it "should return true for a Delete button with (div, :delete,:post, 'DELETE')" do 
            erb_app '<%= "<div><a href=\"/posts/99\" class=\"ui-btn delete-link\" title=\"delete post\">DELETE</a></div>" %>'
            body.should have_a_ui_btn('div', :delete, :post, 'DELETE')
          end
          
          it "should return true for a Delete button without link text (div, :delete,:post)" do 
            erb_app '<%= "<div><a href=\"/photos/99\" class=\"ui-btn delete-link some-other-class\" title=\"delete photo with extra text\">DELETE</a></div>" %>'
            body.should have_a_ui_btn('div', :delete, :photo)
            erb_app '<%= "<div><a href=\"/photos/99\" class=\"ui-btn delete-link some-other-class\" title=\"delete photo with extra text\"></a></div>" %>'
            body.should have_a_ui_btn('div', :delete, :photo,'')
          end
          
          it "should return true for a Show button with custom link text" do 
            erb_app '<%= "<div><a href=\"/posts/99\" class=\"ui-btn show-link\" title=\"show post\">Custom</a></div>" %>'
            body.should have_a_ui_btn('div', :show, :post, 'Custom')
          end
          
          it "should raise an Exception when given wrong arguments" do 
            lambda { 
              erb_app '<%= "<div><a href=\"/photos/99\" class=\"ui-btn delete-link\" title=\"delete photo\">DELETE</a></div>" %>'
              body.should have_a_ui_btn('div', nil, :photo)
            }.should raise_error(Exception)
          end
          
        end #/ #have_a_ui_btn
        
        describe "#have_an_edit_btn" do 
          
          it "should return true when there is an edit_btn with 'EDIT'" do 
            erb_app '<%= "<div><a href=\"/posts/99/edit\" class=\"ui-btn edit-link\" title=\"edit post\">EDIT</a></div>" %>'
            body.should have_an_edit_btn('div', :post)
            erb_app '<%= "<div><a href=\"/posts/99/edit\" class=\"ui-btn edit-link some-other-class\" title=\"edit post with extra text\">EDIT</a></div>" %>'
            body.should have_an_edit_btn('div', :post)
          end
          
          it "should return true when there is an edit_btn with custom text" do 
            erb_app '<%= "<div><a href=\"/posts/99/edit\" class=\"ui-btn edit-link\" title=\"edit post\">Custom</a></div>" %>'
            body.should have_an_edit_btn('div', :post, 'Custom')
          end
          
        end #/ #have_an_edit_btn
        
        describe "#have_a_delete_btn" do 
          
          it "should return true when there is an delete_btn with 'DELETE'" do 
            erb_app '<%= "<div><a href=\"/posts/99\" class=\"ui-btn delete-link\" title=\"delete post\">DELETE</a></div>" %>'
            body.should have_a_delete_btn('div', :post)
            erb_app '<%= "<div><a href=\"/posts/99\" class=\"ui-btn delete-link some-other-class\" title=\"delete post with extra text\">DELETE</a></div>" %>'
            body.should have_a_delete_btn('div', :post)
          end
          
          it "should return true when there is an delete_btn with custom text" do 
            erb_app '<%= "<div><a href=\"/posts/99\" class=\"ui-btn delete-link\" title=\"delete post\">Custom</a></div>" %>'
            body.should have_a_delete_btn('div', :post, 'Custom')
          end
          
        end #/ #have_an_edit_btn
        
        describe "#have_a_show_btn" do 
          
          it "should return true when there is an show_btn with 'Show'" do 
            erb_app '<%= "<div><a href=\"/posts/99\" class=\"ui-btn show-link\" title=\"show post\">SHOW</a></div>" %>'
            body.should have_a_show_btn('div', :post)
            erb_app '<%= "<div><a href=\"/posts/99\" class=\"ui-btn show-link some-other-class\" title=\"show post with extra text\">SHOW</a></div>" %>'
            body.should have_a_show_btn('div', :post)
          end
          
          it "should return true when there is an show_btn with custom text" do 
            erb_app '<%= "<div><a href=\"/posts/99\" class=\"ui-btn show-link\" title=\"show post\">Custom</a></div>" %>'
            body.should have_a_show_btn('div', :post, 'Custom')
          end
          
        end #/ #have_an_edit_btn
        
      end #/ Matchers
      
    end #/ RSpec
  end #/ Tests
end #/ Sinatra