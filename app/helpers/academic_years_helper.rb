module AcademicYearsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    AcademicYear.scaffold_columns
  end

end
