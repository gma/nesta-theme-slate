module Nesta
  class App
    use Rack::Static, :urls => ['/slate'], :root => 'themes/slate/public'

    get '/css/:sheet.css' do
      content_type 'text/css', :charset => 'utf-8'
      cache sass(params[:sheet].to_sym)
    end

    get '/' do
      set_common_variables
      set_from_config(:title, :subtitle, :description, :keywords)
      @heading = @title
      @title = "#{@title} - #{@subtitle}"
      @articles = Page.find_articles[0..7]
      @body_class = 'home'
      cache haml(:index)
    end

    get '*' do
      set_common_variables
      parts = params[:splat].map { |p| p.sub(/\/$/, '') }
      @page = Nesta::Page.find_by_path(File.join(parts))
      raise Sinatra::NotFound if @page.nil?
      set_title(@page)
      set_from_page(:description, :keywords)
      cache haml(@page.template, :layout => @page.layout)
    end
  end
end
