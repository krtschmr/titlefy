require 'singleton'
module Titlefy
  class Config
    include Singleton
    attr_accessor :extra_lookup
  end
end
