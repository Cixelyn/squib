module Squib
  class Card

    # :nodoc:
    # @api private 
    def png(file, x, y, alpha)
      cc = cairo_context
      png = Cairo::ImageSurface.from_png(file)
      cc.set_source(png, x, y)
      cc.paint(alpha)
    end

    # :nodoc:
    # @api private 
    def svg(file, id, x, y, width, height)
      svg = RSVG::Handle.new_from_file(file)
      width = svg.width if width == :native
      height = svg.height if height == :native
      tmp = Cairo::ImageSurface.new(width, height)
      tmp_cc = Cairo::Context.new(tmp)
      tmp_cc.scale(width.to_f / svg.width.to_f, height.to_f / svg.height.to_f)
      tmp_cc.render_rsvg_handle(svg, id)
      cairo_context.set_source(tmp, x, y)
      cairo_context.paint
    end

  end
end
