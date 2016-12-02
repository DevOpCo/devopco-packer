module Template
  def self.included(base)
    base.class_eval do
      desc "template [options]", "template command"
      option :distro, :type => :string, :aliases => "-d"
      option :version, :type => :string, :aliases => "-v"
      option :provider, :type => :string, :aliases => "-p"
      long_desc <<-LONGDESC
      Builds the packer image depending on options, defaults to virtualbox build
      LONGDESC
      def template
        distro=options[:distro]
        version=options[:version]
        options[:provider] == nil ? provider='vbox' : provider=options[:provider]
        if distro && version
          # Load all variables from yaml into environment (except token, should be
          # set in .profile or by other means like a .envrc using direnv)
          build_variables=YAML::load(File.read("config/variables.yaml"))
          # Set variables in the environment
          build_variables.each do |k,v|
            if ENV['DEBUG']
              puts ENV[k.upcase]=v
            end
            ENV[k.upcase]=v
          end
          script_builder(distro, version, provider)
          template_json=File.open( "build/template.json","w" )
          template_json<<JSON.pretty_generate(YAML.load(File.read("config/providers/#{provider}.yaml")))
          template_json.close
          # Build the project
          # puts exec("packer build build/template.json")
          puts 'exec("packer build build/template.json")'
        end
      end
    end
  end
end
