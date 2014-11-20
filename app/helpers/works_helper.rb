module WorksHelper

	def workcategory_name(work)
    workcategory = work.workcategory
    if workcategory.nil? 
    	name = "Uncategorized"
    else 
    	name = workcategory.name
    end
    name
  end

  

end
