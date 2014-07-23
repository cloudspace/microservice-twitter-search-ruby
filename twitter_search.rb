class TwitterSearch
  attr_accessor :options, :search_terms

  def initialize(query:, **args)
    @search_terms = query
    @options = args
  end

  def urls
    tweet_urls = []
    tweets.each do |tweet|
      tweet.urls.each do |urlz|
        tweet_urls.push(urlz.expanded_url.to_s)
      end
    end
    tweet_urls
  end

  def json_tweets
    now = Time.now.utc
    entities = tweets.map do |tweet|
      next if options[:max_age] && now - tweet.created_at.dup.utc >= options[:max_age].to_i
      {
        id: tweet.id,
        user: tweet.user.screen_name,
        tweet: tweet.text,
        urls: tweet.urls.map {|tw| tw.expanded_url.to_s},
        location: (tweet.place? && tweet.place.full_name) || nil,
        pictures: (tweet.media? && tweet.media.map {|m| m.media_url.to_s}) || nil
      }.to_json
    end

    entities.compact
  end

  def client
    Twitter::REST::Client.new do |config|
      options[:auth].each_pair do |k,v|
        config.send("#{k}=".to_sym, v)
      end
    end
  end

  def tweets
    # returns an iterator rather than the collection itself.
    client.search(search_terms, **options[:search_options]).take((options[:take] && options[:take].to_i) || 100).collect
  end
end