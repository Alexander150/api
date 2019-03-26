require 'net/http'
require 'json'
require 'uri'
group_id = '179963046'
access_user = '1c01df7bcab1b79823f351984b776d9f4c923572823461c881553d3a56b874d1d094e72c90b3f15571f05'

get_photo_url = URI('https://api.vk.com/method/photos.getWallUploadServer?v=5.92&access_token=' + access_user + '&group_id=' + group_id)  # Получаю данные для загрузки фото
json_parameters = JSON.parse(Net::HTTP.get(get_photo_url)) # В json их
upload_url = json_parameters["response"]["upload_url"] # получаю upload_url из json
# get_json_upload_url = JSON.parse(Net::HTTP.get(URI(json_parameters["response"]["upload_url"]))) # получаю upload_url из json в json
# server = get_json_upload_url["server"].to_s # получаю server в виде строки
# hash_string = get_json_upload_url["hash"].to_s # получаю hash в виде строки

# photo = "https://images1.popmeh.ru/upload/img_cache/9e6/9e663df2539446f6c910e19e382dd38f_ce_1838x980x80x258_cropped_800x427.jpg"
photo = 'http://151.248.113.245:3000/123.jpg'
uri = URI(upload_url)

response = Net::HTTP.start uri.host, uri.port, :use_ssl => (uri.scheme == 'https') do |connection|
      request = Net::HTTP::Post.new uri
      form_data = [
          ['file', photo]
      ]
      request.set_form form_data, 'multipart/form-data'
      connection.request request
    end
    ans = JSON.parse(response.body)
    p ans