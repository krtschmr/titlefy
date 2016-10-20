require "titlefy/version"
require 'active_support/concern'

module Titlefy
  extend ActiveSupport::Concern

  def titlefy(*args)
    send :include, InstanceMethods
  end


  included do

    def titlefy_lookup(val)
      @titlefy_prefix ||= val
    end

    def render(*args)
      set_title_tag unless @page_title
      super
    end

    def set_title_tag
      lookup = "title_tags"
      lookup << ".#{@titlefy_prefix}" if @titlefy_prefix

      p "#{lookup}.#{namespace}.#{controller_name}.#{action_name}" if @debug
      p "#{lookup}.#{controller_name}.#{action_name}" if @debug

      title = I18n.t "#{lookup}.#{namespace}.#{controller_name}.#{action_name}", default: ""
      title = I18n.t "#{lookup}.#{controller_name}.#{action_name}", default: ""                if title.empty?
      title = I18n.t route_name,  scope: [:title_tags, :routes], default: ""                    if title.empty? and route_name != ""
      title = default_title if title == ""

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
