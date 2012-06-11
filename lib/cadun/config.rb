module Cadun
  class Config    
    def self.load_file(path)
      load_hash YAML::load_file(path)['cadun']
    end

    def self.load_hash(hash)
      (class << self; self; end).instance_eval do
        hash.each { |key, value| define_method(key) { value } }
      end
    end
  end
end
