require 'test_helper'

class RubyBbcodeHtmlTest < Minitest::Test

  def test_link_multi_line
    assert_equal '', "AAA [url]http://www.google.com[/url] Bbbb\r\n\r\nCCCC".bbcode_to_html
  end

end
