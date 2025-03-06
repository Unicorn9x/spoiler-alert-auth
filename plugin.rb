# name: spoiler-alert-auth
# about: Extends Discourse Spoiler-Alert to only allow logged-in users to reveal spoilers
# version: 1.1.0
# authors: Unicorn9x

enabled_site_setting :spoiler_auth_enabled

register_asset "stylesheets/spoiler_auth.scss"

after_initialize do
  on(:reduce_cooked) do |fragment, post|
    begin
      fragment
        .css(".spoiler")
        .each do |el|
          next if el.inner_html.blank?
          
          link = fragment.document.create_element("a")
          link["href"] = post.url
          link.content = I18n.t("spoiler_auth.excerpt_spoiler")
          el.inner_html = link.to_html
        end
    rescue => e
      Rails.logger.error("Spoiler Auth Plugin Error: #{e.message}\n#{e.backtrace.join("\n")}")
    end
  end

  # Remove spoilers from topic excerpts
  on(:reduce_excerpt) do |doc, post|
    begin
      doc.css(".spoiler").remove
    rescue => e
      Rails.logger.error("Spoiler Auth Plugin Error: #{e.message}\n#{e.backtrace.join("\n")}")
    end
  end
end 
