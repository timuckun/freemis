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
class SpellController < ApplicationController
  require 'raspell'
  before_filter :login_required
  def edit_text
  #apply corrections
  if session[:body] && session[:replacements] && (session[:replacements].size > 0)
    aspell = Aspell.new("en_GB")
    count = 0
    @body = aspell.correct_lines(session[:body]) do |misspelled|
      count = count + 1
      session[:replacements][count]
    end
    session[:replacements] = { }
    session[:body] = @body
  else
    @body = session[:body];
  end
  @body.join($/) if @body
  session[:body]=@body
  redirect_to :controller=>params[:return_controller], :action=>params[:return_action], :params=>params[:return_params]
  end


  def check_spelling
    @aspell = Aspell.new("en_GB")
    if params[:body]
      session[:body] = params[:body].split($/)
      #don't worry about this for now ...
      session[:replacements] = { }
    end
  end

  def suggest
    @aspell = Aspell.new("en_GB")
    render( :partial => 'suggest_item',
            :collection => @aspell.suggest(params[:id]),
            :locals => {:word_count => params[:word_count]})
  end

  def replace
    ndx = params[:id].to_i
    session[:replacements][ndx] = params[:with]
    render :text => params[:with]
end

end
