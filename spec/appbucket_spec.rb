require 'spec_helper'

describe Appbucket do
  Appbucket.host "localhost:3000"

  it 'has a version number' do
    expect(Appbucket::VERSION).not_to be nil
  end

  it 'uploads a build with simplified interface' do
    ipa_path = "./spec/resources/runtasticPRO.ipa"
    expect(Appbucket.uploadIPA(ipa_path)).to be true
  end

  it 'lists the available builds' do
    expect(Appbucket.list.count).to be >= 1
  end

end
