require "podnapisi/subtitle_result"

class Podnapisi::SubtitleResultSet
  attr_reader :instances

  def initialize(attributes)
    @instances = attributes[:instances]
  end

  def self.build(subtitles)

#    Rails.logger.debug("build SubtitleResultSet subtitles: "+subtitles.inspect)
    
#    instances = html.css("tbody > tr").collect do |item|
   instances = subtitles.collect do |item|
      Podnapisi::SubtitleResult.build(item)
    end

    new({
      instances: instances
    })
  end
end
