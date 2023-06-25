require 'sinatra'
require 'securerandom'

URLs = {}

get '/' do
  erb :index
end

post '/shorten' do
  long_url = params[:url]
  short_url = generate_short_url

  URLs[short_url] = long_url
  erb :shortened, locals: { short_url: short_url }
end

get '/:short_url' do
  long_url = URLs[params[:short_url]]

  if long_url
    redirect long_url
  else
    status 404
    erb :not_found
  end
end

def generate_short_url
  loop do
    short_url = SecureRandom.hex(3)
    break short_url unless URLs.key?(short_url)
  end
end

# View templates
__END__

@@ index
<html>
  <head>
    <title>URL Shortener</title>
  </head>
  <body>
    <h1>URL Shortener</h1>

<form action="/shorten" method="post">
  <input type="text" name="url" placeholder="Enter URL" required>
  <button type="submit">Shorten</button>
</form>
</body>
</html>

@@ shortened
<p>Your shortened URL is: <a href="/<%= short_url %>"><%= request.base_url %>/<%= short_url %></a></p>

@@ not_found
<h1>404 - Not Found</h1>
<p>The requested URL does not exist.</p>
