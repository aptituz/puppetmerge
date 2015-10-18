require 'pathname'


module PuppetMerge
  # This class represents one file in a module
  class ModuleFile < ::Pathname

    attr_reader :source
    attr_reader :destination

    # the target pathname of this file
    attr_reader :target

    def initialize(path, source = nil, destination = nil)
      super(path)
      @source = source
      @destination = destination
    end

    def relative_path
      relative_path_from(Pathname.new(source)).to_s
    end

    def target
      @target ||= File.join(destination, relative_path)
    end

  end
end


