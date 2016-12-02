module Helpers
  def self.included(base)
    base.class_eval do
      no_tasks do
        def script_builder(distro, version, provider)
          # Need to make provider optional?
          load_scripts=YAML::load(File.read("config/scripts.yaml"))
          scripts=load_scripts["#{distro}_#{version}"]["#{provider == nil ? provider == 'vbox' : provider}"]
          scripts.each { |k, v| File.open("build/#{k}.sh", "w" ) {|f| f.write("#{v}") } }
        end

        # TODO:
        # def validate_provider(provider)
        #   approved=[]
        #   filenames=Dir.entries("config/providers/")
        #   filenames.each do |f|
        #     next if f == '.'|| f == '..'
        #     approved << File.basename(f, '.yaml')
        #   end
        #   raise "Not a valid provider" unless approved.include?(provider)
        # end
        # def validate_distro(distro)
        #   # distros would need to be an array, we'd probably have to hash them?
        # end
        # def validate_version(version)
        #   # versions have to be distro specific
        # end

        def valid_file_location?(input)
          File.directory?(input)
        end
        
      end
    end
  end
end
