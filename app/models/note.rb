# == Schema Information
#
# Table name: notes
#
#  id           :integer          not null, primary key
#  date         :date
#  note         :string(255)
#  notable_id   :integer
#  notable_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Note < ActiveRecord::Base
  attr_accessible :date, :note, :notable, :notable_type, :notable_id
  
  USER   = { :type => "User",   :referer => "users",   :model => "user",   :selection => "General", :crumb_name => "Makers",  :crumb_path => "users_path"   }
  WORK   = { :type => "Work",   :referer => "works",   :model => "work",   :selection => "Work",    :crumb_name => "Works",   :crumb_path => "works_path"   }
  VENUE  = { :type => "Venue",  :referer => "venues",  :model => "venue",  :selection => "Venue",   :crumb_name => "Venues",  :crumb_path => "venues_path"  }
  CLIENT = { :type => "Client", :referer => "clients", :model => "client", :selection => "Client",  :crumb_name => "Clients", :crumb_path => "clients_path" }

  TYPE_HASH_BY_REFERER = { 
    Note::USER[:referer] => Note::USER, 
    Note::WORK[:referer] => Note::WORK, 
    Note::VENUE[:referer] => Note::VENUE,
    Note::CLIENT[:referer] => Note::CLIENT 
  }

  TYPE_HASH_BY_TYPE = { 
    Note::USER[:type] => Note::USER, 
    Note::WORK[:type] => Note::WORK, 
    Note::VENUE[:type] => Note::VENUE,
    Note::CLIENT[:type] => Note::CLIENT 
  }

    TYPES = { Note::USER[:selection] => Note::USER[:type], 
            Note::WORK[:selection] => Note::WORK[:type],
            Note::VENUE[:selection] => Note::VENUE[:type],
            Note::CLIENT[:selection] => Note::CLIENT[:type]}

  belongs_to :notable, :polymorphic => true

  validates :notable_id, presence: true
  validates :notable_type, presence: true
  validates_inclusion_of :notable_type, :in => [Note::USER[:type], Note::WORK[:type], Note::VENUE[:type], Note::CLIENT[:type]]
  validates :date, presence: true
  validates :note, presence: true, length: { maximum: 200 }

  default_scope order: 'notes.date DESC' 

  scope :all_for_users, lambda { |user_id| where("(notable_type = 'User' AND notable_id = ?) OR (notable_type = 'Work' and notable_id in (?)) OR (notable_type = 'Venue' and notable_id in (?)) OR (notable_type = 'Client' and notable_id in (?))", user_id, User.find(user_id).works.all.map(&:id), User.find(user_id).venues.all.map(&:id), User.find(user_id).clients.all.map(&:id) ) }
   
  
end
