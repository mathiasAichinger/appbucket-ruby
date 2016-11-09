require "appbucket/version"
require "appbucket/build"
require "ipa_analyzer"

module Appbucket
	@host_url = nil
	@api_base_path = "/api"
	
	public

	# Seets the host of Appbucket
	#
	# Must be specified before any other opperation
	#
	#--
	# TODO: check if host is available
	#
  	def self.host(host_url)
		@host_url = host_url
	end

	# Simplified interface for list all available builds
  	#
  	# *Returns*: A list of all available builds in Appbucket
  	def self.list
  		return Appbucket::Build.get
  	end

  	# Simplified interface for uploading a _ipa-build-file_
  	#
  	# Will read all necessary information from the ipa bundle and uploads it to `app-bucket`
  	#
  	# *Parameter*:
  	# - +ipaPath+: Fielpath to the _ipa-File_ to upload
  	# - +notes+ (optional): Additional notes to the build file
  	#
  	# *Returns*: +true+ on success else +false+
  	def self.uploadIPA(ipaPath, notes = "", category = "")
  		begin
  			ipa_analyzer = IpaAnalyzer::Analyzer.new(ipaPath)
  			ipa_analyzer.open!
  			ipa_info = ipa_analyzer.collect_info_plist_info
  		rescue Exception => e
  			puts "[#{self.name}] ERROR: #{e.message}"
  			return false	
  		end
  	
  		bundle_version = ipa_info[:content]["CFBundleShortVersionString"]
  		bundle_identifier = ipa_info[:content]["CFBundleIdentifier"]

  		build = Appbucket::Build.new(version: bundle_version, 
  			file_path:ipaPath,
  			identifier: bundle_identifier,
  			notes: notes,
        category: category)
  		result = Appbucket::Build.post(build)

  		return false unless result else true
  	end

	private
	
	def self.base_url
		return "#{@host_url}#{@api_base_path}" 
	end
 end
