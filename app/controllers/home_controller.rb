class HomeController < ApplicationController
	before_filter :authenticate_user!
	def index
		session[:oauth] = Koala::Facebook::OAuth.new("232648703490156", "2d4a909fe1621011d9ed0bdc07a11a81", 'http://localhost:3000/home/callback')
		@auth_url =  session[:oauth].url_for_oauth_code(:permissions=> "user_likes")
  end
  
  def callback
  	if params[:code]
			# acknowledge code and get access token from FB
			session[:access_token] = session[:oauth].get_access_token(params[:code])
		end		

		# auth established, now do a graph call:
		  
		@api = Koala::Facebook::API.new(session[:access_token])
		begin
			@graph_data = @api.get_object("/me?", "fields"=>"id")
      @likes = @api.get_object("/me/likes", "fields"=>"name")
      print("heroro == #{@graph_data["id"]} --   melanin == #{@likes["name"]}")
      print("melanin == #{@likes["name"]}")
      
      puts("wazzzup")
      puts("wazzzup #{@graph_data["id"]}")
		rescue Exception=>ex
			puts ex.message
		end
		redirect_to home_index_path
		
		authentication = Authentication.find_by_provider_and_uid("facebook", @graph_data["id"])
      
    if authentication 
    	likes_exits = Likes.find_by_authentication_id(authentication)
    	if likes_exits
    		flash[:notice] = "Data already imported."
    	else
		   	@likes.each do |status|
				 	like = Likes.new
				 	like.authentication_id = authentication
					like.like = status["name"]
					like.save!
				end
				flash[:notice] = "Successfully imported."
			end
		else
			flash[:notice] = "Unsuccessfully imported. Please login with facebook and try again."
		end
	end
end
