require 'net/http'
require 'json'
require 'uri'
class VkProductUploader < ActiveRecord::Base
  private
  def self.get_image_id(photo, main_photo, access_token, group_id)
    get_server_uri = URI('https://api.vk.com/method/photos.getMarketUploadServer?v=5.52&access_token=' + access_token +
                             '&main_photo=' + main_photo + '&group_id=' + group_id)
    puts ans = JSON.parse(Net::HTTP.get(get_server_uri))
    uri = URI(ans["response"]["upload_url"])

    response = Net::HTTP.start uri.host, uri.port, :use_ssl => (uri.scheme == 'https') do |connection|
      request = Net::HTTP::Post.new uri
      form_data = [
          ['file', photo]
      ]
      request.set_form form_data, 'multipart/form-data'
      connection.request request
    end
    # puts ans
    ans = JSON.parse(response.body)
    if main_photo == "1"
      save_photo_uri = URI(('https://api.vk.com/method/photos.saveMarketPhoto?v=5.52&access_token=' + access_token +
                               '&group_id=' + group_id + '&photo=' + ans['photo'] + '&server=' + ans['server'].to_s +
                               '&hash=' + ans['hash'] + '&crop_data=' + ans['crop_data'] + '&crop_hash=' + ans['crop_hash']).gsub('\\',''))
    else
      save_photo_uri = URI(('https://api.vk.com/method/photos.saveMarketPhoto?v=5.52&access_token=' + access_token +
                               '&group_id=' + group_id + '&photo=' + ans['photo'] + '&server=' + ans['server'].to_s +
                               '&hash=' + ans['hash']).gsub('\\',''))
      end
    ans = JSON.parse(Net::HTTP.post_form(save_photo_uri, 'q' => 'ruby').body)
    return ans["response"][0]["id"].to_s
  end
  # @@access_token = 
  # 

  public
  def self.upload_product(main_photo, photos, name, description, price, category_id)
    if VkProductUploader.last.nil?
      return false
    end
    access_token = VkProductUploader.last.access_token
    group_id = VkProductUploader.last.group_id

    puts str = 'https://api.vk.com/method/market.add?v=5.52&access_token=' + access_token +
                           '&name=' + name +
                           '&description=' + description +
                           '&category_id=' + category_id +
                           '&price=' + price + '&main_photo_id=' + self.get_image_id(main_photo, "1", access_token,
                                                                                     group_id) +
                           '&owner_id=-' + group_id
    add = []
    photos.each do |photo|
      add.push(self.get_image_id(photo, "0", access_token, group_id).to_i)
    end
    str += '&photo_ids=' + add.to_s[1..-1]
    add_item_uri = URI(URI::encode str)
    # ans = JSON.parse(Net::HTTP.get(add_item_uri))
    puts "ALMOST OK"
    puts ans = JSON.parse(Net::HTTP.post_form(add_item_uri, 'q' => 'ruby').body)
    puts "OK"
    return ans["response"]["market_item_id"]
  end

  def self.delete(market_item_id)
    if VkProductUploader.last.nil?
      return false
    end
    access_token = VkProductUploader.last.access_token
    group_id = VkProductUploader.last.group_id
    save_photo_uri = URI('https://api.vk.com/method/market.delete?v=5.52&access_token=' + access_token +
                             '&owner_id=-' + group_id + '&item_id=' + market_item_id)
    puts(JSON.parse(Net::HTTP.get(save_photo_uri)))
  end

end