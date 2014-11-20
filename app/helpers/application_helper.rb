module ApplicationHelper
	
  # Returns the full title on a per-page basis
  # TODO Extend this so that public sites have user | page. 
  def full_title(maker, page)
    keywords = "Art Inventory & Business Management for Makers"
    company = "Makers' Moon"
    if maker.empty?
      if page.empty?
        "#{keywords} | #{company}"
      else
        "#{keywords} | #{page} | #{company}"
      end
    else
      "#{maker} | #{page} | #{company}"
    end
  end

  class String
    def is_number?
      true if self.to_f() rescue false
    end
  end
  
end