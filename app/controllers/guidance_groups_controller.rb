class GuidanceGroupsController < ApplicationController
  # GET /guidance_groups
  # GET /guidance_groups.xml
  def index
    @guidance_groups = GuidanceGroup.find(:all, :order=>"code ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @guidance_groups }
    end
  end

  # GET /guidance_groups/1
  # GET /guidance_groups/1.xml
  def show
    @guidance_group = GuidanceGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @guidance_group }
    end
  end

  # GET /guidance_groups/new
  # GET /guidance_groups/new.xml
  def new
    @guidance_group = GuidanceGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @guidance_group }
    end
  end

  # GET /guidance_groups/1/edit
  def edit
    @guidance_group = GuidanceGroup.find(params[:id])
    @guidance_teachers=Group.find(4).users
  end

  # POST /guidance_groups
  # POST /guidance_groups.xml
  def create
    @guidance_group = GuidanceGroup.new(params[:guidance_group])

    respond_to do |format|
      if @guidance_group.save
        flash[:notice] = 'GuidanceGroup was successfully created.'
        format.html { redirect_to(@guidance_group) }
        format.xml  { render :xml => @guidance_group, :status => :created, :location => @guidance_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @guidance_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /guidance_groups/1
  # PUT /guidance_groups/1.xml
  def update
    @guidance_group = GuidanceGroup.find(params[:id])
    params[:guidance_group][:user_ids] ||= []

    respond_to do |format|
      if @guidance_group.update_attributes(params[:guidance_group])
        flash[:notice] = 'GuidanceGroup was successfully updated.'
        format.html { redirect_to(@guidance_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @guidance_group.errors, :status => :unprocessable_entity }
      end
    end
  end

end
