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
module UserSystem
  CONFIG = {
    # Source address for user emails
    :email_from => 'admin@freemis.net',

    # Destination email for system errors
    :admin_email => 'admin@freemis.net',

    # Sent in emails to users
    :app_url => 'http://www.freemis.net/',

    # Sent in emails to users
    :app_name => 'FreeMIS',

    # Email charset
    :mail_charset => 'utf-8',

    # Security token lifetime in hours
    :security_token_life_hours => 24,

    # Two column form input
    :two_column_input => true,

    # Add all changeable user fields to this array.
    # They will then be able to be edited from the edit action. You
    # should NOT include the email field in this array.
    :changeable_fields => ['title', 'firstname', 'lastname', 'email' ],

    # Set to true to allow delayed deletes (i.e., delete of record
    # doesn't happen immediately after user selects delete account,
    # but rather after some expiration of time to allow this action
    # to be reverted).
    :delayed_delete => false,

    # Default is one week
    :delayed_delete_days => 7,

    # Server environment
    :server_env => "#{RAILS_ENV}"
  }
end
