# frozen_string_literal: true

require 'digest/md5'
require 'json'
require 'yaml'
require 'httparty'
require 'concurrent'

LIZHI_RADIO_ID = '1913563'
XIMALAYA_ALBUM_ID = '49373071'

# Lizhi to get stream_table of Lizhi
class Lizhi
  def initialize(radio_id = LIZHI_RADIO_ID)
    @radio_id = radio_id
  end

  def stream_table
    stream_table = {}
    raw_data.each do |episode|
      %w[http https].each do |protocol|
        stream_url_prefix_all = "#{protocol}://www.lizhi.fm/#{@radio_id}/#{episode['id']}"
        # cdn5 serve cannot be accessed directly, so change cdn5 into cdn
        url = episode['url']
        url.sub! 'cdn5', 'cdn'
        stream_table[stream_url_prefix_all] = { 'url' => url, 'duration' => episode['duration'] }
      end
    end
    stream_table
  end

  private

  def raw_data
    # iframe api: http://m.lizhi.fm/api/audios_with_radio_iframe?ids=2624027675254166022
    # https://github.com/soimort/you-get/blob/f48aad970044e30060ce2a117559e69a9049e7a4/src/you_get/extractors/lizhi.py
    api_url = "http://www.lizhi.fm/api/radio_audios?s=0&l=100&flag=2&band=#{@radio_id}"
    response = HTTParty.get(api_url)
    JSON.parse(response.body)
  rescue StandardError
    [] # Lizhi API is down, return empty
  end
end

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
        enclosure_url: item_xml[%r{<enclosure[^>]*url="([^"]+)"}, 1],
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
    when 3 then parts[0] * 3600 + parts[1] * 60 + parts[2]
    when 2 then parts[0] * 60 + parts[1]
    else 0
    end
  end
end
