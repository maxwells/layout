require "../spec_helper"

describe Layout::DOM::ElementNode do
  describe "#to_html" do
    it "generates an html representation of DOM tree including this node" do
      node = Layout::DOM::ElementNode.new("div", {"class" => "class-name", "id" => "my-id"}, [
        Layout::DOM::TextNode.new("Words"),
        Layout::DOM::ElementNode.new("input", {"type" => "text", "placeholder" => "...", "name" => "text-input"}),
      ])

      node.to_html.should eq("<div class='class-name' id='my-id'>Words<input type='text' placeholder='...' name='text-input'></input></div>")
    end
  end
end
