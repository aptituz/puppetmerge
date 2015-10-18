require 'spec_helper'

describe PuppetMerge::ModuleFile do
  before do
    @path = tmpdir + "/srcmod/manifests/init.pp"
    @srcpath = tmpdir + "/srcmod/"
    @dstpath = tmpdir + "/dstmod"
    @file = PuppetMerge::ModuleFile.new(@path, @srcpath, @dstpath)
  end

  it ".relative_path" do
    expect(@file.relative_path).to eq 'manifests/init.pp'
  end

  it ".target" do
    expect(@file.target).to eq File.join(@dstpath, 'manifests', 'init.pp')
  end
end
