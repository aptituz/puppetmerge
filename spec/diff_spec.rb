require 'spec_helper'

describe 'PuppetMerge::Changes' do
    before do
        @file1 = tmpdir + '/srcmod/manifests/init.pp'
        @file2 = tmpdir + '/dstmod/manifests/init.pp'

        @diff = PuppetMerge::Changes.new(@file1, @file2)
    end

    describe '.diff' do
        it "returns something" do
            expect(@diff.diff).not_to be_empty
        end
    end

end
