require File.dirname(__FILE__) + '/test_helper.rb'

class TestEmbedWhitelist < Test::Unit::TestCase
  include EmbedWhitelist
  
  def setup
    @youtube_string = %(<object width="425" height="344"><param name="movie" value="http://www.youtube.com/v/W3f6BOrD9Ek&hl=en&fs=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/W3f6BOrD9Ek&hl=en&fs=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="344"></embed></object>)
    @valid_youtube_doc = Hpricot(@youtube_string, :fixup_tags => true)
  end
  
  def test_domain_allowed
    assert domain_allowed?("youtube.com"), "Youtube should be in the allowed list"
    assert !domain_allowed?("evilsite.com"), "Evilsite should be in the allowed list"    
  end
  
  def test_attr_allowed
    assert attr_allowed?("embed", "type"), "Embed should allow the type attr"
    assert !attr_allowed?("embed", "onclick"), "Embed should not allow the onclick attr"    
  end

  def test_attr_allowed_and_capitialized_attrs
    assert attr_allowed?("embed", "TYPE"), "Embed should allow the type attr"
    assert !attr_allowed?("embed", "onClick"), "Embed should not allow the onclick attr"    
  end
  
  def test_open_embed
    assert open_embed(@youtube_string).is_a?(Hpricot), "I am not an hpricot"
  end
  
  def test_check_embed_for_valid_tags
    open_embed(@youtube_string)
    assert_equal check_embed_for_valid_tags.to_html, @valid_youtube_doc.to_html
  end

  def test_check_embed_for_valid_tags_with_invalid_a
    open_embed(@youtube_string + "<a href='javscript:alert(blah)'>Click ME</a>")
    assert_equal check_embed_for_valid_tags.to_html, @valid_youtube_doc.to_html
  end

  def test_check_embed_for_valid_attrs
    open_embed(@youtube_string)
    assert_equal check_embed_for_valid_attrs.to_html, @valid_youtube_doc.to_html    
  end

  def test_check_embed_for_valid_attrs_with_invalid_onclick
    open_embed(@youtube_string)
    assert_equal check_embed_for_valid_attrs.to_html, @valid_youtube_doc.to_html 
  end

  def test_check_embed_for_valid_attrs_with_override
    open_embed(@youtube_string)
    assert_equal check_embed_for_valid_attrs({"width" => "200"}).to_html, @valid_youtube_doc.to_html.gsub(/425/, '200')
  end

  def test_check_src_domain
    assert check_src_domain("http://www.youtube.com/v/W3f6BOrD9Ek&hl=en&fs=1")
  end

  def test_check_src_domain
    assert_raise(EmbedWhitelist::DomainError) { check_src_domain("http://www.evilyoutube.com/v/W3f6BOrD9Ek&hl=en&fs=1") }
  end

  def test_check_embed_for_valid_attrs_with_evil_url
    open_embed(@youtube_string.gsub(/youtube/, "evilwebsite"))
    assert_raise(EmbedWhitelist::DomainError) { check_embed_for_valid_attrs.to_html}  
  end

  def test_parse_embed
    embed_string = parse_embed(@youtube_string)
    assert_equal embed_string, @valid_youtube_doc.to_html 
  end

  def test_parse_embed_with_bad_tags
    embed_string = parse_embed(@youtube_string + "<a href='javscript:alert(blah)'>Click ME</a>")
    assert_equal embed_string, @valid_youtube_doc.to_html 
  end
  
end
