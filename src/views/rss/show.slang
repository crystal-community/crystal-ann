rss version=2.0
  channel
    title = SITE.name
    description = SITE.description
    <link>#{SITE.url}</link>

    - announcements.each do |announcement|
      item
        title = announcement.title
        description = announcement.content
          | <small>#{announcement.typename}</small>
          | <small>Announced #{time_ago_in_words(announcement.created_at.not_nil!)} by </small>
            - if user = announcement.user
                | <a href="https://github.com/#{user.login}">#{user.login}</a>
        pubDate = announcement.created_at.try &.to_s "%d %b %Y %T %z"
        <link>#{SITE.url}/announcements/#{announcement.id}</link>
        guid  #{SITE.url}/announcements/#{announcement.id}
