require 'net/http'
require 'net/http/post/multipart'
require 'json'
require 'uri'
class Post < ApplicationRecord

	after_save :new_post

	def new_post
	    
		post = Post.last

		app_id = post.app_id
		access_token = '1c01df7bcab1b79823f351984b776d9f4c923572823461c881553d3a56b874d1d094e72c90b3f15571f05'
		group_id = post.group_id

		main_body = 'https://api.vk.com/method/photos.getWallUploadServer?v=5.92&access_token=' + access_token
		group_id_body = '&group_id=' + group_id
		getWallUploadServer_body = main_body + group_id_body

		getWallUploadServer = URI(get_photo_url_body)  # Получаю данные для загрузки фото
		json_parameters = JSON.parse(Net::HTTP.get(getWallUploadServer)) # В json их
		
		uri = URI(json_parameters["response"]["upload_url"])
		photo_from_db = post.photos
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
		lat_long_body = '&lat=' + post.lat + '&long=' + post.long
		if post.content.to_s.empty?
			wall_post_body = main_body + group_id_body + lat_long_body + '&attachment=' + photo_body
		else
			message_body = '&message=' + post.content
			wall_post_body = main_body + group_id_body + lat_long_body + message_body + '&attachment=' + photo_body
		end
		wall_post = URI(wall_post_body)
		ans = JSON.parse(Net::HTTP.get(wall_post))
	end

	def publish
		
	end
end
