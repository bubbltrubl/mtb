module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end
  
  def avatar_url(user)
    image_url = user.image_url
    if image_url
      image_url
    else
      "/assets/guest.gif"
    end
  end
end
