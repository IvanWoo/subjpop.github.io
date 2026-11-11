# frozen_string_literal: true

require 'httparty'

XIMALAYA_ALBUM_ID = '49373071'

# Ximalaya to get stream_table of Ximalaya via RSS feed (high quality audio)
class Ximalaya
  def initialize(album_id = XIMALAYA_ALBUM_ID)
    @album_id = album_id
  end

  def stream_table
    stream_table = {}
    rss_items.each do |item|
      track_id = item[:track_id]
      play_url = item[:enclosure_url]
      duration = item[:duration]
      next unless play_url && track_id

      stream_url_prefix_all = "https://www.ximalaya.com/yinyue/#{@album_id}/#{track_id}"
      stream_table[stream_url_prefix_all] = { 'url' => play_url, 'duration' => duration }
    end
    stream_table
  end

  private

  def rss_items
    return @rss_items if @rss_items

    rss_url = "https://www.ximalaya.com/album/#{@album_id}.xml"
    response = HTTParty.get(rss_url)
    xml = response.body

    items = xml.scan(%r{<item>(.*?)</item>}m).flatten
    @rss_items = items.map do |item_xml|
      {
        track_id: item_xml[%r{<link>https://www\.ximalaya\.com/sound/(\d+)</link>}, 1],
        enclosure_url: item_xml[/<enclosure[^>]*url="([^"]+)"/, 1],
        duration: parse_duration(item_xml[%r{<itunes:duration>([^<]+)</itunes:duration>}, 1])
      }
    end.compact
  rescue StandardError
    @rss_items = []
  end

  # Parse duration from "MM:SS" or "HH:MM:SS" format to seconds
  def parse_duration(dur_str)
    return nil unless dur_str

    parts = dur_str.split(':').map(&:to_i)
    case parts.length
    when 3 then (parts[0] * 3600) + (parts[1] * 60) + parts[2]
    when 2 then (parts[0] * 60) + parts[1]
    else 0
    end
  end
end
