class TimetableSlotsController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @timetable_slot_pages, @timetable_slots = paginate :timetable_slots, :per_page => 10
  end

  def show
    @timetable_slot = TimetableSlot.find(params[:id])
  end

  def new
    @timetable_slot = TimetableSlot.new
  end

  def create
    params[:timetable_slot][:start_time]=params[:timetable_slot][:start_time][:hour].to_s + ":" + params[:timetable_slot][:start_time][:minute].to_s
    params[:timetable_slot][:end_time]=params[:timetable_slot][:end_time][:hour].to_s + ":" + params[:timetable_slot][:end_time][:minute].to_s
    @timetable_slot = TimetableSlot.new(params[:timetable_slot])
    if @timetable_slot.save
      flash[:notice] = 'TimetableSlot was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @timetable_slot = TimetableSlot.find(params[:id])
  end

  def update
    @timetable_slot = TimetableSlot.find(params[:id])
    params[:timetable_slot][:start_time]=params[:timetable_slot][:start_time][:hour].to_s + ":" + params[:timetable_slot][:start_time][:minute].to_s
    params[:timetable_slot][:end_time]=params[:timetable_slot][:end_time][:hour].to_s + ":" + params[:timetable_slot][:end_time][:minute].to_s
    if @timetable_slot.update_attributes(params[:timetable_slot])
      flash[:notice] = 'TimetableSlot was successfully updated.'
      redirect_to :action => 'show', :id => @timetable_slot
    else
      render :action => 'edit'
    end
  end

  def destroy
    TimetableSlot.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
