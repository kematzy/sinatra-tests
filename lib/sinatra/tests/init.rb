
# ### Make sure my own gem path is included first
# if (ENV['HOME'] =~ /^\/home\//)  ## DREAMHOST
#   ENV['GEM_HOME'] = "#{ENV['HOME']}/.gems"
#   ENV['GEM_PATH'] = "#{ENV['HOME']}/.gems:/usr/lib/ruby/gems/1.8"
#   require 'rubygems'
#   Gem.clear_paths
# else  
#   require 'rubygems'
# end
# 
# #--
# # DEPENDENCIES
# #++
# 
# require 'haml'
# require 'sass'
# require 'sinatra/base'
# require 'alt/rext'
# require 'ostruct'
# require 'yaml'
# 
# #--
# ## SINATRA EXTENSIONS
# #++
# 
# require 'sinatra/basics'
# require 'sinatra/ie6nomore'
# # require 'sinatra/upload'
# # require 'sinatra/snippets'
# #require 'sinatra/cache'
# 
# #--
# # DATABASE DEPENDENCIES
# #++
# require 'dm-core'
# require 'dm-migrations'
# require 'dm-timestamps'
# require 'dm-validations'
# require 'dm-serializer'
# require 'dm-types'
# 
# #--
# # DATABASE CONFIGURATION
# #++
# 
# DataMapper::Logger.new("#{APP_ROOT}/db/dm.app.log", :debug)
# DataMapper.setup :default, "sqlite3://#{APP_ROOT}/db/db.tests.db"
# DataMapper.auto_upgrade!
# 
#--
# SINATRA::TESTS::INIT
# 
# Main Extension that loads a number of commonly used parts / functionality
#++

module Sinatra::Tests
  module Init 
    
    module Helpers 
      
      ##
      # Convenience method for the class Settings block
      def konf
        self.class.settings
      end
      
    end #/module Helpers
    
    def self.registered(app) 
      app.helpers Sinatra::Init::Helpers
      
      ## OPTIONS / SINATRA / CORE
      app.set :static, true
      app.set :logging, true
      app.set :sessions, true
      app.set :methodoverride, true
      app.set :run, false
      
      app.set :raise_errors, true #Proc.new { test? }
      app.set :show_exceptions, true #Proc.new { development? }
      
      ##  OPTIONS / SINATRA / EXTENSIONS
      # app.set :admin_path_prefix, '/admin'
      
      ##  OPTIONS / SINATRA / APP
      
      app.set :apps_dir, "#{APP_ROOT}/apps"
      
    end
    
    ##
    # Configuration loading abstraction. Loads the configurations in the given path, 
    # or
    #
    # ==== Examples
    # 
    #   set :settings, load_settings('/path/2/configurations/file.yml')
    # 
    # Merge local settings with the global configurations, via adding :merge_with_global
    # 
    #   set :settings, load_settings('/path/2/configurations/file.yml', :merge_with_global)
    # 
    # 
    # @api public
    def load_settings!(path, load_global = nil) 
      global_settings = load_global.nil?  ? {} : YAML.load_file("#{APP_ROOT}/config/settings.yml")
      loaded_settings = test(?f, path) ? YAML.load_file(path) : {}  # Hash coming in
      merged_settings = global_settings.merge(loaded_settings)
      puts "- Settings loaded and merged for [#{path.sub(APP_ROOT,'')}]"
      @settings = ::OpenStruct.new(merged_settings)
    end
    
    ##
    # Convenience method for loading declared routes.
    # 
    # Takes the full path to the apps/app directory
    # 
    # ==== Examples
    # 
    #   load_routes!(app_dir)
    # 
    # 
    #   load_routes!('/full/path/2/apps/app/dir')
    # 
    # @api public
    def load_routes!(app_dir_path) 
      # puts "load_routes!(app_dir_path=[#{app_dir_path}]) [#{__FILE__}:#{__LINE__}]"
      Dir["#{app_dir_path}/routes/*.rb"].each do |route|
        load route
      end
    end
    
    ##
    # Convenience method for loading helpers.
    # 
    # Takes the full path to the apps/app directory
    # 
    # ==== Examples
    # 
    #   load_helpers!(app_dir)
    # 
    # 
    #   load_helpers!('/full/path/2/apps/app/dir')
    # 
    # @api public
    def load_helpers!(app_dir_path) 
      # puts "load_helpers!(app_dir_path=[#{app_dir_path}]) [#{__FILE__}:#{__LINE__}]"
      Dir["#{app_dir_path}/helpers/*.rb"].each do |helper|
        load helper
      end
    end
    
    ##
    # Convenience method for loading models.
    # 
    # Takes the full path to the apps/app directory
    # 
    # ==== Examples
    # 
    #   load_models!(app_dir)
    # 
    # 
    #   load_models!('/full/path/2/apps/app/dir')
    # 
    # @api public
    def load_models!(app_dir) 
      Dir["#{app_dir}/models/*.rb"].each do |model|
        load model
      end
    end
    
  end #/module Init
end #/module Sinatra::Tests
