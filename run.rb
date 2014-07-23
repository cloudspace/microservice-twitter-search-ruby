require 'twitter'
require 'optparse'
require 'json'

require 'pry-byebug'

require_relative './twitter_search.rb'

# deep symbolize keys recursively in a hash without modifying non-hash objects
def symbolize(obj)
  return obj.reduce({}) do |memo, (k, v)|
    memo.tap { |m| m[k.to_sym] = symbolize(v) }
  end if obj.is_a? Hash
    
  return obj.reduce([]) do |memo, v| 
    memo << symbolize(v); memo
  end if obj.is_a? Array
  
  obj
end

# detect whether JSON or command line flags were used
begin
  # ruby run.rb "{\"auth\":{\"consumer_key\":\"xxxx\",\"consumer_secret\":\"xxxx\",\"access_token\":\"xxxx\",\"access_token_secret\":\"xxxx\"},\"max_age\":\"300\",\"search_options\":{\"result_type\":\"recent\",\"since\":\"2014-07-14\"},\"query\":\"coreos OR docker lang:en -apparel -pant -haileadocker -Joe_Docker -Hailea_Docker\"}"
  json = JSON.parse(ARGV[0])
rescue
  # ruby run.rb --query="coreos OR docker lang:en -apparel -pant -haileadocker -Joe_Docker -Hailea_Docker" --consumer_key=xxxx --consumer_secret=xxxx --access_token=xxxx --access_token_secret=xxxx --result_type=recent --since=2014-07-14
  json = nil
end

# if json is used, deep symbolize keys. if not, parse command-line flags
if json
  options = symbolize(json)
else
  options = {}
  options[:auth] = {}
  options[:search_options] = {}

  parser = OptionParser.new do |opts|
    opts.banner = "Usage: run.rb [options]"

    opts_on("-i n", "--max_age=n", "The maximum age (in seconds) of tweets to return") do |val|
      options[:max_age] = val
    end

    opts_on("-T n", "--take=n", "The number of tweets to fetch") do |val|
      options[:take] = val
    end

    opts.on("-q n", "--query=n", "Query to run") do |val|
      options[:query] = val
    end

    opts.on("-k n", "--consumer_key=n", "Twitter consumer key") do |val|
      options[:auth][:consumer_key] = val
    end

    opts.on("-s n", "--consumer_secret=n", "Twitter consumer secret") do |val|
      options[:auth][:consumer_secret] = val
    end

    opts.on("-t n", "--access_token=n", "Twitter access token") do |val|
      options[:auth][:access_token] = val
    end

    opts.on("-S n", "--access_token_secret=n", "Twitter access token secret") do |val|
      options[:auth][:access_token_secret] = val
    end

    # search options taken from: http://rdoc.info/gems/twitter/Twitter/REST/Search
    # options specified in options[:search_options] are directly applied to the seach API endpoint as key/value pairs, unmodified

    opts.on("-g n", "--geocode=n", "Geocode constraint in the form 'latitude,longitude,radius', where radius units must be specified as either 'mi' (miles) or 'km' (kilometers)") do |val|
      options[:search_options][:geocode] = val
    end

    opts.on("-l n", "--language=n", "Restricts tweets to the given language, given by an ISO 639-1 code") do |val|
      options[:search_options][:lang] = val
    end

    opts.on("-L n", "--locale=n", "Specify the language of the query you are sending (only ja is currently effective)") do |val|
      options[:search_options][:locale] = val
    end

    opts.on("-t n", "--result_type=n", "Specifies what type of search results you would prefer to receive. Options are 'mixed', 'recent', and 'popular'. The current default is 'mixed.'") do |val|
      options[:search_options][:result_type] = val
    end

    opts.on("-n n", "--count=n", "The number of tweets to return per page, up to a maximum of 100") do |val|
      options[:search_options][:count] = val.to_i
    end

    opts.on("-u n", "--until=n", "Returns tweets generated before the given date. Date should be formatted as 'YYYY-MM-DD'") do |val|
      options[:search_options][:until] = val
    end

    opts.on("-A n", "--since_id=n", "Returns results with an ID greater than (that is, more recent than) the specified ID. There are limits to the number of Tweets which can be accessed through the API. If the limit of Tweets has occured since the since_id, the since_id will be forced to the oldest ID available.") do |val|
      options[:search_options][:since_id] = val.to_i
    end

    opts.on("-a n", "--since=n", "Returns tweets generated after the given date. Date should be formatted as 'YYYY-MM-DD'.") do |val|
      options[:search_options][:since] = val
    end

    opts.on("-m n", "--until=n", "Returns results with an ID less than (that is, older than) or equal to the specified ID") do |val|
      options[:search_options][:max_id] = val.to_i
    end
  end

  parser.parse!

  fail OptionParser::MissingArgument, "--query" unless options[:query]
  fail OptionParser::MissingArgument, "--consumer_key" unless options[:auth][:consumer_key]
  fail OptionParser::MissingArgument, "--consumer_secret" unless options[:auth][:consumer_secret]
  fail OptionParser::MissingArgument, "--access_token" unless options[:auth][:access_token]
  fail OptionParser::MissingArgument, "--access_token_secret" unless options[:auth][:access_token_secret]
end

# puts "OPTIONS: " + options.to_json.inspect
search = TwitterSearch.new(**options)

puts '"'+search.json_tweets.to_json+'"'