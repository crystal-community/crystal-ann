== render "_entry.slang"

nav.navigation.post-navigation role="navigation"
  div.nav-links
    - if newer
      div.nav-next
        a href="/announcements/#{newer.id}"
          span.meta-nav Previous
          span.post-title = newer.title

    - if older
      div.nav-previous
        a href="/announcements/#{older.id}"
          span.meta-nav Next
          span.post-title = older.title
