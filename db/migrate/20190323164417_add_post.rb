class AddPost < ActiveRecord::Migration[5.2]
  def change
  	  	Post.create(:title => "Borsche1", :photo => "https://images1.popmeh.ru/upload/img_cache/9e6/9e663df2539446f6c910e19e382dd38f_ce_1838x980x80x258_cropped_800x427.jpg", :file => "/public/bd.pdf", :lat => "55.795853", :long => "49.135289", :href => "asdsagdg");
  end
end
