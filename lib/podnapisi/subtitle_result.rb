class Podnapisi::SubtitleResult

 attr_accessor :attributes, :id, :pid ,:title, :year, :movie_id, :movie_entryp_id, :imdbid, :url, :uploader_id, :uploader_name , :release , :releases  , :language  , :time , :season_number , :episode_number, :tvspecial , :cds , :format   , :fps , :rating   , :flags, :new_flags   , :downloads , :exact_hashes 

 def initialize(attributes)
 #  Rails.logger.debug("\n.........................\nbuild SubtitleResult initialize hash: "+attributes.inspect)
  @attributes = attributes

  @id   = @attributes[:id]
  @pid   = @attributes[:pid]
  @title = @attributes[:title]
  @year = @attributes[:year]
  @movie_id  = @attributes[:movie_id]
  @movie_entryp_id   = @attributes[:movie_entryp_id]
  @imdbid  = @attributes[:imdbid]
  @url  = @attributes[:url]
  
  @uploader_id   = @attributes[:uploader_id]
  @uploader_name  = @attributes[:uploader_name]
  @release    = @attributes[:release] 
  @releases    = @attributes[:releases] 
  @language    = @attributes[:language]
  @time  = @attributes[:time]
  @season_number    = @attributes[:season_number]
  @episode_number   = @attributes[:episode_number]
  @tvspecial   = @attributes[:tvspecial]
  @cds   = @attributes[:cds]
  @format = @attributes[:format]
  @fps   = @attributes[:fps]
  @rating = @attributes[:rating]
  @flags  = @attributes[:flags]
  @new_flags = @attributes[:new_flags]
  @downloads   = @attributes[:downloads]
  @exact_hashes  = @attributes[:exact_hashes]
  
  
 
  end

 def self.build(hash)
  Rails.logger.debug("\n-------------------\nbuild SubtitleResult hash: "+hash.inspect)
  imdbid=nil
  if hash.has_key?("externalMovieIdentifiers")
   imdbid = hash["externalMovieIdentifiers"]["imdb"]
  end
  
  myhash = {
   id: hash["id"], 
   pid: hash["pid"],    
   title: hash["title"],   
   year: hash["year"],   
   movie_id: hash["movieId"], 
   movie_entryp_id: hash["movieEntryPid"] ,
   imdbid: imdbid, 
   url: hash["url"] ,   
   
   uploader_id: hash["uploaderId"]  , 
   uploader_name: hash["uploaderName"]   ,
   release: hash["release"],
   releases: hash["releases"],
   language: hash["language"] ,
   time: Date.strptime(hash["time"],'%s').to_s(:db) ,   
   season_number: hash["tvSeason"]  , 
   episode_number: hash["tvEpisode"]  ,
   tvspecial: hash["tvSpecial"]  ,   
   cds: hash["cds"]  ,  
   format: hash["format"]   ,   
   fps: hash["fps"] ,   
   rating: hash["rating"]  , 
   flags: hash["flags"]  , 
   new_flags: hash["new_flags"]  , 
   downloads: hash["downloads"]   ,  
   exact_hashes: hash["exacthashes"]   
   
  }
  # Rails.logger.debug("\n-------------------\nbuild SubtitleResult myhash: "+myhash.inspect)
  new (myhash)
  
  
  
 end
end
#    
#    {
#  "id"  "=>"  "4621860",
#  "pid"  "=>"  "JIZG",
#  "title"  "=>"  "Fatal Affair",
#  "year"  "=>"  "2020",
#  "movieid"  "=>nil",
#  "movieentrypid"  "=>"  "bAIB",
#  "externalmovieidentifiers"  "=>"{
#   "imdb"   "=>"   "11057594"
#  },
#  "url"  "=>"  "http://www.podnapisi.net/en/subtitles/si-fatal-affair-2020/JIZG",
#  "uploaderid"  "=>"  "332793",
#  "uploadername"  "=>"  "MachineKeriya",
#  "release"  "=>"  "Fatal.Affair.2020.720p.WEB.H264-HUZZAH",
#  "releases"  "=>"{
#   "release"   "=>"   "Fatal.Affair.2020.720p.WEB.H264-HUZZAH"
#  },
#  "languageid"  "=>"  "56",
#  "languagename"  "=>"  "Sinhala",
#  "language"  "=>"  "si",
#  "time"  "=>"  "1595234698",
#  "tvseason"  "=>"  "0",
#  "tvepisode"  "=>"  "0",
#  "tvspecial"  "=>"  "0",
#  "cds"  "=>nil",
#  "format"  "=>"  "N/A",
#  "fps"  "=>"  "N/A",
#  "rating"  "=>"  "0.0",
#  "flags"  "=>"  "m",
#  "new_flags"  "=>"{
#   "flag"   "=>"   "gams"
#  },
#  "downloads"  "=>"  "0",
#  "exacthashes"  "=>nil"
#    }