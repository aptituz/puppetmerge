require 'puppetmerge/infile'
require 'puppetmerge/infiles'
require 'puppetmerge/diff'
require 'puppetmerge/optparser'
require 'puppetmerge/configuration'
require 'puppetmerge/bin'

class PuppetMerge
  def self.configuration
      @configuration ||= PuppetMerge::Configuration.new
  end

  def configuration
    self.class.configuration
  end

  def initialize(inputdir, outputdir)
    @inputdir = inputdir
    @outputdir = outputdir

    PuppetMerge
  end

  def inputfiles
    @inputfiles ||= PuppetMerge::InFiles.new(@inputdir, @outputdir)
  end

  class PatchException < StandardError; end
end

PuppetMerge.configuration.defaults
