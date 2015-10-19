class PuppetMerge
  class Configuration
    def method_missing(method, *args, &block)
      if method.to_s =~ /^(\w+)=$/
        opt = $1
        add_setting(opt.to_s) if settings[opt].nil?
        settings[opt] = args[0]
      else
        puts "#{method}"
        nil
      end
    end

    def flags
      self.flags ||= {}
    end

    def add_setting(key)
      self.class.add_setting(key)
    end

    def self.add_setting(key)
      define_method("#{key}=") do |value|
        settings[key] = value
      end

      define_method(key) do
        settings[key]
      end
    end

    def settings
      @settings ||= {}
    end

    def defaults
      settings.clear
      self.source = '.'
      self.target = '.'
      self.copy_new = false
      self.debug = false
      self.flags = {}
      self.diff_args = ['-Nwu']
    end
  end
end