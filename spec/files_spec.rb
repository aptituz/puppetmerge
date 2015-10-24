require 'spec_helper'

describe PuppetMerge::InFiles do
  before do
    @indir = tmpdir + "/srcmod/"
    @outdir = tmpdir + "/dstmod"
    @filefinder = PuppetMerge::InFiles.new(@indir, @outdir)
  end

  describe '.all' do
    it "has entries" do
      expect(@filefinder.all).not_to be_empty
    end

    it "contains all expected entries" do
      expect(@filefinder.all.map { |p| p.relative_path }).to contain_exactly('manifests/init.pp', 'manifests/params.pp', 'manifests/subclass.pp')
    end

  end

  describe '.additions' do
    it "has some entries" do
      expect(@filefinder.additions).not_to be_empty
    end

    it "contains file which is not in destination module" do
      expect(@filefinder.additions.map { |p| p.relative_path }).to include('manifests/params.pp')
    end

    it "does not contain file which is in both modules" do
      expect(@filefinder.additions.map { |p| p.relative_path }).not_to include('manifests/init.pp')
    end
  end

  describe '.changedfiles' do
    it "has some entries" do
      expect(@filefinder.additions).not_to be_empty
    end

    it "contains no additions" do
      expect(@filefinder.changed).not_to include(@filefinder.additions)
    end

    it "contains only files which are different between source and dest" do
      expect(@filefinder.changed.map { |p| p.relative_path }).to contain_exactly('manifests/init.pp')
    end
  end

end
