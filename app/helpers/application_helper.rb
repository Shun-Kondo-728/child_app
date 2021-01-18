module ApplicationHelper
  require "uri"

  def text_url_to_link text
    URI.extract(text, ['http','https']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"

      text.gsub!(url, sub_text)
    end

    return text
  end

  def full_title(page_title = '') # full_titleメソッドを定義
      base_title = 'チルシェア'
      if page_title.blank?
        base_title
      else
        "#{page_title} - #{base_title}"
      end
  end
end
