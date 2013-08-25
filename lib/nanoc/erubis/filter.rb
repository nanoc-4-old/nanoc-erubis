# encoding: utf-8

requires 'erubis'

module Nanoc::Erubis

  class Filter < Nanoc::Filter

    # The same as `::Erubis::Eruby` but adds `_erbout` as an alias for the
    # `_buf` variable, making it compatible with nanoc’s helpers that rely
    # on `_erbout`, such as {Nanoc::Helpers::Capturing}.
    #
    # TODO move this to nanoc/erubis/erubis_with_erbout.rb
    class ErubisWithErbout < ::Erubis::Eruby
      include ::Erubis::ErboutEnhancer
    end

    identifier :erubis

    def run(content, params={})
      # Create context
      context = ::Nanoc::Context.new(assigns)

      # Get binding
      proc = assigns[:content] ? lambda { assigns[:content] } : nil
      assigns_binding = context.get_binding(&proc)

      # Get result
      ErubisWithErbout.new(content, :filename => filename).result(assigns_binding)
    end

  end

end
