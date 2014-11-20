class Import
  # switch to ActiveModel::Model in Rails 4
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  SALE =        { :name => Activity::SALE[:name] + "s",        :id => Activity::SALE[:id] }
  SHOW =        { :name => Activity::SHOW[:name] + "s",        :id => Activity::SHOW[:id] }
  CONSIGNMENT = { :name => Activity::CONSIGNMENT[:name] + "s", :id => Activity::CONSIGNMENT[:id] }
  GIFT =        { :name => Activity::GIFT[:name] + "s",        :id => Activity::GIFT[:id] }
  DONATION =    { :name => Activity::DONATION[:name] + "s",    :id => Activity::DONATION[:id] }
  PORTFOLIO =   { :name => Activity::PORTFOLIO[:name] + "s",   :id => Activity::PORTFOLIO[:id] }
  LINE_SHEET =  { :name => Activity::LINE_SHEET[:name] + "s",  :id => Activity::LINE_SHEET[:id] }

  ACTIVITY_NAME_ID_HASH = { SALE[:name] => SALE[:id], SHOW[:name] => SHOW[:id], CONSIGNMENT[:name] => CONSIGNMENT[:id], GIFT[:name] => GIFT[:id], DONATION[:name] => DONATION[:id], PORTFOLIO[:name] => PORTFOLIO[:id], LINE_SHEET[:name] => LINE_SHEET[:id] }


  attr_accessor :username, :file, :model
  
  validates :file, presence: true
  validates :model, presence: true

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported.map(&:valid?).all?
      imported.each(&:save!)
      update_workcategory_parents if self.model == "Work categories"
#      add_activityworks if [SALE[:name], SHOW[:name], CONSIGNMENT[:name], GIFT[:name], DONATION[:name], PORTFOLIO[:name], LINE_SHEET[:name]].include?(self.model)
      true
    else
      imported.each_with_index do |record, index|
        record.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported
    @imported ||= load_imported
  end

  def load_imported
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    user = find_user(Hash[[header, spreadsheet.row(2)].transpose])
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      record = case self.model
        when "Work categories"  then load_workcategory(row, user)
        when "Works"            then load_work(row, user)
        when "Venues"           then load_venue(row, user)
        when "Clients"          then load_client(row, user)
