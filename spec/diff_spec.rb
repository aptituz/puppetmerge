require 'spec_helper'
require 'files'

describe 'PuppetMerge::Changes' do
  before do
    @file1 = tmpdir + '/srcmod/manifests/init.pp'
    @file2 = tmpdir + '/dstmod/manifests/init.pp'

    @diff = PuppetMerge::Changes.new(@file1, @file2)
  end

  it { expect(@diff).to respond_to(:changes) }


  describe '.changes' do
    context "with two changed files" do
      it "returns something" do
        expect(@diff.changes).not_to be_empty
      end

      it 'returns kind of Array' do
        expect(@diff.changes).to be_kind_of(Array)
      end
    end

    context "with empty files" do
      diff = PuppetMerge::Changes.new('/dev/null', '/dev/null')
      it 'returns no changes' do
        expect(diff.changes).to be_empty
      end
    end

    context "with equal files" do
      f1 = tmpdir + '/srcmod/manifests/subclass.pp'
      f2 = tmpdir + '/srcmod/manifests/subclass.pp'
      diff = PuppetMerge::Changes.new(f1, f2)
      it 'returns no changes' do
        expect(diff.changes).to be_empty
      end
    end
  end

  describe '.hunks' do
    context 'with two consecutive changed lines' do
      it 'returns one hunk' do
        expect(@diff.hunks.length).to eq(1)
      end
    end
  end

  context 'with multiple blocks of changes' do
    f1 = tmpdir + '/srcmod/manifests/biggerchange.pp'
    f2 = tmpdir + '/dstmod/manifests/biggerchange.pp'
    diff = PuppetMerge::Changes.new(f1, f2)
    it 'returns more then one hunk' do
      expect(diff.hunks.length).to be > 1
    end

    describe '.unified_diff' do
      it 'returns something' do
        expect(diff.unified_diff).not_to be_empty
      end
    end

  end


  describe '.unified_diff' do
    it 'returns a string' do
      expect(@diff.unified_diff).to be_kind_of(String)
    end

  end

end
