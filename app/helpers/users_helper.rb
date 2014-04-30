module UsersHelper

	def cleanUpMoney(amount)
		if amount.nil?
			amount
		else
			amount.to_i == amount ? amount.to_i : sprintf('%.2f',  amount.round(2))
		end
	end

  def soldSince(works, date)
    works.select{ |w| w["sale_date"] > date}
  end

	def mapToCompactArray(works,key)
	  works.map{ |w| w[key] || 0 }.compact || []
	end

	def mapToCompactProfitArray(works)
	  array = works.map do |w| 
	  	w['income'] = 0 if w['income'].nil?
	  	w['expense_materials'] = 0 if w['expense_materials'].nil?
	  	w['income'] - w['expense_materials']
	  end
	  	array.compact || []
	end

	def mapToCompactWageArray(works)
	  array = works.map do |w| 
	  	w['income'] = 0 if w['income'].nil?
	  	w['expense_materials'] = 0 if w['expense_materials'].nil?
	  	if w['expense_hours'].nil?
	  		nil
	  	else
	  		(w['income'] - w['expense_materials'])/ w['expense_hours']
	  	end
	  end
	  	array.compact || []
	end

	def sumKeys(works,key)
		if key == 'profit'
			compactArray = mapToCompactProfitArray(works)
		else
			compactArray = mapToCompactArray(works,key)
		end
		count = compactArray.count
		if count > 0
			"#{ compactArray.sum.round(2) }"
		else 
			"0"
		end
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
			"0"
		end
	end

	def averageKeys(works,key)
		result = "0"
		if  key == 'wage'
			profitSum = mapToCompactProfitArray(works).sum
			hoursSum = mapToCompactArray(works,'expense_hours').sum
			result = (profitSum/hoursSum).round(2) if hoursSum > 0
		else
			if key == 'profit'
				compactArray = mapToCompactProfitArray(works)
			else
				compactArray = mapToCompactArray(works,key)
			end
			count = compactArray.count
			result = "#{(compactArray.sum/count).round(2)}" if count > 0
		end
		result
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
			"0"
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

	def image_alt_description(user, work)
		description = "Work titled #{work.title} by #{user.name}"
		description += " and created with #{work.materials}" if user.share_works_materials
		description += "."
		description += " #{work.description}" if user.share_works_description
		description
	end

end
