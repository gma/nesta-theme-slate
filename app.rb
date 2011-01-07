module Nesta
  class App
    use Rack::Static, :urls => ['/slate'], :root => 'themes/slate/public'
  end
end
