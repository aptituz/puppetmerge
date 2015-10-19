require 'diffy'

class PuppetMerge
  class Diff < Diffy::Diff
    def diff
      # NOTE: We do not support all options of Diffy:Diff
      @diff ||= begin
        paths = [string1, string2]

        diff = Open3.popen3(diff_bin, *(diff_options + paths)) do |_, o, e|
          err = e.read
          fail "An error occured (retval #{$CHILD_STATUS.exitstatus}): #{err}" unless err.empty?
          o.read
        end
        diff.force_encoding('ASCII-8BIT') if diff.respond_to?(:valid_encoding?) && !diff.valid_encoding?
        if diff =~ /\A\s*\Z/ && !options[:allow_empty_diff]
          diff = File.read(string1).gsub(/^/, ' ')
        end
        diff
      end
    end
  end
end
