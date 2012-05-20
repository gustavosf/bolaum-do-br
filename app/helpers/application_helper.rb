module ApplicationHelper

  def ajax_loader
    content_tag(:div, image_tag('ajax-loader.gif'), :class => 'ajax-loader')
  end

end
