module ActivitiesHelper



	def client_name(activity)
    client = activity.client
    if client.nil? 
    	name = "Unknown"
    else 
    	name = client.name
    end
    name
  end
  
end
