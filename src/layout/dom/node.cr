module Layout
  module DOM
    class Node
      @kind : String
      @children : Array(Node)
      @attributes : Hash(String, String)

      getter :kind, :children, :attributes

      def initialize(@kind)
        @attributes = {} of String => String
        @children = [] of Node
      end

      def initialize(@kind, @attributes, @children = [] of Node)
      end

      def to_html : String
        attrs = attributes.map do |key, value|
          "#{key}='#{value}'"
        end

        children_html = children.map(&.to_html.as(String)).join("")
        "<#{kind} #{attrs.join(' ')}>#{children_html}</#{kind}>"
      end
    end
  end
end
