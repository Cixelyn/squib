require 'cairo'
require_relative 'arg_loader'
require_relative 'color_validator'

module Squib
  # @api private
  module Args

    class Draw2
      include ColorValidator

      def initialize(deck)
        @deck = deck
      end

      def self.parameters
        { color: :black,
          fill_color: '#0000',
          stroke_color: :black,
          stroke_width: 2.0,
          stroke_strategy: :fill_first,
          join: :miter,
          cap: 'butt',
          dash: ''
        }
      end

      def self.expanding?
        true
      end

      def self.params_with_units
        [:stroke_width]
      end

      # THIS IS WHAT I REALLY WANT!!
      # ...instead of validate_join
      def join=(arg)
        @join = case arg.to_s.strip.downcase
                when 'miter'
                  Cairo::LINE_JOIN_MITER
                when 'round'
                  Cairo::LINE_JOIN_ROUND
                when 'bevel'
                  Cairo::LINE_JOIN_BEVEL
                end
      end

      def cap=(arg)
        @cap = case arg.to_s.strip.downcase
                when 'butt'
                  Cairo::LINE_CAP_BUTT
                when 'round'
                  Cairo::LINE_CAP_ROUND
                when 'square'
                  Cairo::LINE_CAP_SQUARE
                end
      end

      def dash=
        arg.to_s.split.collect do |x|
          UnitConversion.parse(x, @dpi).to_f
        end
      end

      def validate_fill_color(arg, _i)
        colorify(arg, @deck.custom_colors)
      end

      def validate_stroke_color(arg, _i)
        colorify(arg, @deck.custom_colors)
      end

      def color=(arg)
        @color = colorify(arg, @deck.custom_colors)
      end

      def validate_stroke_strategy(arg, _i)
        case arg.to_s.downcase.strip
        when 'fill_first'
          :fill_first
        when 'stroke_first'
          :stroke_first
        else
          raise "Only 'stroke_first' or 'fill_first' allowed"
        end
      end

    end

  end
end