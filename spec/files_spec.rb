require 'spec_helper'

describe PuppetMerge::Files do
  before do
    @srcpath = tmpdir + "/srcmod/"
    @dstpath = tmpdir + "/dstmod"
    @filefinder = PuppetMerge::Files.new(@srcpath, @dstpath)
  end

  describe '.sourcefiles' do
    it "has entries" do
      expect(@filefinder.sourcefiles).not_to be_empty
    end

    it "contains all expected entries" do
      expect(@filefinder.sourcefiles.map { |p| p.relative_path }).to contain_exactly('manifests/init.pp', 'manifests/params.pp', 'manifests/subclass.pp')
    end

  end

  describe '.newfiles' do
    it "has some entries" do
      expect(@filefinder.newfiles).not_to be_empty
    end

    it "contains file which is not in destination module" do
      expect(@filefinder.newfiles.map { |p| p.relative_path }).to include('manifests/params.pp')
    end

    it "does not contain file which is in both modules" do
      expect(@filefinder.newfiles.map { |p| p.relative_path }).not_to include('manifests/init.pp')
    end
  end

  describe '.changedfiles' do
    it "has some entries" do
      expect(@filefinder.newfiles).not_to be_empty
    end

    it "contains no newfiles" do
      expect(@filefinder.changedfiles).not_to include(@filefinder.newfiles)
    end

    it "contains only files which are different between source and dest" do
      expect(@filefinder.changedfiles.map { |p| p.relative_path }).to contain_exactly('manifests/init.pp')
    end
  end

end
