class PostController < ApplicationController
  def index
  end

  def new
  	app_id = '6907700'
  	
  	auth = URI('https://oauth.vk.com/authorize?v=5.92&client_id=' + app_id + '&redirect_uri=https://intense-stream-65954.herokuapp.com')
	ans = JSON.parse(Net::HTTP.get(auth))
	print(auth)
  end
end
