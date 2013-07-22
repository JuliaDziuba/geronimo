
class Publicprofile < ActiveRecord::Base
  attr_accessible :about_text, :address_city, :address_state, :address_street, :address_zipcode, :blog, :brand, :domain, :email, :phone, :share_with_makers, :share_bio, :share_contact, :share_purchase, :share_works, :share_with_public, :social_etsy, :social_googleplus, :social_facebook, :social_linkedin, :social_pinterest, :social_twitter, :tag_line
  has_attached_file :about_image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "MakersMoonIconTransparent.gif"

  belongs_to :user

  before_validation :set_munged_brand

  validates :user_id, presence: true, uniqueness: { case_sensitive: false }
  validates :brand, presence: true, length: { maximum: 30 } 
  validates :munged_brand, presence: true, uniqueness: { case_sensitive: false }

  def to_param
    munged_brand
  end

  def set_munged_brand
    self.munged_brand = brand.parameterize
  end

  def works
    self.user.works.shared_with_public.all
  end

  def works_in_category(category)
    self.user.works.shared_with_public.where('works.workcategory_id = ?', category.id)
  end

  def venues 
    self.user.venues.shared_with_public.all
  end

  def workcategory_ids
    @workcategory_ids = []
    self.works.each do |work|
      @workcategory_ids.push(work.workcategory_id)
    end
    @workcategory_ids
  end

  def workcategories
    self.user.workcategories.where('workcategories.id in (?)', self.workcategory_ids)
  end

  def parent_workcategories_on_site
   self.user.workcategories.where('workcategories.id in (?)', self.workcategories.collect(&:parent_id))
  end

  def children_workcategories_on_site(parent)
    self.workcategories.where('workcategories.parent_id == ?', parent.id)
  end
end
