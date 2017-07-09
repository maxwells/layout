module Layout
  module Parser
    class Tokenizer
      enum Token
        DOCTYPE
        START_TAG
        END_TAG
        COMMENT
        CHARACTER
        EOF
      end

      def initialize(text : String)
        @text = text
        @position = 0
      end

      def peek
        @text[@position]
      end

      def starts_with?(sequence)
        @text[@position..(@position + sequence.bytesize - 1)] == sequence
      end

      def eof?
        @position >= @text.bytesize
      end

      def next_char
        output = @text[@position]
        @position += 1
        output
      end

      def next_while(&blk)
        result = ""

        while !eof? && yield peek
          result += next_char
        end

        result
      end

      def skip_whitespace
        next_while do |char|
          char.ascii_whitespace?
        end
      end

      def parse_bare_word
        next_while do |char|
          char.alphanumeric?
        end
      end

      def is_closing_tag?
        starts_with?("</")
      end

      def parse_node : Layout::DOM::Node
        case peek
        when '<'
          parse_element
        else
          parse_text
        end
      end

      def parse_text : Layout::DOM::Node
        contents = next_while { |c| c != '<' }
        Layout::DOM::TextNode.new(contents)
      end

      def parse_element : Layout::DOM::Node
        assert!(next_char == '<')
        tag_name = parse_bare_word
        attrs = parse_attributes
        assert!(next_char == '>')

        children = parse_nodes

        assert!(next_char == '<')
        assert!(next_char == '/')
        assert!(parse_bare_word == tag_name)
        assert!(next_char == '>')

        Layout::DOM::ElementNode.new(tag_name, attrs, children)
      end

      def parse_attr : Array(String)
        key = parse_bare_word
        skip_whitespace
        assert!(next_char == '=')
        skip_whitespace
        value = parse_bare_or_quoted_value
        [key, value]
      end

      def parse_bare_value
        next_while do |char|
          char != '\'' && char != '"'
        end
      end

      def parse_bare_or_quoted_value : String
        possible_quote = peek
        if possible_quote == '\'' || possible_quote == '"'
          next_char
          value = parse_bare_value
          assert!(next_char == possible_quote)
          value
        else
          parse_bare_word
        end
      end

      def parse_attributes : Hash(String, String)
        attrs = {} of String => String

        loop do
          skip_whitespace
          break if peek == '>'
          key, value = parse_attr
          attrs[key] = value
        end

        attrs
      end

      def assert!(truth : Bool)
        if !truth
          # exit(1)
        end
      end

      def parse_nodes : Array(Layout::DOM::Node)
        nodes = [] of Layout::DOM::Node

        loop do
          skip_whitespace
          if eof? || is_closing_tag?
            break
          end
          nodes.push(parse_node)
        end

        nodes
      end
    end
  end
end
