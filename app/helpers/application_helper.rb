module ApplicationHelper
  def nav_link(title, path, link_options = {})
    link_options = {
      title: title
    }.merge!(link_options)

    content_tag(:li, class: (:active if current_page?(path))) do
      link_to title, path, link_options
    end
  end
end
