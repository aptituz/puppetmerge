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
          file "init.pp", "class srcmod {}\n# test"
          file 'subclass.pp', "common between both"
          file "params.pp", "class srcmod::params {}" # only in source
          file 'biggerchange.pp', <<EOF
          # line1
          # line2
          # line3
          # line4
          # line5
          # line6
          # line7
          # line8
          # line9
          # line10
EOF

        end
      end

      # dest module
      dir "dstmod" do
        dir "manifests" do
          file "init.pp", "class dstmod {}"
          file 'subclass.pp', 'common between both'
          file 'biggerchange.pp', <<EOF
          # line1
          # line2 -> 'CHANGED'
          # line3
          # line4
          # line5
          # line6
          # line7
          # line8
          # line9
          # line10
          # line11 -> ADDED
EOF
        end
      end
    end
  end
end


