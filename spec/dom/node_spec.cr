require "../spec_helper"

describe Layout::DOM::Node do
  describe "#to_html" do
    it "generates an html representation of DOM tree including this node" do
      node = Layout::DOM::Node.new("div", {"class" => "class-name", "id" => "my-id"}, [
        Layout::DOM::Node.new("input", {"type" => "text", "placeholder" => "...", "name" => "text-input"}),
      ])

      node.to_html.should eq("<div class='class-name' id='my-id'><input type='text' placeholder='...' name='text-input'></input></div>")
    end
  end
end
