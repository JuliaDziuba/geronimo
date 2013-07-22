class Import
  # switch to ActiveModel::Model in Rails 4
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file, :model

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
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      if self.model == "Users"
        record = load_user(row)
      else
        user = find_user(row)
        record = case self.model
            when "Work categories"  then load_workcategory(row, user)
            when "Works"            then load_work(row, user)
            when "Venues"           then load_venue(row, user)
            when "Clients"          then load_client(row, user)
            when "Activities"       then load_activity(row, user)
          else 
            raise "Unknown data type"
          end
        end
        record 
    end
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def load_user(row)
    record = User.find_by_id(row["id"]) || User.new
    record.assign_attributes(row.to_hash.slice(*User.accessible_attributes))
    record
  end

  def find_user(row)
    user = User.find_by_username(row["username"])
    raise "The user does not exist!" if user.nil?
    user
  end

  def load_workcategory(row,user)
    record = user.workcategories.find_by_id(row["id"]) || user.workcategories.build()
    record.assign_attributes(row.to_hash.slice(*Workcategory.accessible_attributes))
    p = row["parent"]
    if !p.blank?
      p = user.workcategories.find_by_name(p)
      if p.blank?
#        errors.add :base, "The parent specified for #{record.name} does not exist. No parent was assigned."
      else
        record.assign_attributes(:parent_id => p.id)
      end
    end    
    record
  end

  def load_work(row,user)
    record = user.works.find_by_id(row["id"]) || user.works.build()
    record.assign_attributes(row.to_hash.slice(*Work.accessible_attributes))
    wc = user.workcategories.find_by_name(row["category"])
    if wc.nil?
#      errors.add :base, "The work category specified for #{record.name} does not exist. No category was assigned."
    else
      record.assign_attributes(:workcategory_id => wc.id)
    end
#       record.assign_attributes(:image1 => row["image_path"])
    record
  end

  def load_venue(row,user)
    record = user.venues.find_by_id(row["id"]) || user.venues.build()
    record.assign_attributes(row.to_hash.slice(*Venue.accessible_attributes))
    vc = Venuecategory.find_by_name(row["category"])
    if vc.nil?
#      errors.add :base, "The venue category specified for #{record.name} does not exist. No category was assigned."
    else
      record.assign_attributes(:venuecategory_id => vc.id)
    end
    record
  end

  def load_client(row,user)
    record = user.clients.find_by_id(row["id"]) || user.clients.build()
    record.assign_attributes(row.to_hash.slice(*Client.accessible_attributes))
    record
  end

  def load_activity(row,user)
    record = user.activities.find_by_id(row["id"]) || user.activities.build()
    record.assign_attributes(row.to_hash.slice(*Activity.accessible_attributes))
    ac = row["category"]
    if !ac.blank?
      ac = Activitycategory.find_by_name(ac)
      if ac.blank?
#        errors.add :base,  "The activity category specified for #{row} does not exist."
      else
        record.assign_attributes(:activitycategory_id => ac.id)
      end
    end
    w = row["work"]
    if w.blank?
#      errors.add :base, "Row #{row} had no work value."
    else
      w = user.works.find_by_inventory_id(w)
      if w.blank?
#        errors.add :base, "The work specified for #{row} does not exist."
      else
        record.assign_attributes(:work_id => w.id)
      end
    end
    v = row["venue"]
    if v.blank?
#      errors.add :base, "Row #{row} had no venue value."
    else
      v = user.venues.find_by_name(v)
      if v.blank?
#        errors.add :base, "The venue specified for #{row} does not exist."
      else
        record.assign_attributes(:venue_id => v.id)
      end
    end
    c = row["client"]
    if !c.blank?
      c = user.clients.find_by_name(c)
      if c.blank?
#        errors.add :base, "The client specified for #{row} does not exist. No client was assigned."
      else
        record.assign_attributes(:client_id => c.id)
      end
    end       
    record
  end
end
