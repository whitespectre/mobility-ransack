# frozen_string_literal: true

require 'ransack'
require 'mobility'

module Mobility
  module Plugins
    module Ransack
      # Applies ransack plugin.
      # @param [Attributes] attributes
      # @param [Boolean] option
      def self.apply(attributes, option)
        if option
          backend_class, model_class = attributes.backend_class, attributes.model_class
          attributes.each do |attr|
            model_class.ransacker(attr) { backend_class.build_node(attr, Mobility.locale) }
          end
        end
      end
    end
  end
end
