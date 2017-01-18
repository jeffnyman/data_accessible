require "data_accessible/version"
require "data_accessible/data_loader"
require "data_accessible/hash_methods"
require "data_accessible/data_accessors"

module DataAccessible
  def self.included(caller)
    caller.extend ClassMethods
  end

  def self.sources
    klass = Class.new { extend ClassMethods }
    yield klass if block_given?
    klass
  end

  module ClassMethods
    def data_load(data_source, namespace = nil)
      to_h.clear
      data_merge(data_source, namespace)
    end

    def data_merge(data_source, namespace = nil)
      source_data = DataLoader.load_source(data_source)
      new_data = namespace ? source_data.fetch(namespace) : source_data

      @data = HashMethods.deep_merge(to_h, new_data)

      DataAccessors.accessor_for_obj(self)
      DataAccessors.accessor_for_data(to_h)

      to_h
    end

    def to_h
      @data ||= {}
    end

    def [](key)
      to_h[key]
    end

    def []=(key, value)
      DataAccessors.define_accessor(to_h, key)
      DataAccessors.define_accessor(self, key)
      to_h[key] = DataAccessors.accessor_for_data(value)
    end

    alias accessible_data to_h
    alias data_accessible to_h
  end
end
