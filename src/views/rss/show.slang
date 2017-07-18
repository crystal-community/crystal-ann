rss version=2.0
  channel
    title = SITE.name
    description = SITE.description
    <link>#{SITE.url}</link>

    - announcements.each do |announcement|
      item
        title = announcement.title
        description = announcement.content
        pubDate = announcement.created_at.try &.to_s "%d %b %Y %T %z"
        <link>#{SITE.url}/announcements/#{announcement.id}</link>
        guid  #{SITE.url}/announcements/#{announcement.id}
