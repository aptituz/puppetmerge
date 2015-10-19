require 'puppetmerge/modulefile'
require 'puppetmerge/files'
require 'puppetmerge/diff'
require 'puppetmerge/optparser'
require 'puppetmerge/configuration'

class PuppetMerge

  def self.configuration
      @configuration ||= PuppetMerge::Configuration.new
  end

  def configuration
    self.class.configuration
  end
end

PuppetMerge.configuration.defaults
