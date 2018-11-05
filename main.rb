require 'bundler'
require 'sinatra'
require_relative 'page_preview'

class UrlLogEntry
  def initialize(page)
    # TODO :: Log the page
  end
end

def json_error(status, msg)
  { error: msg, status: status }.to_json
end

get "/v1/preview.json" do
  @page_preview = PagePreview.new(params[:url])
  if @page_preview.valid?
    @page_preview.to_json
  else
    status 400
    json_error(400, "Bad request. #{@page_preview.error_message}")
  end
end

get "/v1/preview.html" do
  PagePreview.new(params[:url]).to_html
end

not_found do
  json_error(404, 'Page not found')
end

error do
  json_error(500, 'Server encountered an error')
end

