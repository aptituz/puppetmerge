require 'find'
require 'puppetmerge/modulefile'

module PuppetMerge
  # This class holds infos about files found in a source and destination directory
  # (e.g. all files, newfiles and changedfiles)
  class Files

    # source directory
    attr_reader :source

    # destination directory
    attr_reader :destination

    # Return all files in the sourcedirectory, except those matching reject patterns
    attr_reader :sourcefiles

    # Contains all files new to to the destination (files which exist in source directory only)
    attr_reader :newfiles

    # Contains all changed files, that is files existing in both directories but differing
    attr_reader :changedfiles

    def initialize(source, destination)
      @source = source
      @destination = destination
    end

    def sourcefiles
      @sourcefiles ||= begin
        files = []
        Find.find(source) do |path|
          Find.prune && next if reject_path?(path)
          path = PuppetMerge::ModuleFile.new(path, source, destination)
          files << path unless FileTest.directory?(path)
          yield path if block_given?
        end
        files
      end
    end


    def newfiles
      @newfiles ||= begin
        files = []
        sourcefiles.each do |modfile|
          if File.exist?(modfile.target)
            next
          else
            files << modfile
          end
          yield modfile if block_given?
        end
        files
      end


    end

    def changedfiles
      @changedfiles ||= begin
        files = []
        (sourcefiles - newfiles).each do |modfile|
          unless FileUtils.compare_file(modfile, modfile.target)
            files << modfile
            yield modfile if block_given?
          end
        end
        files
      end
    end

    private
    def reject_path?(path)
      if FileTest.directory?(path)
        return true if File.basename(path) =~ /(.svn|.git)/
      else
        # FIXME: Can we avoid this? We are adding those files afterall
        return true if File.basename(path) =~ /\.orig$/
        # FIXME: Implement a blacklist mechanism for certain patterns
      end
      false
    end

    private
    def relpath(path)
      Pathname.new(path).relative_path_from(Pathname.new(source)).to_s
    end

  end
end