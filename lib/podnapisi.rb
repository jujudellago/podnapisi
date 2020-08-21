require "faraday"
require "nokogiri"

require "podnapisi/version"
require "podnapisi/error"
require "podnapisi/response"
require "podnapisi/response/raise_error"
require "podnapisi/response/html"
require "podnapisi/subtitle_result_set"
require "podnapisi/subtitle"

module Podnapisi

  # Podnapisi.net is a very complete and reliable catalog of subtitles.
  # If you're reading this you probably know they don't have an API.
  #
  # This gem will help you communicate with Podnapisi.net easily.
  #
  # == Searches
  #
  # Podnapisi.net handles two kinds of searches:
  #
  #   a) Search by Film or TV Show 'title'
  #   e.g. "The Big Bang Theory", "The Hobbit", etc.
  #
  #   b) Search for a particular 'release'
  #   e.g. "The Big Bang Theory s01e01" or "The Hobbit HDTV"
  #
  # There are certain keywords that trigger one search or the other,
  # this gem initially will support the second type (by release)
  # so make sure to format your queries properly.
  #
  extend self

  ENDPOINT     = "https://www.podnapisi.net"
  

  SEARCH_PATH = "subtitles/search/old"

  # Public: Search for a particular release.
  #
  # query - The String to be found.
  #
  # Examples
  #
  #   Podnapisi.search('The Big Bang Theory s01e01')
  #   # => [#<Podnapisi::SubtitleResult:0x007feb7c9473b0
  #     @attributes={:id=>"136037", :name=>"The.Big.Bang.Theory.."]
  #
  # Returns the Subtitles found.
  def self.search(params={})
    qparams = { sXML: 1 } 
    if params[:languages]
      qparams["sL"] = params[:languages]
    end
    if params[:imdbid]
      qparams["sI"] = params[:imdbid]
    end
    if params[:year]
      qparams["sY"] = params[:year]
    end
    if params[:release]
      qparams["sR"] = params[:release]
    end
    if params[:season_number]
      qparams["sTS"] = params[:season_number]
    end
    if params[:query]
      qparams["sK"] = params[:query]
    end
    if params[:episode_number]
      qparams["sTE"] = params[:episode_number]
    end
    if params[:page]
      qparams["page"] = params[:page]
    end
    if params[:exact_hash_match]
      qparams["sEH"] = params[:exact_hash_match]
    end
    if params[:moviehash]
      qparams["sMH"] = params[:moviehash]
    end
    
    
    
   # https://www.podnapisi.net/ppodnapisi/search?sI=%s&sJ=%s&sTS=%s&sTE=%s&sXML=1



 # sXML - 1 to enable XML output
 # sK - Keywords
 # sJ - Language (old integer IDs), comma delimited
 # sL - Languages in ISO codes (exception are sr-latn and pt-br), comma delimited
 # sM - OMDb movie ID (old numeric ID)
 # sI - IMDb id
 # sY - Year of the release
 # sR - Release (not accurate)
 # sTS - Season
 # sTE - Episode
 # sEH - Exact hash match (OSH)
 # sMH - Movie hash (OSH)
 # page - Pagination

    response = connection.get do |req|
      req.url SEARCH_PATH, qparams

    end
   # Rails.logger.debug("response: "+response.inspect)

    #xml = response.body
    doc = Nokogiri.XML(response.body)
    
    
    
#    xml = response.to_hash
    
    
    #Rails.logger.debug("\n\n\n\n\n.......\n\n\n\n\nresponse xml: "+xml.inspect  )
 #   body =xml[:body]
    #Rails.logger.debug("\n\n\n\n\n.......\n\n\n\n\n body: "+body.inspect)
    
    
  #  Rails.logger.debug("\n\n\n\n\n.......\n\n\n\n\ndoc: class:#{doc.class}\ninspect:"+doc.inspect)
    results =   doc.xpath("//results")
 #   Rails.logger.debug("\n\n\n\n\n.......\n\n\n\n\results: class:#{results.class}\ninspect:"+results.inspect)
    
    myhash = Hash.from_xml(results.first.to_xml)
    
 #   Rails.logger.debug("\n\n\n\n\n.......\n\n\n\n\nhash:  class:#{myhash.class}\ninspect: "+myhash.inspect)
    if myhash["results"].has_key?("subtitle")
      subtitles=myhash["results"]["subtitle"]
      if subtitles.is_a?(Hash)
        subtitles=[subtitles]
      end
    #  Rails.logger.debug("\n\n\n\n\n.......\n\n\n\n\nsubtitles: class:#{subtitles.class}\ninspect:"+subtitles.inspect)
      SubtitleResultSet.build(subtitles).instances
    else
      return nil
    end
    #doc.xpath("//results").first
    #xml
  end
  
  def self.endpoint_url
    ENDPOINT
  end

