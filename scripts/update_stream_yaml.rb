# frozen_string_literal: true

require 'digest/md5'
require 'yaml'
require 'httparty'

ROOT_DIR = File.expand_path('..', __dir__)
STREAM_YAML = "#{ROOT_DIR}/_data/stream_yaml.yml"
LIZHI_RADIO_ID = '1913563'
XIMALAYA_ALBUM_ID = '49373071'

# Lizhi to get stream_table of Lizhi
class Lizhi
  def initialize(radio_id)
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
  def initialize(album_id)
    @album_id = album_id
    @xm_sign = xm_sign
  end

  def stream_table
    # https://github.com/DVLZY/radio_download_ximalaya
    api_url = "https://www.ximalaya.com/revision/album/v1/getTracksList?albumId=#{@album_id}&pageNum=1"
    response = HTTParty.get(api_url)
    tracks = JSON.parse(response.body)['data']['tracks']
    stream_table = {}
    tracks.each do |track|
      stream_url_prefix_all = "https://www.ximalaya.com/yinyue/#{@album_id}/#{track['trackId']}"
      stream_table[stream_url_prefix_all] =
        { 'url' => audio_src(track['trackId']), 'duration' => track['duration'] }
    end
    stream_table
  end

  private

  def server_time
    api_url = 'https://www.ximalaya.com/revision/time'
    response = HTTParty.get(api_url)
    response.body
  end

  def now
    Time.now.utc.to_i * 1000
  end

  def random_num
    rand(1..100)
  end

  def xm_sign
    # https://blog.csdn.net/BigBoy_Coder/article/details/103406332
    cached_server_time = server_time
    md5_hash = Digest::MD5.hexdigest("himalaya-#{cached_server_time}")
    "#{md5_hash}(#{random_num})#{cached_server_time}(#{random_num})#{now}"
  end

  def audio_src(audio_id)
    api_url = "https://www.ximalaya.com/revision/play/v1/audio?id=#{audio_id}&ptype=1"
    headers = {
      'xm-sign' => @xm_sign
    }
    response = HTTParty.get(api_url, headers: headers)
    JSON.parse(response.body)['data']['src']
  end
end

def output(stream_table)
  old_stream_table = YAML.safe_load(File.read(STREAM_YAML))
  stream_table = old_stream_table.merge(stream_table)
  File.open(STREAM_YAML, 'w') do |file|
    file.write stream_table.to_yaml
  end

  puts '💎 rss feed generated successfully'
end

def main
  lizhi = Lizhi.new(LIZHI_RADIO_ID)
  ximalaya = Ximalaya.new(XIMALAYA_ALBUM_ID)
  stream_table = ximalaya.stream_table.merge(lizhi.stream_table)
  output(stream_table)
end

main
