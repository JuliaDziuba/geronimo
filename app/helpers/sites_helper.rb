module SitesHelper

	# Returns the site title on a per-page basis
  def site_title(section)
    base_title = current_user.sites.find_by_id(params[:id]).brand
    if section.empty?
      base_title
    else
      "#{base_title} | #{section}"
    end
  end

end

