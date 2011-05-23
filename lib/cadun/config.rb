module Cadun
  class Config
    include Singleton
    
    attr_accessor :config
    
    def initialize
      @config = {}
    end
    
    def self.load_file(path)
      instance.config = YAML::load_file(path)
    end
    
    def self.method_missing(method, *args)
      instance.config['cadun'][method.to_s]
    end
  end
end