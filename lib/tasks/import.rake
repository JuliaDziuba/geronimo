# TO run:
#bin/rake import:csv_workcategories[C:/Users/Julia/Desktop/database/workcategory.csv]

namespace :import do

#	task :all => environment do |task|
	#	csv_users["C:/Users/Julia/Desktop/database/users.csv"]
	#   csv_workcategories["C:/Users/Julia/Desktop/database/workcategories.csv"]
	#	csv_works["C:/Users/Julia/Desktop/database/works.csv"]
#	end

  	task :csv_users, [:filename] => :environment  do |task,args|
	  filename = args[:filename]
	  CSV.foreach(filename, headers: true) do |row|
	  	user = User.find_by_id(row["id"]) || User.new
	  	user.update_attributes(row.to_hash.slice(*User.accessible_attributes))
	  	user.save!
	  end
	end

  	task :csv_workcategories, [:filename] => :environment  do |task,args|
  	  filename = args[:filename]
	  CSV.foreach(filename, headers: true) do |row|
	  	user = User.find_by_username(row["username"])
	  	if user.nil?
	  		raise "The user does not exist!"
	  	else
		  	wc = user.workcategories.find_by_id(row["id"]) || user.workcategories.build()
		  	wc.update_attributes(row.to_hash.slice(*Workcategory.accessible_attributes))
		  	parent = user.workcategories.find_by_name(row["parent"])
		  	if parent.nil?
		  		puts "The parent specified for #{wc.name} does not exist. No parent was assigned."
		  	else
		  		wc.update_attributes(:parent_id => parent.id)
		  	end
		  	wc.save!
		  end
	  end
	end

	task :csv_works, [:filename] => :environment  do |task,args|
  	  filename = args[:filename]
	  CSV.foreach(filename, headers: true) do |row|
	  	user = User.find_by_username(row["username"])
	  	if user.nil?
	  		raise "The user does not exist!"
	  	else
		  	record = user.works.find_by_id(row["id"]) || user.works.build()
		  	record.update_attributes(row.to_hash.slice(*Work.accessible_attributes))
		  	wc = user.workcategories.find_by_name(row["workcategory"])
		  	if wc.nil?
		  		puts "The workcategory specified for #{record.name} does not exist. No category was assigned."
		  	else
		  		record.update_attributes(:workcategory_id => wc.id)
		  	end
#		  	record.update_attributes(:image1 => row["image_path"])
		  	record.save!
		  end
	  end
	end

	task :csv_venues, [:filename] => :environment  do |task,args|
  	  filename = args[:filename]
  	#  CSV.file_contents.encode!('UTF-8', 'UTF-8', :invalid => :replace)
	  CSV.foreach(filename, headers: true) do |row|
	  	user = User.find_by_username(row["username"])
	  	if user.nil?
	  		raise "The user does not exist!"
	  	else
		  	record = user.venues.find_by_id(row["id"]) || user.venues.build()
		  	record.update_attributes(row.to_hash.slice(*Venue.accessible_attributes))
		  	vc = Venuecategory.find_by_name(row["venuecategory"])
		  	if vc.nil?
		  		puts "The venuecategory specified for #{record.name} does not exist. No category was assigned."
		  	else
		  		record.update_attributes(:venuecategory_id => vc.id)
		  	end
		  	record.save!
		  end
	  end
	end

	task :csv_clients, [:filename] => :environment  do |task,args|
  	  filename = args[:filename]
	  CSV.foreach(filename, headers: true) do |row|
	  	user = User.find_by_username(row["username"])
	  	if user.nil?
	  		raise "The user does not exist!"
	  	else
		  	record = user.clients.find_by_id(row["id"]) || user.clients.build()
		  	record.update_attributes(row.to_hash.slice(*Client.accessible_attributes))
		  	record.save!
		  end
	  end
	end

	task :csv_activities, [:filename] => :environment do |task,args|
		filename = args[:filename]
		CSV.foreach(filename, headers: true) do |row|
			user = User.find_by_username(row["username"])
	  	if user.nil?
	  		raise "The user does not exist!"
	  	else
				record = user.activities.find_by_id(row["id"]) || user.activities.build()
		    record.update_attributes(row.to_hash.slice(*Activity.accessible_attributes))
		    ac = row["category"]
		    if !ac.nil?
			    ac = Activitycategory.find_by_name(ac)
			    if ac.nil?
			      puts "The activity category specified for #{row} does not exist."
			    else
			      record.update_attributes(:activitycategory_id => ac.id)
			    end
			  end
		    w = row["work"]
		    if !w.nil?
		    	w = user.works.find_by_inventory_id(w)
			    if w.nil?
			      puts "The work specified for #{row} does not exist. No work was assigned."
			    else
			      record.update_attributes(:work_id => w.id)
			    end
			  end
		    v = row["venue"]
		    if !v.nil?
		    	v = user.venues.find_by_name(v)
			    if v.nil?
			      puts "The venue specified for #{row} does not exist. No venue was assigned."
			    else
			      record.update_attributes(:venue_id => v.id)
			    end
			  end
		    c = row["client"]
		    if !c.nil?
		    	c = user.clients.find_by_name(c)
		    	if c.nil?
			      puts "The client specified for #{row} does not exist. No client was assigned."
			    else
			      record.update_attributes(:client_id => c.id)
			    end
			  end		    
		    record.save!
			end
		end
	end

end