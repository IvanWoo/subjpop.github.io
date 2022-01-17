# frozen_string_literal: true

require 'digest/md5'
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
    api_url = "http://www.lizhi.fm/api/radio_audios?s=0&l=65535&flag=2&band=#{@radio_id}"
    response = HTTParty.get(api_url)
    JSON.parse(response.body)
  end
end

# Ximalaya to get stream_table of Ximalaya
class Ximalaya
  def initialize(album_id = XIMALAYA_ALBUM_ID)
    @album_id = album_id
  end

  def stream_table
    stream_table = {}
    audio_src_hash = audio_src_many(tracks.map { |track| track['trackId'] })
    tracks.each do |track|
      track_id = track['trackId']
      url = audio_src_hash[track_id]
      duration = track['duration']
      stream_url_prefix_all = "https://www.ximalaya.com/yinyue/#{@album_id}/#{track_id}"
      stream_table[stream_url_prefix_all] = { 'url' => url, 'duration' => duration }
    end
    stream_table
  end

  private

  def tracks
    api_url = "https://www.ximalaya.com/revision/album/v1/getTracksList?albumId=#{@album_id}&pageNum=1"
    response = HTTParty.get(api_url)
    @tracks ||= JSON.parse(response.body)['data']['tracks']
  end

  def server_time
    api_url = 'https://www.ximalaya.com/revision/time'
    response = HTTParty.get(api_url)
    @server_time ||= response.body
  end

  def now
    Time.now.utc.to_i * 1000
  end

  def random_num
    rand(1..100)
  end

  def xm_sign
    # https://blog.csdn.net/BigBoy_Coder/article/details/103406332
    md5_hash = Digest::MD5.hexdigest("himalaya-#{server_time}")
    @xm_sign ||= "#{md5_hash}(#{random_num})#{server_time}(#{random_num})#{now}"
  end

  def audio_src_one(audio_id)
    api_url = "https://www.ximalaya.com/revision/play/v1/audio?id=#{audio_id}&ptype=1"
    headers = {
      'xm-sign' => xm_sign
    }
    response = HTTParty.get(api_url, headers: headers)
    JSON.parse(response.body)['data']['src']
  end

  def audio_src_many(audio_ids)
    default_thread_num = 20
    pool = Concurrent::FixedThreadPool.new([default_thread_num, audio_ids.length].min)
    audio_urls = audio_ids.map do |audio_id|
      Concurrent::Future.execute({ executor: pool }) do
        audio_src_one(audio_id)
      end
    end.map(&:value)
    audio_ids.zip(audio_urls).to_h
  end
end
