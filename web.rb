require 'sinatra'
require 'httparty'

get '/' do
  hackernews = HTTParty.get("https://news.ycombinator.com/").to_s

  # Add a bit of js to hide comments
  hackernews.sub!(/<\/body>/, "#{<<-HIDE_COMMENTS}</body>")
              <script>
                var elements = document.querySelectorAll('.votearrow');
                Array.prototype.forEach.call(elements, function(el, i){ el.style.display = 'none'; });

                elements = document.querySelectorAll('.subtext');
                Array.prototype.forEach.call(elements, function(el, i){ el.style.display = 'none'; });
              </script>
                  HIDE_COMMENTS

  # reference hn css and images
  hackernews.sub!(/href="news\.css\?/, "href=\"https://news.ycombinator.com/news.css?")
  hackernews.sub!(/"y18\.gif"/, "\"https://news.ycombinator.com/y18.gif\"")
  hackernews.gsub!(/"s\.gif"/, "\"https://news.ycombinator.com/s.gif\"")

  hackernews
end

# Other sources of lost time
get  %r{/(newslogin|news2|newest)} do
  "nooooooope"
end

# redirect everything else to the real site
get '/:keyword' do
    redirect to("https://news.ycombinator.com/#{params[:keyword]}")
end
