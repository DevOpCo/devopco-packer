require 'spec_helper'
require 'yaml'

describe 'Loading YAML configuration file' do
  Dir[File.expand_path(__FILE__), 'config/*.yml'].each do |file|
    context "When parsing #{file}" do
      it 'parses successfully' do
        expect {
          YAML.load_file(file)
        }.not_to raise_error
      end
    end
  end
end
