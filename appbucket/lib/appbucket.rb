require "appbucket/version"
require "build"
require "ipa_analyzer"

module Appbucket
  @host_url = nil
  @api_base_path = "/api"

  def self.host(host_url)
  	@host_url = host_url
  end

  def self.base_url 
  	"#{@host_url}#{@api_base_path}"
  end

  # Simplified interface for list all available builds
  def self.list
  	return Appbucket::Build.get
  end

  # Simplified interface for uploading a app build file (ipa)
  # Will read all necessary information from the ipa bundle and uploads it to `app-bucket`
  # returns `true` on success else `false`
  def self.uploadIPA(ipaPath)
  	ipa_analyzer = IpaAnalyzer::Analyzer.new(ipaPath)
  	ipa_analyzer.open!
  	ipa_info = ipa_analyzer.collect_info_plist_info

  	bundle_version = ipa_info[:content]["CFBundleShortVersionString"]
  	bundle_identifier = ipa_info[:content]["CFBundleIdentifier"]

  	build = Appbucket::Build.new(version: bundle_version, file_path:ipaPath , identifier: bundle_identifier)
    result = Appbucket::Build.post(build)

    return false unless result else true
  end
end
