class PuppetMerge
  class OptParser
    def self.build
      OptionParser.new do |opt|
        opt.banner = 'Usage: puppetmerge [OPTIONS] source destination'
        opt.separator ''
        opt.separator 'Options'

        opt.on('--debug', 'Enable debug mode') do |arg|
          PuppetMerge.configuration.debug = arg
        end

        opt.on('--verbose', 'Be verbose') do |arg|
          PuppetMerge.configuration.noop = arg
        end

        opt.on('--noop', 'Do not actually do anything') do |arg|
         PuppetMerge.configuration.noop = arg
        end

        opt.on('--diff-args ARGS',
               'Specify additional arguments to diff cmd') do |args|
          PuppetMerge.configuration.diff_args << args
        end

        opt.on('--copy-new', 'Copy new files without confirmation') do |arg|
          PuppetMerge.configuration.copy_new = arg
        end

        opt.on('-s', '--source SOURCEDIR',
               'Specify source directory (default: $PWD)') do |s|
          PuppetMerge.configuration.source = File.absolute_path(s)
        end

        opt.on('-d', '--destination DESTDIR',
               'Specify destination directory (default: $PWD)') do |d|
          PuppetMerge.configuration.target = File.absolute_path(d)
        end

        opt.on('-h', '--help', 'help') do
          puts opt_parser
        end
      end
    end
  end
end