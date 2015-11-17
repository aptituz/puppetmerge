class PuppetMerge
	class FileType
		@@filetype_strings = {
			:ruby 		=> 'Ruby script',
			:puppet 	=> 'Puppet Manifest',
			:erb		=> 'ERB Template',
			:json		=> 'JSON File',
			:yaml		=> 'YAML document',
			:unknown	=> 'Unknown filetype'
		}

		attr_reader :ftype

		def initialize(ftype)
			@ftype = ftype
		end

		def to_s
			@@filetype_strings[ftype]
		end
	end
end
