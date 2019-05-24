require "titlefy/version"
require 'titlefy/config'
require 'active_support/concern'

module Titlefy
  extend ActiveSupport::Concern

  def titlefy(*args)
    send :include, InstanceMethods
  end

  def self.config
    @@config ||= Titlefy::Config.instance
    @@config.extra_lookup ||= nil
    @@config
  end


  included do

    def titlefy_lookup(val)
      @titlefy_prefix ||= val
    end

    def render(*args)
      begin
        set_title_tag unless @page_title
      end
      super
    end

    def set_title_tag
      lookup = "title_tags"
      lookup << ".#{@titlefy_prefix}" if @titlefy_prefix

      paths = [
        "#{lookup}.#{namespace}.#{controller_name}.#{action_name}.#{Titlefy.config.extra_lookup}",
        "#{lookup}.#{namespace}.#{controller_name}.#{action_name}",
        "#{lookup}.#{controller_name}.#{action_name}.#{Titlefy.config.extra_lookup}",
        "#{lookup}.#{controller_name}.#{action_name}"
      ]
      title = nil
      paths.each do |path|
        p "Titlefy Lookup: #{path}" if Rails.env.development?
        title = I18n.t(path ,default: "")
        break if title.present?
      end

      if title.empty? and route_name != ""
        title = I18n.t route_name,  scope: [:title_tags, :routes], default: ""
      elsif title == ""
        title = default_title
      end

      title = title.to_s

      title.scan(/\{\{.*?\}\}/).each do |replace|
        #{{@game.name}} => @game.name
        variable = replace.gsub(/\{|\}/, "")

        # catch resource_controller or similar
        # variable named resource is an AR object
        # rename to @tempresource so we can handle it
        if variable.starts_with? "resource"
          @tempresource = resource
          variable.gsub!("resource", "@tempresource")
        end

        # make "@variable.name" or "@variable" accessable without eval (!)
        # and replace the {{placeholder}} with @variables value
        if variable.starts_with?("@")
          content = variable.split('.').inject(nil){|clazz, method| clazz.nil? ? instance_variable_get(method) : clazz.send(method)}
          title.gsub! replace, content
        end
      end
      set_title( title )
    end

    def set_title(title)
      @page_title = title unless title.empty?
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
