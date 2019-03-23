require 'net/http'
require 'json'
require 'uri'
class PostController < ApplicationController
  def index
  end

  def new
  	app_id = '6907700'

  	app_secret = '5455N2H7yveGnT5HdiP1'
	
	access_user = '1c01df7bcab1b79823f351984b776d9f4c923572823461c881553d3a56b874d1d094e72c90b3f15571f05'
	group_id = '-179963046'
 #  	auth = URI('https://oauth.vk.com/authorize?v=5.92&client_id=' + app_id + '&redirect_uri=https://intense-stream-65954.herokuapp.com')
	# ans = JSON.parse(Net::HTTP.get(auth))
	# print(ans)
	get_posts = URI('https://api.vk.com/method/wall.post?v=5.92&access_token=' + access_user + '&owner_id=' + group_id + '&from_group=0&signed=1&lat=55.795853&long=49.135289&message=msg')
	ans = JSON.parse(Net::HTTP.get(get_posts))
    print(ans)
  end
end
