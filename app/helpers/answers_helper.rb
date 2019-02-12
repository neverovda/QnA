module AnswersHelper

  def urls(files)
    files.map do |file|
      { name: file.filename.to_s, url: url_for(file) }
    end
  end

  def links(links)
    links.map do |link|
      { name: link.name, 
        url: link.url,
        gist_content: link.gist? ? link.gist_content : '' }
    end
  end

end
