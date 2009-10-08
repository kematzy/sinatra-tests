
module Sinatra 
  module Tests
    
    ##
    # Sinatra::Tests::TestCase
    # 
    # Module to be include into Test::Unit::TestCase declaration in spec_helper.rb
    # 
    #   class Test::Unit::TestCase
    #     include Sinatra::Tests::TestCase
    #     
    #     <snip...>
    #   end
    # 
    # 
    # 
    module TestCase 
      
      include Rack::Test::Methods
      
      # so we can escape_html in our debug output
      include Rack::Utils
      alias_method :h, :escape_html
      
      ##
      # Short for <tt>last_response</tt>. 
      # Making it easier to work with the returned response
      # 
      # @api public
      alias_method :response, :last_response
      
      ##
      # Declaration of Sinatra setup
      #  
      # @api public
      def setup
        Sinatra::Base.set :environment, :test
      end
      
      
      # Sets up a Sinatra::Base subclass defined with the block
      # given. Used in setup or individual spec methods to establish
      # the application.
      def mock_app(base=Sinatra::Base, &block)
        @app = Sinatra.new(base, &block)
      end
      
      ##
      # Short for <tt>last_response.body</tt>. 
      # Making it easier to work with the returned body of a response
      # 
      # @api public
      def body
        response.body.to_s
      end
      # alias_method :markup, :body
      
      ##
      # Short for <tt>last_response.status</tt>. 
      # Making it easier to work with the returned status of a response
      # 
      # @api public
      def status
        response.status
      end
      
      ##
      # Delegate other missing methods to response.
      # 
      def method_missing(name, *args, &block)
        if response && response.respond_to?(name)
          response.send(name, *args, &block)
        else
          super
        end
      end
      
      ##
      # Also check response since we delegate there.
      # 
      def respond_to?(symbol, include_private=false)
        super || (response && response.respond_to?(symbol, include_private))
      end
      
      
      ##
      # Flexible method to test the ERB output.
      # 
      # Accepts custom :layout & :url options passed.
      # 
      # ==== Examples
      # 
      #   erb_app "<%= some_method('value') %>"
      #   body.should == 'some result'
      #   body.should have_tag(:some_tag)
      # 
      #   # NB!  the custom URL must be declared in the MyTestApp in order to work
      # 
      #   erb_app "<%= 'custom-erb-url'.upcase %>", :url => "/custom-erb-url"
      #   last_request.path_info.should == "/custom-erb-url"
      # 
      # @api public
      def erb_app(view, options = {})
        options = {:layout => '<%= yield %>', :url  => '/tests' }.merge(options)
        get options[:url], :view => view, :layout => options[:layout], :engine => :erb 
      end
      
      ##
      # Flexible method to test the HAML output
      # 
      # ==== Examples
      # 
      #   haml_app "= some_method('value')"
      #   body.should == 'some result'
      #   body.should have_tag(:some_tag)
      # 
      #   # NB!  the custom URL must be declared in the MyTestApp in order to work
      # 
      #   haml_app "= 'custom-haml-url'.upcase", :url => "/custom-haml-url"
      #   last_request.path_info.should == "/custom-haml-url"
      # 
      # @api public
      def haml_app(view, options = {}) 
        options = {:layout => '= yield ', :url  => '/tests' }.merge(options)
         get options[:url], :view => view, :layout => options[:layout], :engine => :haml 
      end
      
      
      private
        
        # RACK_OPTIONS = {
        #   :accept       => 'HTTP_ACCEPT',
        #   :agent        => 'HTTP_USER_AGENT',
        #   :host         => 'HTTP_HOST',
        #   :session      => 'rack.session',
        #   :cookies      => 'HTTP_COOKIE',
        #   :content_type => 'CONTENT_TYPE'
        # }
        # 
        # def rack_options(opts)
        #   opts.merge(:lint => true).inject({}) do |hash,(key,val)|
        #     key = RACK_OPTIONS[key] || key
        #     hash[key] = val
        #     hash
        #   end
        # end
        
      
    end #/module Testcase
    
  end #/module Tests
end #/module Sinatra
