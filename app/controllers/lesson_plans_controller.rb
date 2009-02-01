class LessonPlansController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
  @pupil_set=PupilSet.find(params[:pupil_set_id])
    @lesson_plans = LessonPlan.find(:all, :conditions=>["pupil_set_id=?",params[:pupil_set_id]])
  end

  def show
    @lesson_plan = LessonPlan.find(params[:id])
  end

  def new
    @lesson_plan = LessonPlan.new
    @pupil_set=PupilSet.find(params[:pupil_set_id], :include=>:timetable_periods)
    @lesson_chooser_array=@pupil_set.meetings.collect {|m| [m[:meeting_date].strftime("%a %d %b ") << m[:timetable_slot].name, m[:index]]}
  end

  def create
    @pupil_set=PupilSet.find(params[:pupil_set_id])
    params[:lesson_plan][:pupil_set_id]=@pupil_set.id
    params[:lesson_plan][:timetable_slot_id]=@pupil_set.meetings[params[:lesson_chooser].to_i][:timetable_slot].id
    params[:lesson_plan][:lesson_date]=@pupil_set.meetings[params[:lesson_chooser].to_i][:meeting_date].to_s
    @lesson_plan = LessonPlan.new(params[:lesson_plan])
    if @lesson_plan.save
      flash[:notice] = 'LessonPlan was successfully created.'
      redirect_to :action => 'list'
    else
      @lesson_chooser_array=@pupil_set.meetings.collect {|m| [m[:meeting_date].strftime("%a %d %b ") << m[:timetable_slot].name, m[:index]]}
      render :action => 'new'
    end
  end

  def edit
    @lesson_plan = LessonPlan.find(params[:id])
    @pupil_set=PupilSet.find(params[:pupil_set_id])
    @lesson_chooser_array=@pupil_set.meetings.collect {|m| [m[:meeting_date].strftime("%a %d %b ") << m[:timetable_slot].name, m[:index]]}
  end

  def update
    @lesson_plan = LessonPlan.find(params[:id])
    @pupil_set=PupilSet.find(params[:pupil_set_id])
    params[:lesson_plan][:pupil_set_id]=@pupil_set.id
    params[:lesson_plan][:timetable_slot_id]=@pupil_set.meetings[params[:lesson_chooser].to_i][:timetable_slot].id
    @lesson_chooser_array=@pupil_set.meetings.collect {|m| [m[:meeting_date].strftime("%a %d %b ") << m[:timetable_slot].name, m[:index]]}
    if @lesson_plan.update_attributes(params[:lesson_plan])
      flash[:notice] = 'LessonPlan was successfully updated.'
      redirect_to :action => 'show', :id => @lesson_plan.id
    else
      render :action => 'edit'
    end
  end

  def destroy
    LessonPlan.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
