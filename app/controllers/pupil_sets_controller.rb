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
class PupilSetsController < ApplicationController
  layout "application"
  before_filter :login_required
  def index
    user_list
    render :action => 'user_list'
  end

  def user_list
    @pupil_sets = current_user.current_pupil_sets
  end

  def user_show
    @pupil_set = PupilSet.find(params[:id])
  end

  def show
    @pupil_set = PupilSet.find(params[:id])
  end
  
  def user_claim
    @sets=PupilSet.find(:all, :conditions=>["school_session_id=?",SchoolSession.current.id])
    current_user.current_pupil_sets.each { |s| @sets.delete(s) } if current_user.current_pupil_sets
    @sets.collect! {|s| [s.set_code,s.id] }
    @sets=@sets.sort_by { |a| a.first}
    if params[:pupil_set]
      @pupil_set=PupilSet.find(params[:pupil_set]["id"])
      flash[:notice]="You are now listed as a teacher of #{@pupil_set.set_code}" if @pupil_set.add(current_user)
      current_user.reload
      redirect_to :action=>"user_list"
    end
  end

  def user_add_pupils
    @pupil_set = PupilSet.find(params[:id])
    if params[:pupil_id]
      @pupil=Pupil.find(params[:pupil_id])
      flash.now[:notice]="#{@pupil.full_name} is now a member of #{@pupil_set.set_code}" if @pupil.add_to_set(@pupil_set)
    end
    @pupil_set.reload
    @pupils=@pupil_set.academic_year.pupils-@pupil_set.pupils
  end

  def user_remove_pupils
    @pupil_set = PupilSet.find(params[:id])
    if params[:pupil_id]
      pupil_to_drop=Pupil.find(params[:pupil_id])
      pupil_to_drop.remove_from_set(@pupil_set)
      flash.now[:notice]="#{pupil_to_drop.full_name} has been successfully remove from this set."
    end
  end

  # removes the current user as a teacher of the pupil_set
  def drop
   @pupil_set=PupilSet.find(params[:id])
   @pupil_set.drop(current_user)
   current_user.reload
   flash[:notice] = 'Set Dropped'
   redirect_to :action => 'user_list'
  end

  def new
    @pupil_set = PupilSet.new
  end

  def create
  
    # set the school_session to be the current one
    set_params=params[:pupil_set]
    set_params["school_session_id"]=SchoolSession.current.id
    
    # then create the new pupil_set
    @pupil_set = PupilSet.new(set_params)
    if @pupil_set.save
      flash[:notice] = "#{@pupil_set.set_code} was successfully created."
      redirect_to :action => 'show', :id=>@pupil_set
    else
      render :action => 'new'
    end
  end

  def edit
    if params[:id]
      @pupil_set = PupilSet.find(params[:id])
      @pupils=@pupil_set.academic_year.pupils-@pupil_set.pupils
      @slots=TimetableSlot.find(:all, :order=>"start_time")
      @days=TimetableDay.find(:all, :order =>"id")
      @view_array=[]
      @days.each do |d|
      @view_array[d.id]=[]
         d.timetable_slots.each {|s| @view_array[d.id][s.id]=[]}
      end
      @pupil_set.lessons.each do |l|
        @view_array[l.timetable_period.timetable_day_id][l.timetable_period.timetable_slot_id]=l
      end
    else 
      @pupil_sets=SchoolSession.current.pupil_sets
    end
  end

  def update
    @pupil_set = PupilSet.find(params[:id])
    if @pupil_set.update_attributes(params[:pupil_set])
      flash[:notice] = 'PupilSet was successfully updated.'
    end
    redirect_to :action => 'edit', :id=>params[:id]
  end

  def update_timetable
    @pupil_set=PupilSet.find(params[:id])
    # params[:lessons] stores the existing lessons, so we run through lessons to see if they should still
    # exist, and which teachers teach them
    @pupil_set.lessons.each do |lesson|
      if (params[:lessons][lesson.id.to_s] rescue nil)
         lesson.users.clear
         params[:lessons][lesson.id.to_s].each do |user_id,flag|
           lesson.users << User.find(user_id.to_i)
         end
         lesson.save
      else
         lesson.destroy
      end
    end
    if params[:tt_array] # params[:tt_array] has new lessons in it.  We deal with the addition of these next
      params[:tt_array].each do |day,slots|
        slots.each do |slot,flag|
        @timetable_period=TimetablePeriod.find_by_sql("select * from timetable_periods where timetable_day_id=#{day} and timetable_slot_id=#{slot}").first
        @lesson=Lesson.create(:pupil_set => @pupil_set,
                              :timetable_period => @timetable_period)
        end 
      end
    end
    redirect_to :action => 'edit', :id=>params[:id]
  end
  
  def update_users
    @pupil_set=PupilSet.find(params[:id])
    @pupil_set.users.each do |user|
        @pupil_set.drop(user) unless params[:users] && params[:users].has_key?(user.id.to_s)
        @changed=true
    end
    if params[:user_id] && params[:user_id]!=""
      @pupil_set.add(User.find(params[:user_id]))
      @changed=true
    end
    flash[:notice] = "Teacher details successfully edited." if @changed
    redirect_to :action => 'edit', :id=>params[:id]
  end

def update_pupils
    @pupil_set=PupilSet.find(params[:id])
    @pupil_set.pupils.each do |pupil|
        pupil.remove_from_set(@pupil_set) unless params[:pupils] && params[:pupils].has_key?(pupil.id.to_s)
        @changed=true
    end
    if params[:pupil][:id] && params[:pupil][:id]!=""
      Pupil.find(params[:pupil][:id]).add_to_set(@pupil_set)
      @changed=true
    end
    flash[:notice] = "Pupil enrollments edited." if @changed
    redirect_to :action => 'edit', :id=>params[:id]
  end

  def destroy
    PupilSet.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
end
