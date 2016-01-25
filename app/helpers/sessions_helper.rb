module SessionsHelper
	#logs in the given user.
	def log_in(user)
		session[:user_id] = user.id
	end

	#redirects to stored location (or to the default) (for friendly forwarding)
	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	# Stores the URL trying to be accessed (for friendly forwarding)
	def store_location
		session[:forwarding_url] = request.url if request.get?
	end

	#remembers a user in a persistent session
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	#returns true if the given user is the current user (listing 9.24)
	def current_user?(user)
		user == current_user
	end

	#returns the user corresponding to teh remember token cookie ||= will assign to @current_user if currently empty
	def current_user
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(:remember, cookies[:remember_token])
				log_in user
				@current_user	= user
			end
		end
	end

	#returns true if the user is logged in, false otherwise.
	def logged_in?
		!current_user.nil?
	end

	#logs out the current user
	def log_out
		session.delete(:user_id)
		@current_user = nil
	end

	#forgets a persistent session.
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	#logs out the current user
	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end
end