#     Podnapisi.search(moviehash:"9a27012fe528858b" ) 


  # Public: Find a subtitle by id.
  #
  # id - The id of the subtitle.
  #
  # Examples
  #
  #   Podnapisi.find(136037)
  #   # => TODO: display example result
  #
  # Returns the complete information of the Subtitle.
  def self.find(id)
    response = connection.get(id.to_s)
    html     = response.body

    subtitle = Subtitle.build(html)
    subtitle.id = id
    subtitle
  end

  # Public: Find a subtitle by id.
  #
  # id - The id of the subtitle.
  #
  # Examples
  #
  #   Podnapisi.find(136037)
  #   # => TODO: display example result
  #
  # Returns the complete information of the Subtitle.
  def self.findUrl(id, url)
    params = {}
    response = connection.get do |req|
      req.url url, params
      req.headers['Cookie'] = "LanguageFilter=#{@lang_id};" if @lang_id
    end
    html     = response.body

    subtitle = Subtitle.build(html)
    subtitle.id = id
    subtitle
  end

  # Public: Set the language id for the search filter.
  #
  # lang_id - The id of the language. Maximum 3, comma separated.
  #           Ids can be found at http://podnapisi.net/filter
  #
  # Examples
  #
  #   Podnapisi.language = 13 # English
  #   Podnapisi.search("...") # Results will be only English subtitles
  #   Podnapisi.language = "13,38" # English, Spanish
  #   ...
  #
  def language=(lang_id)
    @lang_id = lang_id
  end
  def language_name=(lang_name)
    if lang_name.match(",")
      lang_array=lang_name.split(",")
      ret=[]
      lang_array.each do |l|
        ret<<languages_ids(l) unless languages_ids(l).nil?
      end
      @lang_id=ret.join(",")
    else
      @lang_id = languages_ids(lang_name)    
    end
  end
  def self.lang_id
    @lang_id
  end


  private

  def connection
    h = {"User-Agent"=> "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36",
      'Content-Type' => 'application/xml'}
    @connection ||= Faraday.new(url: ENDPOINT) do |faraday|
      faraday.response :logger if ENV['DEBUG']

      faraday.adapter  Faraday.default_adapter
      faraday.headers = h
      #faraday.use      Podnapisi::Response::HTML
      faraday.use      Podnapisi::Response::RaiseError
    end
  end


  def languages_ids(name)
    langs = { "Arabic" => 2 , "Brazillian Portuguese" => 4 , "Danish" => 10, "Dutch" => 11, "English" => 13, "Farsi/Persian" => 46, "Finnish" => 17, "French" => 18, "Greek" => 21, "Hebrew" => 22, "Indonesian" => 44, "Italian" => 26, "Korean" => 28, "Malay" => 50, "Norwegian" => 30, "Portuguese" => 32, "Romanian" => 33, "Spanish" => 38, "Swedish" => 39, "Turkish" => 41, "Vietnamese" => 45, "Albanian" => 1 , "Armenian" => 73, "Azerbaijani" => 55, "Basque" => 74, "Belarusian" => 68, "Bengali" => 54, "Big 5 code" => 3, "Bosnian" => 60, "Bulgarian" => 5 , "Bulgarian/ English" => 6 , "Burmese" => 61, "Cambodian/Khmer" => 79, "Catalan" => 49, "Chinese BG code" => 7 , "Croatian" => 8 , "Czech" => 9 , "Dutch/ English" => 12, "English/ German" => 15, "Esperanto" => 47, "Estonian" => 16, "Georgian" => 62, "German" => 19, "Greenlandic" => 57, "Hindi" => 51, "Hungarian" => 23, "Hungarian/ English" => 24, "Icelandic" => 25, "Japanese" => 27, "Kannada" => 78, "Kurdish" => 52, "Latvian" => 29, "Lithuanian" => 43, "Macedonian" => 48, "Malayalam" => 64, "Manipuri" => 65, "Mongolian" => 72, "Nepali" => 80, "Pashto" => 67, "Polish" => 31, "Punjabi" => 66, "Russian" => 34, "Serbian" => 35, "Sinhala" => 58, "Slovak" => 36, "Slovenian" => 37, "Somali" => 70, "Sundanese" => 76, "Swahili" => 75, "Tagalog" => 53, "Tamil" => 59, "Telugu" => 63, "Thai" => 40, "Ukrainian" => 56, "Urdu" => 42, "Yoruba" => 71 }
    if langs.has_key?(name)
      langs[name]
    else
      nil
    end

  end
end
