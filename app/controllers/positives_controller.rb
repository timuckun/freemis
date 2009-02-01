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
class PositivesController < ApplicationController
  before_filter :login_required
  layout "application", :except=>:print
  
  def index
    classpos
    render :action => 'classpos'
  end

  def list_for_pupil_in_class
    if params[:setlink]
      @setlink=Setlink.find(params[:setlink])
    else
      redirect_to :action=>'index'
    end
  end

  # shows a form to write a class based positive referral
  def classpos
    if params[:pupil_set]
     @pupil_set=PupilSet.find(params[:pupil_set]) 
     @setlinks=@pupil_set.setlinks.sort_by{|s| s.pupil.surname}
    end
  end

  def adhoc
    if params[:pupil_name]
      @pupils = Pupil.search( params[:pupil_name].split.collect{ |c| "%#{c.downcase}%" } )
      if @pupils.length > 0
        @pupils
      else
        @pupils=nil
        flash['notice']='No pupils matched your search criteria.  Please try again'
      end
      #search for the pupil and return an array of pupil objects
      # the view will handle the displaying of the search form and the results
    end
    if params[:id]
      @pupil=Pupil.find(params[:id])
    end
    if params[:commit]=="Create"
      @positive = Positive.new(params[:positive])
      @positive.user_id=current_user.id
      @positive.pupil_id=@pupil.id
      if @positive.save
        flash.now[:notice] = 'Positive was successfully created.'
      end
    end
  end

  def show
    @positive = Positive.find(params[:id])
  end

  def new
    if params[:setlink]
      @positive = Positive.new
      @setlink=Setlink.find(params[:setlink])
    else
      redirect_to :action=>'index'
    end
  end

  def create
    @positive = Positive.new(params[:positive])
    if @positive.save
      flash[:notice] = 'Positive was successfully created.'
      redirect_to :action => 'classpos', :pupil_set=>params[:pupil_set_id].to_i
    else
       render_component :controller => "positives",  :action => "new", :params => { "setlink" => @setlink, "positive"=>@positive }
    end
  end

  def edit
    @positive = Positive.find(params[:id])
  end

  def update
    @positive = Positive.find(params[:id])
    if @positive.update_attributes(params[:positive])
      flash[:notice] = 'Positive was successfully edited.'
    end
    redirect_to :action => 'classpos', :pupil_set => @positive.setlink.pupil_set.id, :newsetlink =>params[:newsetlink].to_i

  end

  def destroy
    p=Positive.find(params[:id])
    pupil_set=p.setlink.pupil_set
    p.destroy
    flash[:notice] = 'Positive was successfully destroyed.'
    redirect_to :action => 'classpos', :pupil_set =>pupil_set
  end

  def print
       if !params[:print_date] && !params[:day]
       	@days_array=[]
        20.times do |i|
	  @days_array << i.days.ago
       end
        render(:partial=>"pos_print_setup", :layout=>"application")
       else
        if params[:day]
	  @today=Time.at(params[:day].to_i).at_beginning_of_day
	else
          year=params[:print_date]["value(1i)"]
          @today=Time.local(params[:print_date]["value(1i)"],params[:print_date]["value(2i)"],params[:print_date]["value(3i)"])
	end
        @tomorrow=@today+86400
        @positives=Positive.find(:all, :conditions=>"updated_at >= #{@today.to_i} AND updated_at <= #{@tomorrow.to_i}")
        if @positives.length>0
        render :action=>"print", :layout=>"print_positives"
        else
          render(:text=>"No Positive Referral were written on #{@today.strftime("%d/%m/%Y")}")
        end
       end
  end

  def printSingle
      @positive=Positive.find(params[:id])
      render(:partial=>"print_one", :layout=>"print_positives", :locals=>{:print_one=>@positive})
  end

end
