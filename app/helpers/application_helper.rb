
module ApplicationHelper

  def menu_active?(menu_link)
    active = false
    if menu_link.is_a? Array
      active = menu_link.include?(accessed_page)
    else
      active = accessed_page.include?(menu_link)
    end
    active ? 'active' : ''
  end

  def logo
    logo = image_tag("rails.png", alt: "Time and it's Cost", class: "img-rounded pull-left")
  end

  # Return title on a per-page basis.
  def full_title(page_title)
    base_title = "Time and it's Cost"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # Returns the Gravatar (http://gravatar.com/) for the given employee.
  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag(user.email.strip,  :alt => h(user.name),
                       :class => 'gravatar round',
                       :gravatar => options)
  end

  def password_service
    @ct_password_service ||= PasswordService.new({controller: self})
    yield @ct_password_service if block_given?
    @ct_password_service
  end

end # End module
