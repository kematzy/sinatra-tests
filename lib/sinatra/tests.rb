
require 'sinatra/base'
require 'test/unit'
require 'rack/test'
require 'spec'
require 'spec/interop/test'
require 'rspec_hpricot_matchers'


module Sinatra 
  module Tests 
    VERSION = '0.1.3' unless const_defined?(:VERSION)
    def self.version; "Sinatra::Tests v#{VERSION}"; end
    
    
    def self.registered(app)
      
      app.get '/tests' do
        case params[:engine]
        when 'erb'
          erb(params[:view], :layout => params[:layout] )
        when 'haml'
          haml(params[:view], :layout => params[:layout] )
        else
          params.inspect
        end
      end
      
    end #/ self.registered
    
  end #/module Test
end #/module Sinatra

%w(test_case shared_specs).each do |f|
  require "sinatra/tests/#{f}"
end