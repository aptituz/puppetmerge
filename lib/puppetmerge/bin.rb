require 'puppetmerge/optparser'
require 'highline/import'

class PuppetMerge::Bin
  def initialize(args)
    @args = args
  end

  def run
    opts = PuppetMerge::OptParser.build
    opts.parse!(@args)

    if @args[0].nil?
      puts "puppetmerge: no input directory specified"
      puts opts
      return 1
    end

    indir = @args.shift
    outdir = @args.shift || '.'

    if File.absolute_path(indir) == File.absolute_path(outdir)
      puts 'source and target module are the same: that makes no sense'
      Kernel.exit(1)
    end

    p = PuppetMerge.new(indir, outdir)

    # Process newly added files first ...
    p.inputfiles.additions.each do |file|
      copy_file = false
      if PuppetMerge.configuration.copy_new
        copy_file = true
      else
        puts file.content_as_diff
        puts "File #{file.relative_path} is new."
        copy_file = true if agree("Accept new file? (yes, no)")
      end

      file.copy_to_target if copy_file
    end

    # ... and then changed files
    p.inputfiles.changed.each do |file|
      begin
        diff = file.changes
        puts diff.unified_diff
        puts "affected file: #{file.relative_path}"
        response = accept_diff?

        unless response == 'no'
          file.copy_to_target
          system('vim', file.target) if response == 'edit'
        end
      rescue PuppetMerge::PatchException
        retry
      end
    end

    return 0
  end

  def accept_diff?
    ask "Apply this changes? (yes, no, edit (after applying))" do |q|
      q.validate = /\Ay(?:es)?|no?|edit?\Z/i
      q.responses[:not_valid]    = 'Please enter "yes", "no" or "edit".'
      q.responses[:ask_on_error] = :question

      yield q if block_given?
    end
  end
end
