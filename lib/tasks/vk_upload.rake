namespace :vk_upload do
	desc "Task description"
	task :test => [:environment] do
		Post.create(:title => "Borsche3", :photos => "./public/1.jpg,./public/2.jpg", :file => "./public/bd.pdf", :lat => "55.795853", :long => "49.135289", :href => "https://shielded-peak-65355.herokuapp.com", :content => "Это машина и котик!", :app_id => "6907700", :group_id => "179963046");
	end
end