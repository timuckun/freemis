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


# The filters added to this controller will be run for all controllers in the application.

# Likewise will all the methods added be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :fix_host_ssl
  #before_filter :login_required
  before_filter :reset_session_expiry
  before_filter :check_accessible 

  def fix_host_ssl
    request.env['HTTPS']="on" if HOST_SSL
  end

  def paginate_collection(collection, options = {})
    default_options = {:per_page => 10, :page => 1}
    options = default_options.merge options

    pages = Paginator.new self, collection.size, options[:per_page], options[:page]
    first = pages.current.offset
    last = [first + options[:per_page], collection.size].min
    slice = collection[first...last]
    return [pages, slice]
  end
  
  
  # bump sessions to 1 hour from now
  def reset_session_expiry
    ::ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.update(:session_expires => 1.hour.from_now)
  end
  
  # checks that the user has access rights to perform the current action
  def check_accessible
    if current_user
      myaction=Action.find_controller_action(params[:controller], params[:action])
      raise "Page not found" unless !myaction || myaction.accessible(current_user) || Group.find(2).has_user(current_user) # this is a nasty hack to stop errors because there are links to actions accessible only by users.  Need to sort out access management!!
    end
  end
  
  def rescue_action_in_public(exception)
    render :text => "<html><body><p>
FreeMIS is unable to perform this action at present.</p><p>Please contact your FreeMIS administrator if this problem persists.</p>
</body></html>" 
  end 
  
end
