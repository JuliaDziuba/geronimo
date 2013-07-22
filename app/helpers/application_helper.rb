module ApplicationHelper
	
  # Returns the full title on a per-page basis
  # TODO Extend this so that public sites have user | page. 
  def full_title(page)
    base_title = "Makers' Moon"
    if !signed_in? && page.empty?
      base_title
    elsif !signed_in?
      "#{base_title} | #{page}"
    else
      "#{base_title} | " + current_user.name 
    end
  end
  
end