module ApplicationHelper
	# Returns the full title on a per-page basis
  def full_title(page)
    base_title = "GERONIMO"
    if page.empty?
      if @user.nil?
      	base_title
      else 
      	 "#{base_title} | " + @user.name
      end
    elsif page == "Sign up"
    	"#{base_title}! #{page}"
    else
      @user.name + " | #{page}"
    end
  end

end
