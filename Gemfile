source 'https://rubygems.org'

if Gem::Version.new(Bundler::VERSION) < Gem::Version.new(File.read('.bundler-version'))
          exec("gem install bundler -v \'#{File.read('.bundler-version')}\' && bundle install")
end

gem 'thor'
gem 'nokogiri', '~> 1.6.8'

gem 'rspec', :group => [:development, :test]
