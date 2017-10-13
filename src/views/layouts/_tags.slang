aside.widget.widget_meta
  h2.widget-title Popular tags
  ul.tags
    li
      - Announcement::TYPES.each do |type, name|
        a.tag-link href="/?#{to_query type: name, page: 1}"
          = Announcement.typename type
