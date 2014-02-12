# define some helper methods
helpers do

  def para text
    "<p>%s</p>" % text
  end

  def link_to text, href 
    "<a href=%s>%s</a>" % [href, text]
  end

  def img href, proper=""
    "<img src=\"%s\" %s>" % [href, proper]
  end

  def keyword_tag keyword
    "<li class=\"tag-part\">%s</li>" % keyword
  end

  def background_img texture
    "url(img/%s)" % texture
  end

end
