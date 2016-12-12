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
        script_builder(distro, version, provider)
      end
    end
  end
end
