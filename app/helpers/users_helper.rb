module UsersHelper

  def soldWithin(works, date)
    works.select{ |w| w["sale_date"] > date}
  end

	def mapToCompactArray(works,key)
	  works.map{ |w| w[key] }.compact || []
	end

	def mapToCompactProfitArray(works)
	  array = works.map do |w| 
	  	if w['income'].nil? || w['expense_materials'].nil?
	  		nil
	  	else
	  		w['income'] - w['expense_materials']
	  	end
	  end
	  	array.compact || []
	end

	def mapToCompactWageArray(works)
	  array = works.map do |w| 
	  	if w['income'].nil? || w['expense_materials'].nil? || w['expense_hours'].nil?
	  		nil
	  	else
	  		(w['income'] - w['expense_materials'])/ w['expense_hours']
	  	end
	  end
	  	array.compact || []
	end

	def sumAndCountNonNilKeys(works,key)
		if key == 'profit'
			compactArray = mapToCompactProfitArray(works)
		else
			compactArray = mapToCompactArray(works,key)
		end
		count = compactArray.count
		if count > 0
			"#{ compactArray.sum.round(2) } (#{ count })"
		else 
			"--"
		end
	end

	def averageAndCountNonNilKeys(works,key)
		if key == 'profit'
			compactArray = mapToCompactProfitArray(works)
		elsif key == 'wage'
			compactArray = mapToCompactWageArray(works)
		else
			compactArray = mapToCompactArray(works,key)
		end
		count = compactArray.count
		if count > 0
			"#{ (compactArray.sum/count).round(2) } (#{ count })"
		else 
			"--"
		end
	end

	def reportChange(outcomeX, outcomeY)
		outcomeX = outcomeX.to_f()
		outcomeY = outcomeY.to_f()
		if outcomeX == 0 || outcomeY == 0
			change = "--"
		elsif outcomeX == outcomeY
			change = "+ 0%"
		else
			if outcomeX > outcomeY
				change = "+ #{ number_to_percentage((100 * (outcomeX - outcomeY)/outcomeY), precision: 0) }"
			else
				change = "- #{ number_to_percentage(100 * (1-(outcomeX/outcomeY)), precision: 0) }"
			end
		end
		change
	end 

end
