class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'welcome', :controller=>'top')
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:user][:login], params[:user][:password])
    if current_user
      redirect_back_or_default(:controller => 'top', :action => 'welcome')
      flash[:notice] = "Logged in successfully"
    end
  end

## Note that this (and edit) use current_user rather than a parameter to select the user
## that is getting updated.  This is a security precaution to prevent a user from
## updating someone else's details.
  def update
    if params[:user] && current_user.update_attributes(params[:user])
      flash[:notice]="Account details updated."
      redirect_to :action=>"welcome", :controller=>"top"
    else
     @user=current_user
     render :action=> "edit"
    end
  end
  
  def edit
    @user=current_user
  end

  def logout
    self.current_user = nil
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/account', :action => 'index')
  end
end
