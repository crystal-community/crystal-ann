article.hentry
  header.entry-header
    h2.entry-title
      a href="/announcements/#{ announcement.id }" = announcement.title

  div.entry-content == announcement.content

  footer.entry-footer
    span.posted-on
      time.entry-date.published.updated
        i.fa.fa-calendar
        = announcement.created_at.try &.to_s "%b %d, %Y"

    - if user = announcement.user
      span.byline
        span.author.vcard
          a href="https://github.com/#{user.login}" target="_blank"
            i.fa.fa-github
            = user.login

    span.tags-links
      i.fa.fa-tag
      a href="?type=#{announcement.typename_underscore}"
        = announcement.typename

    - if can_update?(announcement)
      span.actions
        a href="/announcements/#{ announcement.id }/edit"
          i.fa.fa-pencil
        a href="/announcements/#{ announcement.id }?_method=delete" onclick="return confirm('Are you sure?');"
          i.fa.fa-trash
