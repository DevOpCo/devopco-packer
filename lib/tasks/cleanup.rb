module Cleanup
  def self.included(base)
    base.class_eval do
      desc "cleanup [options]", "cleanup command"
      option :save, :type => :string, :aliases => "-s"
      long_desc <<-LONGDESC
      Clears out the build artifacts, removes packer_cache/ and files within build/

      run with `-s` intend to keep the iso created by packer
      LONGDESC
      def cleanup
        source_location = Dir[File.join('packer_cache', '*.iso')].first
        if source_location.nil?
          puts "No ISO found"
        end
        if options[:save] && !source_location.nil?
          target_location = ask("New ISO location:")
          cleanup unless valid_file_location?(target_location) # recurse until valid
          FileUtils.mv(source_location, target_location)
        end
        unless options[:save]
          puts "Removing build artifacts"
          Dir.foreach('build') {|f| fn = File.join('build', f); File.delete(fn) if f != '.' && f != '..' && f != '.gitkeep'}
          FileUtils.rm_rf 'packer_cache/'
        end
      end
    end
  end
end
