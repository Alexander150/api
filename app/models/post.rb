require 'net/http'
require 'net/http/post/multipart'
require 'json'
require 'uri'
class Post < ApplicationRecord

	after_save :new_post

	def new_post
		post = Post.last
		post.publish
		
	end

	def publish
		app_id = self.app_id
		# access_token  = '1c01df7bcab1b79823f351984b776d9f4c923572823461c881553d3a56b874d1d094e72c90b3f15571f05'
		access_token = 'a9223c03ce7b3b00e083a86b20abb5fe3b7f11fbcbe39232efd8f822b6d3f77f57dbd837dca8cc89a6cec'

		group_id = self.group_id
			begin
				main_body = 'https://api.vk.com/method/wall.post?v=5.92&access_token=' + access_token + '&from_group=0&signed=1'
				group_id_body = '&owner_id=-' + group_id # В поле owner_id вставляется id группы
				message_body = '&message=' + self.content
				check_token = main_body + group_id_body + message_body

				wall_post = URI(main_body + URI.encode(check_token))
				ans = JSON.parse(Net::HTTP.get(wall_post))

				post_id = ans["response"]["post_id"]

				main_body = 'https://api.vk.com/method/wall.delete?v=5.92&access_token=' + access_token + '&from_group=0&signed=1'
				group_id_body = '&owner_id=-' + group_id # В поле owner_id вставляется id группы
				post_id_body = '&post_id=' + post_id.to_s
				check_token = group_id_body + post_id_body

				wall_delete = URI(main_body + URI.encode(check_token))
				ans = JSON.parse(Net::HTTP.get(wall_delete))

			rescue => e
				p "Если Вы выложили менее 50 постов, то токен не валиден. Для получения токена перейдите по ссылке => https://oauth.vk.com/authorize?client_id=" + app_id + "&display=page&scope=friends&response_type=token&v=5.92&state=123456&scope=1073737727 и возьмите все что находится после 'access_token=' и до '&expires_in'. Скопированный текст необходимо вставить в переменную access_token (строка 18, вместо текста в кавычках ('#сюда#')"
				return 
			end

		main_body = 'https://api.vk.com/method/photos.getWallUploadServer?v=5.92&access_token=' + access_token
		group_id_body = '&group_id=' + group_id
		getWallUploadServer_body = main_body + group_id_body

		getWallUploadServer = URI(getWallUploadServer_body)  # Получаю данные для загрузки фото
		json_parameters = JSON.parse(Net::HTTP.get(getWallUploadServer)) # В json их
		
		uri = URI(json_parameters["response"]["upload_url"])
		photo_from_db = self.photos
		photos_source = photo_from_db.split(',')
		photo_body = ''

		for i in 0..photos_source.size-1
			photo_source = photos_source[i]
			
			response = Net::HTTP.start uri.host, uri.port, :use_ssl => (uri.scheme == 'https') do |connection|
				request = Net::HTTP::Post.new uri
			      form_data = [
			          ['file', UploadIO.new(File.open(photo_source),'image/jpeg',"photo.jpg")]
			      ]
			      request.set_form form_data, 'multipart/form-data'
			      connection.request request
			    end
			ans = JSON.parse(response.body)

			server = ans["server"].to_s
			hash_string = ans["hash"]
			id_photo = ans["photo"]

			main_body 	= 'https://api.vk.com/method/photos.saveWallPhoto?v=5.92&access_token=' + access_token 
			group_id_body 	= '&group_id=' + group_id 
			server_body = '&server=' + server
			hash_body = '&hash=' + hash_string
			photos_body = '&photo=' + id_photo
			saveWallPhoto_body = main_body + group_id_body + server_body + hash_body + photos_body
			saveWallPhoto = URI(saveWallPhoto_body)  # Загружаю фото
			ans = JSON.parse(Net::HTTP.get(saveWallPhoto))
			owner_id = ans["response"][0]["owner_id"].to_s
			if i == photos_source.size-1
				photo_body.insert(-1, 'photo' + owner_id + '_' + ans["response"][0]["id"].to_s)
			else
				photo_body.insert(-1, 'photo' + owner_id + '_' + ans["response"][0]["id"].to_s + ',')
			end
		end
				
		main_body = 'https://api.vk.com/method/wall.post?v=5.92&access_token=' + access_token + '&from_group=0&signed=1'
		group_id_body = '&owner_id=-' + group_id # В поле owner_id вставляется id группы
		lat_long_body = '&lat=' + self.lat + '&long=' + self.long
		#Ксли контент не пустой, то грузить
		if self.content.to_s.empty?
			wall_post_body =  group_id_body + lat_long_body + '&attachment=' + photo_body
		else
			message_body = '&message=' + self.content
			wall_post_body =  group_id_body + lat_long_body + message_body + '&attachment=' + photo_body
		end
		wall_post = URI(main_body + URI.encode(wall_post_body))
		p ans = JSON.parse(Net::HTTP.get(wall_post))
	end
end
