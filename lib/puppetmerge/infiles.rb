require 'find'

# This class holds infos about files found in a source and destination directory
# (e.g. all files, newfiles and changedfiles)
class PuppetMerge
  class InFiles

    # source directory
    attr_reader :source

    # destination directory
    attr_reader :destination

    # Return all files in the sourcedirectory, except those matching reject patterns
    attr_reader :all

    # Contains all files new to to the destination (files which exist in source directory only)
    attr_reader :additions

    # Contains all changed files, that is files existing in both directories but differing
    attr_reader :changed

    def initialize(source, destination)
      @source = source
      @destination = destination
    end

    def all
      @all ||= begin
        files = []
        Find.find(source) do |path|
          Find.prune && next if reject_path?(path)
          path = ::PuppetMerge::InFile.new(path, source, destination)
          files << path unless FileTest.directory?(path)
          yield path if block_given?
        end
        files
      end
    end


    def additions
      @additions ||= begin
        files = []
        all.each do |modfile|
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

    def changed
      @changed ||= begin
        files = []
        (all - additions).each do |modfile|
          if modfile.changed?
            files << modfile
            yield modfile if block_given?
          end
        end
        files
      end
    end

    private
    def reject_path?(path)
      basename = File.basename(path)
      if FileTest.directory?(path)
        return true if basename =~ /(.svn|.git)/
      else
        # FIXME: Can we avoid this? We are adding those files afterall
        return true if basename =~ /\.orig$/

        PuppetMerge.configuration.exclude_patterns.each do |p|
          return true if basename =~ p
        end
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
