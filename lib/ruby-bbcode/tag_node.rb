module RubyBBCode
  # A TagNode specifies either an opening tag element or a (plain) text elements
  #
  # TagInfo elements are essentially converted into these nodes which are
  # later converted into html output in the bbtree_to_html method
  class TagNode
    # Tag or text element that is stored in this node
    attr_accessor :element

    # ==== Attributes
    #
    # * +element+ - contains the information of TagInfo#tag_data.
    #   A text element has the form of
    #       { :is_tag=>false, :text=>"ITALIC" }
    #   and a tag element has the form of
    #       { :is_tag=>true, :tag=>:i, :nodes => [] }
    # * +nodes+
    def initialize(element, nodes = [])
      @element = element
    end

    def [](key)
      @element[key]
    end

    def []=(key, value)
      @element[key] = value
    end

    # Debugging/ visualization purposes
    def type
      @element[:is_tag] ? :tag : :text
    end

    def allow_params?
      allow_quick_param? or definition[:param_tokens]
    end

    # Checks to see if the tag parameter for the TagNode has been set.
    def quick_param_not_set?
      (@element[:params].nil? or @element[:params][:quick_param].nil?)
    end

    # check if the tag parameter for the TagNode is set
    def quick_param_set?
      !quick_param_not_set?
    end

    # Checks to see if the TagNode has (regular) parameter(s) set.
    def params_set?
      !@element[:params].nil? and @element[:params].length > (quick_param_set? ? 1 : 0)
    end

    def has_children?
      return false if type == :text or children.length == 0  # text nodes return false too
      return true if children.length > 0
    end

    def allow_quick_param?
      definition[:allow_quick_param]
    end

    # shows the tag definition for this TagNode as defined in tags.rb
    def definition
      @element[:definition]
    end

    def children
      @element[:nodes]
    end

    # Easy way to set the quick_param value of the hash, which represents
    # the parameter supplied
    def quick_param=(param)
      @element[:params][:quick_param] = param
    end

  end
end