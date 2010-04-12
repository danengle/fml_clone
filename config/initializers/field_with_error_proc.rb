ActionView::Base.field_error_proc = 
  lambda do |html_tag, instance|
    if html_tag =~ /^<label/ || html_tag =~ /type="hidden"/
      html_tag
    else
      if html_tag =~ / class="[^"]*"/
        html_tag.sub ' class="', ' class="fieldHasErrors '
      else
        html_tag.sub ' name=', ' class="fieldHasErrors" name='
      end
    end
  end
