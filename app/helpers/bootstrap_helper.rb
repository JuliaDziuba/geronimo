module BootstrapHelper
  def icon(*names)
    content_tag(:i, nil, :class => icon_classes(names))
  end

  private
  def icon_classes(*names)
    final = ""
    names[0].each do |n|
      final = final + "icon-" + n.to_s + " "
    end
    return final
  end
end