module WorkcategoriesHelper

	def parent_name(workcategory)
    parent = current_user.workcategories.find_by_id(workcategory.parent_id)
    if parent.nil? 
      name = "None"
    else 
      name = parent.name
    end
    name
  end

end
