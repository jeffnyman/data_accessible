require "erb"
require "yaml"

module DataAccessible
  module DataLoader
    module_function

    def process_erb(text)
      ERB.new(text).result
    end

    def load_from_file(file)
      contents = File.read(file)
      evaluated_contents = process_erb(contents)
      YAML.load(evaluated_contents) || {}
    end

    def load_source(data_source)
      case data_source
        when Hash
          data_source
        when String
          load_from_file(data_source)
        when Symbol
          load_from_file("#{DataAccessible.data_path}/#{data_source}.yml")
        else
          raise("Invalid data source provided: #{data_source}")
      end
    end
  end
end
