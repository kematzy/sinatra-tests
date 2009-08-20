
require 'sinatra/base'
require 'test/unit'

module Sinatra
  
  module Test
    
    module Helpers
      
      get '/tests' do
        case params[:engine]
        when 'erb'
          erb(params[:view], :layout => params[:layout] )
        when 'haml'
          haml(params[:view], :layout => params[:layout] )
        else
          params.inspect
        end
      end
      
    end #/module Helpers
    
    
    module Unit::TestCase
      
      def setup
        Sinatra::Base.set :environment, :test
      end
      
      def erb_app(view, options = {})
        options = {:layout => '<%= yield %>', :url  => '/tests' }.merge(options)
        get options[:url], :view => view, :layout => options[:layout], :engine => :erb 
      end
      
      def haml_app(view, options = {}) 
        options = {:layout => '= yield ', :url  => '/tests' }.merge(options)
         get options[:url], :view => view, :layout => options[:layout], :engine => :haml 
      end
      
    end #/module Unit::TestCase
    
  end #/module Test
  
end #/module Sinatra
