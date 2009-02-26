$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'hpricot'
require 'uri'

module EmbedWhitelist
  CONFIG = YAML.load(File.read(File.join(File.dirname(__FILE__), 'embed_whitelist', 'embed_whitelist_config.yml'))).freeze  
  ALLOWED_SITES = CONFIG['allowed_sites']
  VERSION = '0.1.1'
  ALLOWED_TAGS = CONFIG['allowed_tags']
  
  # def self.included(base) # :nodoc:
  #   base.extend ClassMethods
  # end

  # module ClassMethods  
      
    def domain_allowed?(domain)
      ALLOWED_SITES.include?(domain)
    end
    
    def attr_allowed?(tag, attr_in_question)
      CONFIG["#{tag.to_s.downcase}_attrs"].include?(attr_in_question.to_s.downcase)
    end

    def tag_allowed?(tag)
      ALLOWED_TAGS.include?(tag.to_s.downcase)
    end
    
    def parse_embed(embed_object, override_attrs={})
      open_embed(embed_object)
      check_embed_for_valid_tags
      check_embed_for_valid_attrs(override_attrs)
      return @doc.to_html
    end
    
    protected
    
    def open_embed(embed_object)
      @doc = Hpricot(embed_object, :fixup_tags => true)
    end

    def check_embed_for_valid_tags
      @doc.search('*').each do |child|
        @doc.search(child.xpath).remove unless child.class == Hpricot::Text || tag_allowed?(child.name) 
      end
      @doc
    end
    
    def check_embed_for_valid_attrs(override_attrs={})
      @doc.search('*').each do |child|
        if child.is_a?(Hpricot::Elem)
          child.attributes.each_key do |key|
            child.remove_attribute unless attr_allowed?(child.name, key)
            child.set_attribute(key,override_attrs[key.downcase]) if override_attrs[key.downcase]
          end # end each key
          check_source_file_attr(child)
        end # end if elem
      end # end each child
      @doc
    end
    
    def check_src_domain(src_url)
      uri = URI.parse(src_url.to_s)
      raise DomainError unless domain_allowed?(uri.host)
      return true
    end
    
    def check_source_file_attr(child_elem)
      source_url = case child_elem.name.to_s.downcase
        when "embed" then
          child_elem.get_attribute("src")
        when "param" then
          child_elem.get_attribute("value") if child_elem.get_attribute("name") == "movie" 
        else
          nil
      end
      check_src_domain(source_url) if source_url 
    end
    
  # end

  class DomainError < StandardError
  end
end

