module Cadun
  class Config    
    def self.load_file(path)
      (class << self; self; end).instance_eval do
        YAML::load_file(path)['cadun'].each { |key, value| define_method(key) { value } }
      end
    end
  end
end