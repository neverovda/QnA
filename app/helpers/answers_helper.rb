module AnswersHelper

  def urls(files)
    files.map do |file|
      { name: file.filename.to_s, url: url_for(file) }
    end
  end

end
