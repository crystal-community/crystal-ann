article.hentry
  header.entry-header
    h2.entry-title
      a href="/announcements/#{ announcement.id }" = announcement.title

  div.entry-content == announcement.content

  footer.entry-footer
    - if user = announcement.user
      span.byline
        span.author.vcard
          i.fa.fa-user
          a href="/users/#{user.login}"
            span.fn
              = user.name

    span.tags-links
      i.fa.fa-tag
      a href="/?#{to_query type: Announcement::TYPES[announcement.type], page: 1}"
        = announcement.typename

    span.posted-on
      time.entry-date.published.updated
        i.fa.fa-clock-o
        a href="/announcements/#{ announcement.id }" title="#{announcement.created_at.try &.to_s "%b %d, %Y"}"
          = time_ago_in_words(announcement.created_at.not_nil!)

    - if can_update?(announcement)
      span.actions
        a href="/announcements/#{ announcement.id }/edit"
          i.fa.fa-pencil
        a href="/announcements/#{ announcement.id }?_method=delete" onclick="return confirm('Are you sure?');"
          i.fa.fa-trash
