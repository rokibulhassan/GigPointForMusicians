module ApplicationHelper
  ALERT_TYPES = [:error, :info, :success, :warning]

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = :success if type == :notice
      type = :error   if type == :alert
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                               msg, :class => "alert fade in alert-#{type}")
        flash_messages << text if message
      end
    end
    flash_messages.join("\n").html_safe
  end
end

module GmapCoordinatesPicker
  class MapBuilder < Formtastic::FormBuilder

    def gmap_coordinate_picker(options = {})
      options.update :object => @object_name
      render_gmap_coordinate_picker(objectify_options(options))
    end
  end
end

if Object.const_defined?("Formtastic")
  if Formtastic.const_defined?("Helpers")
    Formtastic::Helpers::FormHelper.builder = GmapCoordinatesPicker::MapBuilder
  else
    Formtastic::SemanticFormHelper.builder = GmapCoordinatesPicker::MapBuilder
  end
end