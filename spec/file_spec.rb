require 'spec_helper'

describe PuppetMerge::InFile do
  before(:all) do
    @path = tmpdir + "/srcmod/manifests/init.pp"
    @srcpath = tmpdir + "/srcmod/"
    @dstpath = tmpdir + "/dstmod"
    @file = PuppetMerge::InFile.new(@path, @srcpath, @dstpath)

  end

  it ".relative_path" do
    expect(@file.relative_path).to eq 'manifests/init.pp'
  end

  it ".target" do
    expect(@file.target).to eq File.join(@dstpath, 'manifests', 'init.pp')
  end

  describe ".copy_to_target creates files" do

    it "creates file" do
      @file.copy_to_target
      expect(File.exist?(@file.target)).to be true
    end

    it "has right content" do
      expect(File.read(@file.target)).to eq File.read(@file)
    end
  end

  it ".content_as_diff" do
      diff = @file.content_as_diff
      expect(diff).not_to be_empty
  end

end
