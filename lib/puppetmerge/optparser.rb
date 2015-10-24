require 'optparse'

class PuppetMerge
  class OptParser
    def self.build
      OptionParser.new do |opt|
        opt.banner = 'Usage: puppetmerge [OPTIONS] inputdir <outdir>'
        opt.separator ''
        opt.separator 'Options'

        opt.on('--debug', 'Enable debug mode') do |arg|
          PuppetMerge.configuration.debug = arg
        end

        opt.on('--verbose', 'Be verbose') do |arg|
          PuppetMerge.configuration.flags[:verbose] = arg
        end

        opt.on('--noop', 'Do not actually do anything') do |arg|
         PuppetMerge.configuration.flags[:noop] = arg
        end

        opt.on('--diff-args ARGS',
               'Specify additional arguments to diff cmd') do |args|
          PuppetMerge.configuration.diff_args << args
        end

        opt.on('--copy-new', 'Copy new files without confirmation') do |arg|
          PuppetMerge.configuration.copy_new = arg
        end

        opt.on('-h', '--help', 'help') do
          puts opt_parser
        end

        begin
          opt.load(File.expand_path('~/.puppetmerge.conf'))
        rescue Errno::EACCES
          # nothing to do
        end

      end
    end

  end
end
