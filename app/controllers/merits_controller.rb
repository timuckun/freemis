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
class MeritsController < ApplicationController
  before_filter :login_required
  def award
    if params[:pupil_set]
      @pupil_set=PupilSet.find(params[:pupil_set])
      @setlinks=@pupil_set.setlinks_sorted_by_pupil
    end
  end

  def processor
    @setlink=Setlink.find(params[:setlink])
    if @merit=@setlink.merit
      @merit.destroy
    else
      @setlink.create_merit({:pupil_id=>@setlink.pupil_id})
    end
    @setlinks=@setlink.pupil_set.setlinks_sorted_by_pupil
    render :partial=>"form"
  end


## admin functions

  def set_cutoffs
    @academic_years=AcademicYear.find(:all).select {|a| a.merit_cutoffs.length>0}
    
  end

  def update_cutoffs
    for merit_cutoff in MeritCutoff.find(:all)
      merit_cutoff.update_attributes(params[:cutoffs][merit_cutoff.id.to_s])
    end
    flash[:notice]="Cutoffs Updated"
    redirect_to :action=>"set_cutoffs"
  end

  ## aesthetically speaking, this should use the pupil.merit_award method, that returns
  ## which level of merit a paricular pupil has earned, but using that method here is very slow.
  def merit_summary
    @academic_years=AcademicYear.find(:all).select {|a| a.merit_cutoffs.length>0}
    @summary=Hash.new
    @academic_years.each do |this_year|
      gold_cutoff=this_year.merit_cutoffs.detect{|c| c.level=="gold"}.cutoff
      silver_cutoff=this_year.merit_cutoffs.detect{|c| c.level=="silver"}.cutoff
      bronze_cutoff=this_year.merit_cutoffs.detect{|c| c.level=="bronze"}.cutoff
      @summary[this_year.name]={"gold"=>nil, "silver"=>nil, "bronze"=>nil, "none"=>nil}
      @summary[this_year.name]["gold"]=this_year.pupils.select{|p| p.merits.size>=gold_cutoff}.length  
       @summary[this_year.name]["silver"]=this_year.pupils.select{|p| p.merits.size>=silver_cutoff && p.merits.size<gold_cutoff}.length 
       @summary[this_year.name]["bronze"]=this_year.pupils.select{|p| p.merits.size>=bronze_cutoff && p.merits.size<silver_cutoff}.length 
      @summary[this_year.name]["none"]=this_year.pupils.select{|p| p.merits.size<bronze_cutoff}.length 
    end
    render(:layout=>false)
  end

  def print_merits
    if params[:academic_year_id] &&params[:academic_year_id]!="" && params[:level]
      @academic_year=AcademicYear.find(params[:academic_year_id])
      @pupils=@academic_year.pupils.select{|p| p.merit_award==params[:level]}
      render(:layout=>"print_merits")
    end
  end
end
