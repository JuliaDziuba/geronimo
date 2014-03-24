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

  def status(work)
  	if work.available
      "Available"
  	else
  		a = work.activities.first
  		s = a.activitycategory.status
  		if a.activitycategory.final # This piece is sold, gifted, donated or recycled
        if s == 'Sold' || s == 'Gifted'
  			 s + ' to ' + client_name(a)
        elsif s == 'Donated'
          s + ' to ' + a.venue.name
        end
  		elsif s == 'Consigned' # This piece is currently consigned
  			s + ' to ' + a.venue.name
  		else # This piece has been comissioned and is not yet complete
        s + ' by ' + client_name(a)
  		end
  	end
  end

  def status_short(work)
    if work.available
      "Available"
    else
      a = work.activities.first
      s = a.activitycategory.status
      s
    end
  end

end
