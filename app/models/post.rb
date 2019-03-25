require 'net/http'
require 'json'
require 'uri'
class Post < ApplicationRecord

	after_save :new_post

	  def new_post
	  
		app_id = '6907700'

		app_secret = '5455N2H7yveGnT5HdiP1'
				
		access_user = '1c01df7bcab1b79823f351984b776d9f4c923572823461c881553d3a56b874d1d094e72c90b3f15571f05'
		group_id = '-179963046'

		last_post = Post.last
		get_posts = URI('https://api.vk.com/method/wall.post?v=5.92&access_token=' + access_user + '&owner_id=' + group_id + '&from_group=0&signed=1&lat=' + last_post.lat + '&long=' + last_post.long + '&message=' + last_post.title)
		@ans = JSON.parse(Net::HTTP.get(get_posts))

	  end

end
