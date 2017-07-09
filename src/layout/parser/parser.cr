require "./tokenizer"

module Layout
  module Parser
    def self.parse(text : String) : Layout::DOM::Node
      tokenizer = Layout::Parser::Tokenizer.new(text)
      nodes = tokenizer.parse_nodes

      if nodes.size == 1
        nodes.first
      else
        Layout::DOM::ElementNode.new("html", {} of String => String, nodes)
      end
    end
  end
end
