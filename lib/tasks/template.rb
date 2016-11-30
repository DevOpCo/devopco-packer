module Template
  def self.included(base)
    base.class_eval do
      desc "template {argument} [options]", "template command"
      option :opt1, :required => true, :aliases => "-c"
      option :opt2, :required => true, :aliases => "-e"
      option :opt3, :required => true, :aliases => "-v"
      long_desc <<-LONGDESC
        Use this module to generate any new commands
        By copying, replacing the names, and adding
        Into the PlatImp.rb file in the include section

        Removing the `:required => true,` from the option
        Will allow for logic that is not as granular
        When looking for details in a larger scope
      LONGDESC
      def template(argument)
        puts argument
        puts "this is an example/template for thor tasks"
        puts 'To access options use #{options[:option_name]}'
        puts "e.g. If called correctly, you've put --opt1= or -a #{options[:opt1] || 'opt1 not called'} --opt2 or -e #{options[:opt2] || 'opt2 not called'} --opt3= or -v #{options[:opt3] || 'opt3 not called'}"
      end
    end
  end
end
