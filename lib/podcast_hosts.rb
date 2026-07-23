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

# Ximalaya to get stream_table of Ximalaya
class Ximalaya
  # Known track ID from the album used to bootstrap the track list via show API
  BOOTSTRAP_TRACK_ID = '963449729'

  def initialize(album_id = XIMALAYA_ALBUM_ID)
    @album_id = album_id
  end

  def stream_table
    stream_table = {}
    tracks.each do |track|
      track_id = track['trackId']
      duration = track['duration']
      play_url = fetch_play_url(track_id)
      next unless play_url

      stream_url_prefix_all = "https://www.ximalaya.com/yinyue/#{@album_id}/#{track_id}"
      stream_table[stream_url_prefix_all] = { 'url' => play_url, 'duration' => duration }
    end
    stream_table
  end

  private

  def tracks
    return @tracks if @tracks

    api_url = "https://www.ximalaya.com/revision/play/v1/show?id=#{BOOTSTRAP_TRACK_ID}&sort=1&size=100&ptype=1"
    response = HTTParty.get(api_url,
      headers: { 'Referer' => 'https://www.ximalaya.com/' }
    )
    @tracks = JSON.parse(response.body)['data']['tracksAudioPlay']
  end

  def fetch_play_url(track_id)
    api_url = "https://mobile.ximalaya.com/mobile/v1/track/baseInfo?trackId=#{track_id}"
    response = HTTParty.get(api_url,
      headers: { 'User-Agent' => 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15' }
    )
    data = JSON.parse(response.body)
    data['playUrl32'] if data['ret'] == 0
  rescue StandardError
    nil
  end
end
