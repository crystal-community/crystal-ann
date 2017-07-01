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

    span.byline
      span.author.vcard
        i.fa.fa-user
        | Anonymous

    span.tags-links
      i.fa.fa-tag
      = announcement.typename

    span.actions
      a href="/announcements/#{ announcement.id }/edit"
        i.fa.fa-pencil
      a href="/announcements/#{ announcement.id }?_method=delete" onclick="return confirm('Are you sure?');"
        i.fa.fa-trash
