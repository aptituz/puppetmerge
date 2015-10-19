require 'puppetmerge/modulefile'
require 'puppetmerge/files'
require 'puppetmerge/diff'

class PuppetMerge

  attr_accessor :opts

  def initialize(opts)
    @opts = opts
  end

  def foo
    puts opts.foo
  end

end