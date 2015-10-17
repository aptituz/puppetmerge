require 'puppetmerge'
require 'files'

RSpec.configure do |config|
  def tmpdir
    @tmpdir ||= create_tmpdir
  end

  def create_tmpdir
    Files do
      # source module
      dir "srcmod" do
        dir "manifests" do
          file "init.pp", "class srcmod {}"
          file 'subclass.pp', "common between both"
          file "params.pp", "class srcmod::params {}" # only in source
        end
      end

      # dest module
      dir "dstmod" do
        dir "manifests" do
          file "init.pp", "class dstmod {}"
          file 'subclass.pp', 'common between both'
        end
      end
    end
  end
end
