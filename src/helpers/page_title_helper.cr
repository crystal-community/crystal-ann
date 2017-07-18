module Helpers::PageTitleHelper
  @title : String?

  def page_title
    page_title_with_suffix(@title || SITE.description)
  end

  def page_title(page_title)
    @title = page_title
  end

  private def page_title_with_suffix(title, suffix = SITE.name)
    "#{title} - #{suffix}"
  end
end
