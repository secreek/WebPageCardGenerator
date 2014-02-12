# This is a patcher that allows you fetch imgs using relative image
# https://github.com/cantino/ruby-readability/pull/55

module Readability
  class Document

    def images_with_fqdn_uris!(source_uri)
      images_with_fqdn_uris(@html, source_uri)
    end
    
    def images_with_fqdn_uris(document = @html.dup, source_uri)
      uri = URI.parse(source_uri)
      host = uri.host
      scheme = uri.scheme
      port = uri.port # defaults to 80

      base = "#{scheme}://#{host}:#{port}/"

      images = []
      document.css("img").each do |elem|
        begin
          elem['src'] = URI.join(base,elem['src']).to_s if URI.parse(elem['src']).host == nil 
          images << elem['src'].to_s
        rescue URI::InvalidURIError => exc
          elem.remove
        end
      end

      images(document,true)
    end

  end
end