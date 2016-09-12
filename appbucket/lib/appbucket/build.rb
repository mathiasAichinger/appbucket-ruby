require "rest-client"
require "colorize"

module Appbucket
  
  class Build

    # Class methods

    def self.api_url
      "#{Appbucket.base_url}/builds"
    end
  	def self.get(id = nil)
      
      url = Appbucket::Build.api_url
      url = "#{url}/#{id}}" if id != nil

      response = RestClient.get Appbucket::Build.api_url
      response_body_json = JSON.parse(response.body)
      return unless response_body_json["data"]

      build_list = []
      response_body_json["data"].each do |dataObject| 
        # TODO: return a list of Build objects with `active_model_serializers`
        build_list << Appbucket::Build.create_from_json_api(dataObject)
      end 

      return build_list
  	end
  	
    # post a Build object to 'app-bucket'
    # returns the uploaded Build object
  	def self.post(build)

      begin
        file = File.new(build.file_path, 'rb')  
      rescue Exception => e
        puts "[#{self.name}] ERROR: Could not upload build! e.message".red
        return nil
      end     
      
      url = Appbucket::Build.api_url
      parameter = {:version => build.version,
                   :binary_file => file,
                   :notes => build.notes,
                   :identifier => build.identifier,
                   :multipart => true}
      begin
        response = RestClient::post url, parameter  
      rescue Exception => e
        puts "[#{self.name}] ERROR: Could not upload build! #{e.message}".red
        return nil
      end
      
      # TODO: return a Build object with `active_model_serializers`
      return Appbucket::Build.create_from_json_api(JSON.parse(response.to_s)["data"])
  	end

  	# Instance methods

    attr_reader :version, 
                :short_version, 
                :type, 
                :notes, 
                :download_url,
                :manifest_url,
                :processed,
                :file_path,
                :identifier

    def self.create_from_json_api(jsonApi)
      return Appbucket::Build.new(version: jsonApi["attributes"]["version"],
        short_version: jsonApi["attributes"]["short_version"],
        type: jsonApi["attributes"]["type"],
        notes: jsonApi["attributes"]["notes"],
        download_url: jsonApi["attributes"]["download_url"],
        manifest_url: jsonApi["attributes"]["manifest_url"],
        processed: jsonApi["attributes"]["processed"])
    end

    def initialize(options)
      @version = options[:version]
      @short_version = options[:short_version]
      @type = options[:type]
      @notes = options[:notes]
      @download_url = options[:download_url]
      @manifest_url = options[:manifest_url]
      @processed = options[:processed]
      @identifier = options[:identifier] # mandatory if uploading to reference the app for the build
      @file_path = options[:file_path]
    end

  end
end