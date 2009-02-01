class GradebookController < ApplicationController
  before_filter :login_required
  layout "blank"
  def index
    @pupil_set=PupilSet.find(params[:id]) if params[:id]
    @pupils=@pupil_set.pupils
    if params[:assessment_id]
      if @pupils.inject(0){|sum,p| sum + (p.gradebook_scores.find_by_gradebook_assessment_id(params[:assessment_id]).score.to_i rescue 0)}==0
        @pupils=@pupils.sort_by {|p| p.gradebook_scores.find_by_gradebook_assessment_id(params[:assessment_id]).score rescue "" } 
      else
        @pupils=@pupils.sort_by {|p| p.gradebook_scores.find_by_gradebook_assessment_id(params[:assessment_id]).score.to_i rescue nil } 
      end
      @pupils.reverse! if params[:order]=="descending"
    end
  end
  
  def show_column_form
    @pupil_set=PupilSet.find(params[:pupil_set_id])
    @assessment=GradebookAssessment.find(params[:id])
    render :partial=>"show_column_form"    
  end
  
  def edit_column
    @pupil_set=PupilSet.find(params[:id])
    @pupils=@pupil_set.pupils
    @assessment=GradebookAssessment.find(params[:assessment_id])
    params[:pupils].each do |key,value|
      pupil=Pupil.find(key)
      element=pupil.gradebook_scores.find_or_create_by_gradebook_assessment_id(params[:assessment_id])
      element.score= value[:score]
      element.save
    end
    render :partial=>"show_table"
  end
  
  def show_grade_assessment_form
    @pupil_set=PupilSet.find(params[:id])
    render :partial=>"show_assessment_form"
  end
  
  def new_grade_assessment
    @pupil_set=PupilSet.find(params[:id])
    @gradebook_assessments = GradebookAssessment.new(params[:gradebook_assessments])
    if @gradebook_assessments.save
       flash[:notice] = 'New assessment was successfully created.'
      render :text=>"<script> document.location.href = '" << url_for( :controller=> "gradebook", :id=> @pupil_set) << "';</script>"        
    else
      render :partial=>"show_assessment_form"
    end
  end
  
  def delete_grade_assessment
    GradebookAssessment.find(params[:ass_id]).destroy
    redirect_to :action=>"index", :id=>params[:id]
  end

end
