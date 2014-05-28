xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  xml.url do
    xml.loc "http://www.makersmoon.com"
    xml.priority 1.0
  end

  xml.url do
    xml.loc "http://www.makersmoon.com/signup"
    xml.priority 0.5
  end

  xml.url do
    xml.loc "http://www.makersmoon.com/signin"
    xml.priority 0.5
  end

  xml.url do
    xml.loc "http://www.makersmoon.com/features"
    xml.priority 0.5
  end

  xml.url do
    xml.loc "http://www.makersmoon.com/pricing"
    xml.priority 0.5
  end

  xml.url do
    xml.loc "http://www.makersmoon.com/makers"
    xml.priority 1.0
  end

  @users.each do |user|
    if user.share_about
      xml.url do
        xml.loc about_user_url(user)
        xml.priority 0.8
      end
    end

    if user.share_contact
      xml.url do
        xml.loc contact_user_url(user)
        xml.priority 0.8
      end
    end

    if user.share_purchase
      xml.url do
        xml.loc purchase_user_url(user)
        xml.priority 0.8
      end
    end

  end

  @works.each do |work|
    if !work.workcategory.blank?
      xml.url do 
        xml.loc "#{root_url}makers/#{work.user.to_param}/#{work.workcategory.name}/#{work.inventory_id}"
        xml.priority 0.7
      end
    end
  end

end