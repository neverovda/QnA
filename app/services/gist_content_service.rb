class GistContentService

  def initialize(gist, client: default_client)
    @gist = gist
    @client = client
  end

  def content
    begin
      result = @client.gist(@gist)
      result.files.first[1].content if result.html_url.present?      
    rescue StandardError
      nil
    end      
  end

  private

  def default_client
    Octokit::Client.new
  end

end  
