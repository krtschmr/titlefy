require "titlefy/version"
require 'active_support/concern'


module Titlefy
  extend ActiveSupport::Concern

  def titlefy
    send :include, InstanceMethods
  end

  included do

    def render(*args)
      set_title_tag unless @title
      super
    end

    def set_title_tag
      title = I18n.t "title_tags.#{namespace}.#{controller_name}.#{action_name}", default: ""
      title = I18n.t "title_tags.#{controller_name}.#{action_name}", default: ""                if title == ""
      title = I18n.t route_name,  scope: :title_tags, default: ""                               if title == ""
      title = default_title if title == ""

      set_title(title)
    end

    def set_title(title)
      @title = title
    end

    def namespace
      self.class.parent.to_s.downcase
    end

    def default_title
      I18n.t :default, scope: :title_tags, default: Rails.application.class.parent_name.humanize
    end

    def route_name
      Rails.application.routes.router.recognize(request) do |route, _|
        return route.name.to_s.split("_")[0..1].join("_")
      end
    end

  end

end

ActionController::Base.include Titlefy
