require 'active_support'
require 'pismo'
require_relative 'blacklist'

class PagePreview

  attr_accessor :page, :cache

  def initialize(page)
    @page = page
    UrlLogEntry.new(page)
    cache_lifetime = 3600
    # @cache ||= ActiveSupport::Cache::MemCacheStore.new
    @cache = ActiveSupport::Cache.lookup_store(:file_store, '/tmp/steve-cache', expires_in: cache_lifetime)
    @errors = []
  end

  def to_hash

    preview = cache.fetch(page)
    return preview if preview

    doc = Pismo::Document.new(page, url: page, image_extractor: true)

    images = doc.images || []

    # Pismo doesn't always get og:image tags; add them if we find them
    og_image = doc.doc.css("meta[property~='og:image']")
    og_image_content = og_image.any? ? og_image.attr("content") : nil
    images.push(og_image_content.to_s) if og_image_content

    preview = { 
      title: doc.title.to_s,
      lede: doc.lede.to_s,
      description: doc.description.to_s,
      images: images
    }

    cache.write(page, preview)
    preview
  end

  def to_json
    JSON.dump(to_hash)
  end

  def to_html
    preview = to_hash
    <<~EOF
    <html>
      <body>
        <form action="/v1/preview.html">
          URL:
          <input type="text" name="url" value="#{page}"/>
          <input type="submit" value="Go"/>
        </form>
        <dl>
          <dt>title</dt>
          <dd>#{preview[:title]}</dd>
          <dt>description</dt>
          <dd>#{preview[:description]}</dd>
          <dt>lede</dt>
          <dd>#{preview[:lede]}</dd>
        </dl>
        <div class='images'>
          #{ preview[:images].map { |i| "<img src='#{i}'/>" }.join }
        </div>
      </body>
    </html>
    EOF
  end

  def valid?
    if page.nil? or page.strip == ""
      @errors << "Must supply a url parameter"
    end

    unless @page =~ /^http:\/\// or @page =~ /^https:\/\//
      @errors << "Only urls with an http or https protocol are supported"
    end

=begin
    blacklist = Blacklist.new
    unless blacklist.permitted?(@page)
      @errors << "This url is not permitted"
    end
=end

    @errors.empty?
  end

  def error_message
    @errors.join(", ")
  end
end

