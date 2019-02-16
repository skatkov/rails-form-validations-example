# Default
# Proc.new { |html_tag, instance| "<div class=\"field_with_errors\">#{html_tag}</div>".html_safe }
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  fragment = Nokogiri::HTML.fragment(html_tag)
  field = fragment.at('input,select,textarea')

  object = instance_tag.object
  error_message = object.errors.full_messages.join(', ')

  if field
    field['class'] = "#{field['class']} invalid"
    html = <<-HTML
			#{fragment.to_s}
			<p class="error">#{error_message}</p>
    HTML
    html.html_safe
  else
    html_tag.html_safe
  end
end
