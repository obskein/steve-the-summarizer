
require 'uri'
require 'yaml'

class Blacklist
  def initialize
    @blacklist = YAML.load('blacklist.yaml')
    @urls = @blacklist[:urls]
    @domains = @blacklist[:domains]
  end

  # 
  # A URL is blacklisted if: 
  # 
  # 1. Url is an exact match against a member of the urls array
  # 2. The host of a URL is a *partial match* of *any part* of the url.
  # 
  # For example, adding "example.org" to the domains would block *ALL* of the 
  # following URLs:
  # 
  # a) http://foo.com/search?q=example.org
  # b) http://example.org.foo.com/anything
  # 
  def permitted?(url)
    uri = URI.parse(url)
    return false if urls.contain?(url)
    domains.each do |domain|
      if domain =~ /#{uri.host}/
        return false
      end
    end
    true
  end
end
