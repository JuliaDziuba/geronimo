module ActivitycategoriesHelper

	def consignment_id=(id)
    @consignment_id = id
  end

  def consignment_id
    @consignment_id ||= (Activitycategory.find_by_name('Consignment') || 0 )
  end

  def sale_id=(id)
    @sale_id = id
  end

  def sale_id
    @sale_id ||= (Activitycategory.find_by_name('Sale') || 0 )
  end


end
