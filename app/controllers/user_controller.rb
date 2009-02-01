##################################################################################
##                                                                              ##
##                           Copyright (c) Robert Jones 2006                    ##
##                                                                              ##
##  This file is part of FreeMIS.                                               ##
##                                                                              ##
##  FreeMIS is free software; you can redistribute it and/or modify             ##
##  it under the terms of the GNU General Public License as published by        ##
##  the Free Software Foundation; either version 2 of the License, or           ##
##  (at your option) any later version.                                         ##
##                                                                              ##
##  FreeMIS is distributed in the hope that it will be useful,                  ##
##  but WITHOUT ANY WARRANTY; without even the implied warranty of              ##
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               ##
##  GNU General Public License for more details.                                ##
##                                                                              ##
##  You should have received a copy of the GNU General Public License           ##
##  along with FreeMIS; if not, write to the Free Software                      ##
##  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA  ##
##                                                                              ##
##################################################################################
class UserController < ApplicationController
  #model   :user
  before_filter :login_required

  def logout
    @session[:user] = nil
    redirect_to :action => 'login', :controller=>"account"
  end

 
  def edit
    @user=current_user
  end
  
  def update
    @user=User.find(params['id'])
    if @user.update_attributes(params['user'])
      flash[:notice]="Update Successful"
    end
    redirect_to :action=>"edit"
  end

  def change_password
    return unless request.post?
    if User.authenticate(current_user.login, params[:old_password]) || Group.find_by_name("admin").has_user(current_user)
      if (params[:password] == params[:password_confirmation])
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]
        flash[:notice] = current_user.save ?
              "Password changed" :
              "Password not changed" 
      else
        flash[:notice] = "Password mismatch" 
        @old_password = params[:old_password]
      end
    else
      flash[:notice] = "Wrong password" 
    end
    redirect_to :action=> params[:destination] || "edit"
  end
  

  def welcome
  end
  
  def allocate_groups
    if params[:commit]
    @user = User.find(params['id'])
    if @user.update_attributes(params['user'])
      flash[:notice] = "Update Successful" 
    end
    else
      if params[:user_id]
        @user=User.find(params[:user_id])
        # a user has been selected, so prepare to show form
      end
    end
  end
  
  def admin_edit
    @faculties=Faculty.find(:all, :order=>"name")
    @user=User.find(params[:user_id]) if params[:user_id]
    if params[:id]
      @user=User.find(params[:id])
      if @user.update_attributes(params[:user])
        flash[:notice]="User Details Edited."
        redirect_to :action=>'show', :id=>@user
      end
    end
  end

  def admin_change_password
    if params['user_id']
      @user = User.find(params['user_id'])
      if params['password'] && @user
          if (params[:password] == params[:password_confirmation])
            @user.password_confirmation = params[:password_confirmation]
            @user.password = params[:password]
            if @user.save
              flash[:notice]="Password changed for #{@user.fullname}"
              redirect_to :action=>'admin_change_password'
            else
              flash.now[:notice]="Password not changed" 
            end
          else
              flash[:notice] = "Password mismatch" 
          end
       end
    end
  end
  
  def show
    @user=User.find(params[:id])
  end

  ## This is only accessible by admin users.  No self-signup!!
  def signup
    @user = User.new(params[:user])
    return unless request.post?
    if @user.save
      flash[:notice] = "New user added!"
      redirect_to :action=>'show', :id=>@user
    end
  end
  
  protected

end
