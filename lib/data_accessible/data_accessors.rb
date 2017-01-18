module DataAccessible
  module DataAccessors
    module_function

    def accessor_for_obj(obj)
      obj.to_h.keys.each do |key|
        define_accessor(obj, key)
      end
    end

    def accessor_for_data(data)
      HashMethods.each_hash(data) do |hash|
        hash.each do |key, value|
          define_accessor(hash, key)
          accessor_for_data(value)
        end
      end
    end

    def define_accessor(obj, key)
      define_getter(obj, key)
      define_setter(obj, key)
    end

    def define_getter(obj, key)
      obj.define_singleton_method(key) do
        obj.to_h.fetch(key)
      end
    end

    def define_setter(obj, key)
      obj.define_singleton_method("#{key}=") do |value|
        obj.to_h[key] = DataAccessible::DataAccessors.accessor_for_data(value)
      end
    end
  end
end