#        when SALE[:name], SHOW[:name], CONSIGNMENT[:name], GIFT[:name], DONATION[:name], PORTFOLIO[:name], LINE_SHEET[:name] then load_activity(row,user)
      else 
        raise "Unknown data type"
      end
      record 
    end
  end

  def open_spreadsheet
    tmpfile = Tempfile.new(file.path)
    tmpfile.write(File.read(file.path).encode('utf-8', 'binary', invalid: :replace, undef: :replace, replace: ''))
    tmpfile.rewind
    
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(tmpfile.path, csv_options: {encoding: Encoding::UTF_8})
      when ".xls" then Roo::Excel.new(tmpfile.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(tmpfile.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def update_workcategory_parents
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    user = find_user(Hash[[header, spreadsheet.row(2)].transpose])
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      record = update_workcategory_parent(row,user)
    end
  end

  def add_activityworks
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    user = find_user(Hash[[header, spreadsheet.row(2)].transpose])
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      record = load_activitywork(row,user)
    end
  end

  def find_user(row)
    name = (User.find_by_username(row["username"]) && User.find_by_username(self.username).admin) || self.username
    user = User.find_by_username(name)
    raise "The user #{self.username} does not exist! row[username]: #{row["username"]}User.find_by_username(row[username]: #{User.find_by_username(row[username])} User.find_by_username(self.username).admin: #{User.find_by_username(self.username).admin} " if user.nil?
    user
  end

  def find_work(row,user)
    work = user.works.find_by_inventory_id(row["work"])
    return if work.blank? # errors.add :base, "The work specified for #{row} does not exist. No work was assigned."
    work.id
  end

  def find_client_id(name,user)
    client = user.clients.find_by_name(name)
    id = client.id if ! client.nil? || 0
    id
  end

  def find_venue_id(name,user)
    venue = user.venues.find_by_name(name)
    id = venue.id if ! venue.nil? || 0
    id
  end

  def define_activity_fields(row,user)
    category_id = ACTIVITY_NAME_ID_HASH[self.model]
    if category_id == SALE[:id] || category_id == GIFT[:id]
      client_id = find_client_id(row["client"],user)
    else 
      client_id = user.clients.find_by_name(Client::DEFAULT).id
    end
    if category_id == SHOW[:id] || category_id == DONATION[:id]
      venue_id = find_venue_id(row["venue"],user)
    else
      venue_id = user.venues.find_by_name(Venue::DEFAULT).id
    end 
    [category_id, client_id, venue_id, row["date_start"]]
  end

  def find_activity(user,acvd_array)
    user.activities.where('category_id = ? AND client_id = ? AND venue_id = ? AND date_start = ?', acvd_array[0], acvd_array[1], acvd_array[2], acvd_array[3]).first
  end

  def build_activity(user,acvd_array,date_end)
    record = user.activities.build(:category_id => acvd_array[0], :date_start => acvd_array[3], :date_end => date_end)
    record.assign_attributes(:client_id => acvd_array[1]) if acvd_array[1] != 0
    record.assign_attributes(:venue_id => acvd_array[2]) if acvd_array[2] != 0
    record
  end

  def load_activity(row,user)
    acvd_array = define_activity_fields(row,user)
    record = find_activity(user,acvd_array) || build_activity(user,acvd_array,row["date_end"])
    record
  end

  def load_activitywork(row,user)
    acvd_array = define_activity_fields(row,user)
    activity = find_activity(user,acvd_array)
    if activity.nil?
      errors.add :base, "No activity found for #{acvd_array}."
      return
    else
      activity_id = activity.id
      work_id = find_work(row["work"], user).id || 0
      record = user.activityworks.build(:activity_id => activity_id)
      record.assign_attributes(row.to_hash.slice(*Workcategory.accessible_attributes))
      record.assign_attributes(:work_id => work_id) if work_id != 0
    end
    record
  end

  def load_user(row)
    record = User.find_by_id(row["username"]) || self.username
    record.assign_attributes(row.to_hash.slice(*User.accessible_attributes))
    record
  end

  def load_workcategory(row,user)
    record = user.workcategories.find_by_name(row["name"]) || user.workcategories.build()
    record.assign_attributes(row.to_hash.slice(*Workcategory.accessible_attributes))
    record
  end

  def update_workcategory_parent(row,user)
    record = user.workcategories.find_by_name(row["name"])
    p = row["parent"]
    if !p.blank?
      p = user.workcategories.find_by_name(p)
      if p.blank?
#        errors.add :base, "The parent specified for #{record.name} does not exist. No parent was assigned."
      else
        record.update_attributes(:parent_id => p.id)
      end
    end    
    record
  end

  def add_activitywork(row,user,category_id)
    work_id = find_work(row["work"], user) || 0
    record = user.activities.where('category_id = ? AND client_id = ? AND date_start = ?', category_id, client_id, row["date_start"]).first || user.activities.build()
    record.assign_attributes(row.to_hash.slice(*Activity.accessible_attributes))
    record.assign_attributes(:work_id => work_id) if work_id != 0
    record
  end

  def load_work(row,user)
    record = user.works.find_by_inventory_id(row["inventory_id"]) || user.works.build()
    record.assign_attributes(row.to_hash.slice(*Work.accessible_attributes))
    wc = user.workcategories.find_by_name(row["category"])
    record.assign_attributes(:workcategory_id => wc.id) if ! wc.nil?
    record
  end

  def load_venue(row,user)
    record = user.venues.find_by_name(row["name"]) || user.venues.build()
    record.assign_attributes(row.to_hash.slice(*Venue.accessible_attributes))
    record
  end

  def load_client(row,user)
    record = user.clients.find_by_name(row["name"]) || user.clients.build()
    record.assign_attributes(row.to_hash.slice(*Client.accessible_attributes))
    record
  end

end
