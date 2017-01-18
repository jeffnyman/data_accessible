module DataAccessible
  module HashMethods
    module_function

    def deep_merge(original_data, new_data)
      merger = proc do |_key, v1, v2|
        v1.is_a?(Hash) && v2.is_a?(Hash) ? v1.merge(v2, &merger) : v2
      end

      original_data.merge(new_data, &merger)
    end

    def each_hash(data, &block)
      case data
        when Hash
          yield data
        when Array
          data.each { |element| each_hash(element, &block) }
      end
      data
    end
  end
end
