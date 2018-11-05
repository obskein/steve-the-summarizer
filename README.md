# Steve the summarizer

## Introduction

Steve the summarizer takes a url encoded string and returns a JSON dictionary
containing the lede, title, description and any images found.

Currently, Steve uses the `pismo` gem to process the URL downstream.

## Example Usage (Ruby)

```
require 'pp'

page1 = "https://jalopnik.com/the-2018-ford-ecosport-titanium-is-a-good-reminder-that-1829502953"
page2 = "https://imgur.com/gallery/ezoyNAX"
page3 = 'http://www.rubyinside.com/cramp-asychronous-event-driven-ruby-web-app-framework-2928.html'

puts URI.escape(page1)
puts URI.escape(page2)
puts URI.escape(page3)

```

## Example usage (curl)

```
curl localhost:4567/v1/preview.json?url=http%3A%2F%2Fwww.rubyinside.com%2Fcramp-asychronous-event-driven-ruby-web-app-framework-2928.html
```
