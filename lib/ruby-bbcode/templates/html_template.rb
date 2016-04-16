module RubyBBCode::Templates
  # This class is designed to help us build up the HTML data.  It starts out as a template such as...
  #   @opening_part = '<a href="%url%">%between%'
  #   @closing_part = '</a>'
  # and then slowly turns into...
  #   @opening_part = '<a href="http://www.blah.com">cool beans'
  #   @closing_part = '</a>'
  class HtmlTemplate
    attr_accessor :opening_part, :closing_part

    def initialize(node)
      @node = node
      @tag_definition = node.definition # tag_definition
      @opening_part = node.definition[:html_open].dup
      @closing_part = node.definition[:html_close].dup
    end

    # Newlines are converted to html <br /> syntax before being returned.
    def self.convert_text(node)
      return '' if node[:text].nil?
      # add p tags
      binding.pry
      sub_result = node[:text].gsub("\r","").split(/\n\s*\n/)
      result = sub_result.count > 1 ? sub_result.map {|s| "<p>#{s}</p>"}.join("") : node[:text]
      # convert_newlines_to_br
      result = result.gsub("\r\n", "\n").gsub("\n", "<br />\n")
      result
    end

    def inlay_between_text!
      @opening_part.gsub!('%between%',@node[:between]) if between_text_goes_into_html_output_as_param?  # set the between text to where it goes if required to do so...
    end

    def inlay_params!
      # Iterate over known tokens and fill in their values, if provided
      @tag_definition[:param_tokens].each do |token|
        @opening_part.gsub!("%#{token[:token].to_s}%", "#{token[:prefix]}#{@node[:params][token[:token]]}#{token[:postfix]}") unless @node[:params][token[:token]].nil?
      end
    end

    def inlay_closing_part!
      @closing_part.gsub!('%between%',@node[:between]) if @tag_definition[:require_between]
    end

    def remove_unused_tokens!
      @tag_definition[:param_tokens].each do |token|
        @opening_part.gsub!("%#{token[:token]}%", '')
      end
    end

    private

    def between_text_goes_into_html_output_as_param?
      @tag_definition[:require_between]
    end
  end
end
