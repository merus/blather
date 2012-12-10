class UsersController < ApplicationController
	before_filter :unknown_user, only: [:new, :create]
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :admin_user, only: [:destroy]

	def show
    	@user = User.find(params[:id])
    	@microposts = @user.microposts.paginate(page: params[:page])
  	end

  	def new
  		@user = User.new
  	end

  	def create
	    @user = User.new(params[:user])
	    if @user.save
	    	sign_in @user
			flash[:success] = "Welcome to Blather! Why don't you blather the world about joining?"
		    redirect_to @user
	    else
	      render 'new'
	    end
	end

	def edit
	end

	def update
		if @user.update_attributes(params[:user])
			flash[:success] = "Login successful!"
			sign_in @user
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		@doomed_user = User.find(params[:id])
		if current_user?(@doomed_user) then
			flash[:error] = "You can't destroy yourself! Use alcohol instead."
		else
			@doomed_user.destroy
			flash[:success] = "User destroyed."
		end
		
		redirect_to users_url
	end

	def index
		@users = User.paginate(page: params[:page])
	end

	private

		def unknown_user
			redirect_to root_url unless !signed_in?
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to root_url unless current_user?(@user)
		end

		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
end
