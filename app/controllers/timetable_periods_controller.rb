class TimetablePeriodsController < ApplicationController
  before_filter :login_required
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @timetable_period_pages, @timetable_periods = paginate :timetable_periods, :per_page => 50
  end

  def show
    @timetable_period = TimetablePeriod.find(params[:id])
  end

  def new
    @timetable_period = TimetablePeriod.new
  end

  def create
    @timetable_period = TimetablePeriod.new(params[:timetable_period])
    if @timetable_period.save
      flash[:notice] = 'TimetablePeriod was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @timetable_period = TimetablePeriod.find(params[:id])
  end

  def update
    @timetable_period = TimetablePeriod.find(params[:id])
    if @timetable_period.update_attributes(params[:timetable_period])
      flash[:notice] = 'TimetablePeriod was successfully updated.'
      redirect_to :action => 'show', :id => @timetable_period
    else
      render :action => 'edit'
    end
  end

  def destroy
    TimetablePeriod.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
