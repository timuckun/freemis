class TimetableController < ApplicationController
  before_filter :login_required
  
  def index
    weekly_view
    render :action => 'weekly_view'
  end
  
  def weekly_view
    @color_scheme=0
    @colors={} # this is where the set_code=>color pairs are stored
    @slots=TimetableSlot.find(:all, :order=>"start_time")
    @days=TimetableDay.find(:all, :order =>"id")
    @view_array=[]
    @days.each do |d|
      @view_array[d.id]=[]
      d.timetable_slots.each do |s| 
        @view_array[d.id][s.id]=[]
      end
    end
    current_user.current_pupil_sets.each do |ps|
      @color_scheme +=1
      @colors[ps.set_code]= "set" + @color_scheme.to_s
      ps.lessons.each do |l|
        @view_array[l.timetable_period.timetable_day_id][l.timetable_period.timetable_slot_id].push(ps) if  l.teachers.include?(current_user)
      end
    end
#    @days.each do |d|
#      @view_array[d.id]=[]
#      @slots.each do |s|
#        if d.timetable_period_for_slot(s.id)
#          tp=d.timetable_period_for_slot(s.id)
#          if pupil_set=tp.pupil_sets.detect{|ps| current_user.current_pupil_sets.detect{|ms| ms.id==ps.id}}
#            @view_array[d.id][s.id]=pupil_set
#            @color_scheme +=1
#            @colors[pupil_set.set_code]||= "set" + @color_scheme.to_s
#          else
#            @view_array[d.id][s.id]=" "
#          end
#        end
#      end
#    end
  end
end