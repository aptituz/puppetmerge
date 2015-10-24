require 'diffy'
require 'English'
require 'diff/lcs'
require 'diff/lcs/hunk'

class PuppetMerge
  class Changes
    attr_reader :file_old
    attr_reader :file_new

    def initialize(file1, file2)
      @file_old = file1
      @file_new = file2
    end

    def read_file(fname)
      File.readlines(fname).map { |l| l.chomp }
    end

    def data_old
      @data_old ||= read_file(@file_old)
    end

    def data_new
      @data_new ||= read_file(@file_new)
    end

    def changes
      @changes ||= Diff::LCS.diff(
        data_old,
        data_new
      )
    end

    def unified_diff
      output = ''
      ft = File.stat(file_old).mtime.localtime.strftime('%Y-%m-%d %H:%M:%S.%N %z')
            output << "--- #{file_old}\t#{ft}\n"
            ft = File.stat(file_new).mtime.localtime.strftime('%Y-%m-%d %H:%M:%S.%N %z')
            output << "+++ #{file_new}\t#{ft}\n"
      hunks.each do |hunk|
        output << hunk.diff(:unified).to_s + "\n"
      end
      output
    end

    def hunks
      @hunks ||= begin
        oldhunk = hunk = nil
        file_length_difference = 0
        hunks = []
        changes.each do |p|
          begin
            hunk = Diff::LCS::Hunk.new(data_old, data_new, p, 2,
                                     file_length_difference)
            file_length_difference = hunk.file_length_difference

            next if hunk.merge(oldhunk)
          ensure
            oldhunk = hunk
          end
          hunks << oldhunk
        end
        hunks
      end
    end
  end
end
