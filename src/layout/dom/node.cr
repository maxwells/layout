module Layout
  module DOM
    abstract class Node
      @kind : String
      @children : Array(Node)

      getter :kind, :children

      def initialize(@kind : String, @children : Array(Node))
      end
    end

    class TextNode < Node
      getter :data

      def initialize(@data : String)
        @kind = "text"
        @children = [] of Node
      end

      def to_html : String
        data
      end
    end

    class ElementNode < Node
      @attributes : Hash(String, String)

      getter :attributes

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
