# require 'net/http'
# require 'net/http/post/multipart'
# require 'json'
# require 'uri'
# group_id = '179963046'
# access_user = '1c01df7bcab1b79823f351984b776d9f4c923572823461c881553d3a56b874d1d094e72c90b3f15571f05'

# get_photo_url = URI('https://api.vk.com/method/photos.getWallUploadServer?v=5.92&access_token=' + access_user + '&group_id=' + group_id)  # Получаю данные для загрузки фото
# json_parameters = JSON.parse(Net::HTTP.get(get_photo_url)) # В json их
# upload_url = json_parameters["response"]["upload_url"] # получаю upload_url из json
# photo = '../../public/123.jpg'
# uri = URI(upload_url)

# response = Net::HTTP.start uri.host, uri.port, :use_ssl => (uri.scheme == 'https') do |connection|
#       request = Net::HTTP::Post.new uri
#       # p request
#       form_data = [
#           ['file', UploadIO.new(File.open(photo),'image/jpeg',"123.jpg")]
#       ]
#       request.set_form form_data, 'multipart/form-data'
#       connection.request request
#     end
#     ans = JSON.parse(response.body)
#     p ans

#     server = ans["server"].to_s
#     hash_string = ans["hash"].to_s
#     id_p = ans["photo"]
#     p id_p


# get_upload_url = URI('https://api.vk.com/method/photos.saveWallPhoto?v=5.92&access_token=' + access_user + '&gid=' + group_id + '&server=' + server + '&hash=' + hash_string + '&photo=' + id_p)  # Загружаю фотоsaveWallPhoto
