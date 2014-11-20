module UsersHelper

	def cleanUpMoney(amount)
		if amount.nil?
			amount
		else
			amount.to_i == amount ? amount.to_i : sprintf('%.2f',  amount.round(2))
		end
	end

  def status_full(work)
  	if work.quantity > 0 
  		status = "Available"
  	else
  		as = work.activityworks.where("activity_id in (?)", work.user.activities.current(Date.today).all.map(&:id))
  		if as.count > 0
  			status = "Available at"
  			as.each_with_index do | a, i |
  				name = a.activity.venue.name
  				if i == 0
  					status = status + " " + name
  				elsif i == as.length - 1
  					status = status + ", and " + name
  				else 
  					status = status + ", " + name
  				end
  			end
  		else
  			status = ""
  		end
  	end
  	status
  end

  def soldSince(works, date)
    works.select{ |w| w["sale_date"] > date }
  end

  def countQuantity(works)
  	works.map{ | w | w['sold'] || 0 }.sum || 0
  end

	def mapToCompactArray(works,key)
	  works.map{ |w| (w[key] || 0) * (w['sold'] || 0) }.compact || []
	end

	def mapToCompactProfitArray(works)
	  array = works.map do |w| 
	  	w['income'] = 0 if w['income'].nil?
	  	w['expense_materials'] = 0 if w['expense_materials'].nil?
	  	(w['income'] - w['expense_materials'])*(w['sold'] || 0)
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
			count = countQuantity(works)
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

	def bestOfSales(hoaa, outcome)
    highest_array = []
    highest_string = ""
    highest_value = 0
    hoaa.each do | key, value |
      v = 0
      if outcome == 'count'
        value.last.each do | w |
          v = v + (w['sold'] || 0)
        end 
      elsif outcome == "income"
        value.last.each do | w |
          v = v + w['income'] * (w['sold'] || 0)
        end
      end
      if v == highest_value && key != Client::DEFAULT then 
        highest_array << key
      elsif v > highest_value && key != Client::DEFAULT then 
        highest_array = []
        highest_array << key
        highest_value = v
      end
    end
    if highest_array.count == 1
    	highest_string = highest_array[0]
    else 
    	highest_array.each_with_index do | h, i |
    		if i == highest_array.count - 1
    			highest_string = highest_string + ", and " + h
    		elsif i == 0
    			highest_string = h 
    		else
    			highest_string = highest_string + ", " + h
    		end
    	end
    end
    highest_string = highest_string.sub("My", "your")
    highest_string = "<<CANNOT BE CALCULATED>>" if highest_string.nil?
    highest_string
  end
end