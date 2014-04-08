# == Schema Information
#
# Table name: actions
#
#  id              :integer          not null, primary key
#  due             :date
#  action          :string(255)
#  actionable_id   :integer
#  actionable_type :string(255)
#  complete        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Action < ActiveRecord::Base
  attr_accessible :due, :action, :actionable_type, :actionable_id, :complete
  
  USER = { :referer => "users", :model => "user", :type => "User", :selection => "General", :crumb_name => "Makers", :crumb_path => "users_path" }
  WORK = { :referer => "works", :model => "work", :type => "Work", :selection => "Work", :crumb_name => "Works", :crumb_path => "works_path" }
  VENUE = { :referer => "venues", :model => "venue", :type => "Venue", :selection => "Venue", :crumb_name => "Venues", :crumb_path => "venues_path" }
  CLIENT = { :referer => "clients", :model => "client", :type => "Client", :selection => "Client", :crumb_name => "Clients", :crumb_path => "clients_path" }

  TYPE_HASH_BY_REFERER = { Action::USER[:referer] => Action::USER, Action::WORK[:referer] => Action::WORK, Action::VENUE[:referer] => Action::VENUE, Action::CLIENT[:referer] => Action::CLIENT }

  TYPE_HASH_BY_TYPE = { Action::USER[:type] => Action::USER, Action::WORK[:type] => Action::WORK, Action::VENUE[:type] => Action::VENUE, Action::CLIENT[:type] => Action::CLIENT }

  TYPES = { Action::USER[:selection] => Action::USER[:type], 
            Action::WORK[:selection] => Action::WORK[:type],
            Action::VENUE[:selection] => Action::VENUE[:type],
            Action::CLIENT[:selection] => Action::CLIENT[:type]} 
            

  belongs_to :actionable, :polymorphic => true

  validates :actionable_type, presence: true
  validates_inclusion_of :actionable_type, :in => [Action::USER[:type], Action::WORK[:type], Action::VENUE[:type], Action::CLIENT[:type]]
  validates :actionable_id, presence: true
  validates :due, presence: true
  validates :action, presence: true, length: { maximum: 200 }
  validates_inclusion_of :complete, :in => [true, false]

  default_scope order: 'actions.due DESC' 

  scope :all_for_users, lambda { |user_id| where("(actionable_type = 'User' AND actionable_id = ?) OR (actionable_type = 'Work' and actionable_id in (?)) OR (actionable_type = 'Venue' and actionable_id in (?)) OR (actionable_type = 'Client' and actionable_id in (?))", user_id, User.find(user_id).works.all.map(&:id), User.find(user_id).venues.all.map(&:id), User.find(user_id).clients.all.map(&:id) ) }
   
  
end
