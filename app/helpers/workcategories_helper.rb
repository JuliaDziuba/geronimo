module WorkcategoriesHelper

	def parent_name(workcategory)
    parent = User.find_by_username(params[:user]).workcategories.find_by_id(workcategory.parent_id)
    if parent.nil? 
      name = "None"
    else 
      name = parent.name
    end
    name
  end

end
