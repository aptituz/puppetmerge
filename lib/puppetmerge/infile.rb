require 'pathname'

class PuppetMerge
# This class represents one file in a module
  class InFile < Pathname

    attr_reader :source
    attr_reader :destination

    # the target pathname of this file
    attr_reader :target

    def initialize(path, source = nil, destination = nil)
      super(path)
      @path = path
      @source = source
      @destination = destination
    end

    def relative_path
      Pathname.new(@path).relative_path_from(Pathname.new(source)).to_s
    end

    def target
      @target ||= File.join(destination, relative_path)
    end

    def copy_to_target
      parent = File.dirname(target)
      FileUtils.mkdir_p(File.dirname(target))
      FileUtils.cp(self, target)
    end

    def content_as_diff
      each_line.collect do |line|
        '+' + line
      end.join('')
    end

    def changes
      @changes ||= PuppetMerge::Changes.new(self, target)
    end

    def changed?
      unless FileUtils.compare_file(@path, target)
        # we check twice, since the diff might still be empty
        # because of filtering that will take place
        !changes.changes.empty?
      end
    end

  end
end

