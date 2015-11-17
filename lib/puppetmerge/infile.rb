require 'pathname'
require 'puppetmerge/filetype'

class PuppetMerge
# This class represents one file in a module
  class InFile < Pathname

    attr_reader :source
    attr_reader :destination
    attr_reader :path

    # the target pathname of this file
    attr_reader :target

    @@directory_name_patterns = {
      /manifests/           => :puppet,
      /templates/           => :erb,
      /(spec|lib)/          => :ruby,
      /(hiera|hieradata)/   => :yaml,
    }

    @@file_name_patterns = {
      /\.pp$/                 => :puppet,
      /\.rb$/                 => :ruby,
      /\.erb$/                => :erb,
      /\.(yml|yaml)/          => :yaml,
      /\.json/                => :json,
      /^(Rakefile|Gemfile)$/  => :ruby,
    }

    def initialize(path, source = nil, destination = nil)
      super(path)
      @path = path
      @source = source
      @destination = destination
    end

    def relative_path
      @relative_path ||= Pathname.new(@path).relative_path_from(Pathname.new(source)).to_s
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

    def filetype?
      dirname = File.dirname(relative_path).split(File::SEPARATOR)[0]

      ftype = nil
      @@file_name_patterns.each do |pattern, type|
        ftype = type if relative_path =~ pattern
      end

      if ftype.nil?
        @@directory_name_patterns.each do |pattern, type|
          ftype = type if dirname =~ pattern
        end
      end

      PuppetMerge::FileType.new(ftype || :unknown)
    end

  end
end

