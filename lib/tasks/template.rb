module Template
  def self.included(base)
    base.class_eval do
      desc "template [options]", "template command"
      option :distro, :required => true, :type => :string, :aliases => "-d"
      option :version, :required => true, :type => :string, :aliases => "-v"
      option :provider, :type => :string, :aliases => "-p"
      long_desc <<-LONGDESC
      Builds the packer image depending on options, defaults to virtualbox build
      LONGDESC
      def template
        # puts ARGV.join(" ")
        # Load all variables from yaml into environment (except token, should be
        # set in .profile or by other means)
        build_variables=YAML::load(File.read("config/variables.yaml"))

        # Set variables in the environment
        build_variables.each do |k,v|
          puts ENV[k.upcase]=v
        end
        template_json=File.open( "build/template.json","w" )
        template_json<<JSON.pretty_generate(YAML.load(File.read("config/#{( options[:provider]=='virtualbox' ?  'vbox' : options[:provider] )}.yaml")))
        template_json.close

        # Build the project
        puts exec("packer build build/template.json")
      end
    end
  end
end
