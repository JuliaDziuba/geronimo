module ActionsHelper
	def getNameOfActionableId(type, id)
		if type == 'User'
			name = "to self"
		elsif type == 'Work'
			name = "#{ current_user.works.find(id).title } (#{ current_user.works.find(id).inventory_id })"
		elsif type == 'Venue'
			name = current_user.venues.find(id).name
		elsif type == 'Client'
			name = current_user.clients.find(id).name
		end
		name
	end

	def getNameOfActionableType(type)
		if type == 'User'
			name = "General note"
		else
			name = type
		end
		name
	end
end
