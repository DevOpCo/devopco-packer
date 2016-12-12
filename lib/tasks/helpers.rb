module Helpers
  def self.included(base)
    base.class_eval do
      no_tasks do

        def script_builder(distro, version, provider)
          approved=[]
          filenames=Dir.entries("config/providers/")
          filenames.each do |f|
            next if f == '.'|| f == '..'
            approved << File.basename(f, '.yaml')
          end
          output=[]
          output << "Not a valid provider"
          output << "Valid providers include the following:"
          output << approved.each { |e| e }
          puts output unless approved.include?(provider)
          if approved.include?(provider)
            build_variables=YAML::load(File.read("config/variables.yaml"))
            build_variables.each do |k,v|
              if ENV['DEBUG']
                puts ENV[k.upcase]=v
              end
              ENV[k.upcase]=v
            end
            load_scripts=YAML::load(File.read("config/scripts.yaml"))
            scripts=load_scripts["#{distro}_#{version}"]["#{provider}"]
            scripts.each { |k, v| File.open("build/#{k}.sh", "w" ) {|f| f.write("#{v}") } }
            template_json=File.open( "build/template.json","w" )
            template_json<<JSON.pretty_generate(YAML.load(File.read("config/providers/#{provider}.yaml")))
            template_json.close
            puts exec("packer build build/template.json")
          end
        end

        # TODO:
        # def validate_distro(distro)
        # 
        #   May move this inside script_builder method
        # end
        # def validate_version(version)
        #   # versions have to be distro specific
        # end
        def centos_mirrors(version)
          mirrors=[]
          architecture='x86_64/'
          base_iso_url='http://isoredirect.centos.org'
          build_iso_url=[base_iso_url, 'centos', version, 'isos', architecture]
          iso_url=build_iso_url.join('/')
          doc = Nokogiri::HTML(open(iso_url))
          doc.css('a').map do |link|
            if link['href'].include? '/isos/x86_64/'
              mirrors << link['href']
            end
          end
          puts mirrors
        end

        def ubuntu_isos(major_version, minor_version, patch_version)
          isos=[]
          iso_shas=[]
          base_iso_url='http://releases.ubuntu.com'
          version=[major_version, minor_version, patch_version].join('.')
          build_iso_url=[base_iso_url, version]
          iso_url=build_iso_url.join('/')
          iso_sha_url=iso_url+'/SHA256SUMS'
          doc = Nokogiri::HTML(open(iso_url))
          check=['server', 'iso', 'amd64']
          doc.css('a').map do |link|
            check.any? do |c|
              unless link['href'].include? 'desktop'
                if link['href'].include? c
                  if link['href'].end_with? 'iso'
                      isos << link['href']
                  end
                end
              end
            end
          end
          isos=isos.uniq

          puts iso_shas
          puts iso_sha_url
        end
        #
        # def centos_isos
        #
        # end
        #
        # def ubuntu_mirrors
        #
        # end
        #
        # def ubuntu_isos
        #
        # end

        def valid_file_location?(input)
          File.directory?(input)
        end

      end
    end
  end
end
