- page_title announcement.title

== render "_entry.slang"

nav.navigation.post-navigation role="navigation"
  div.nav-links
    span.meta-nav See more
    - announcement.load_recommendations.each do |recommended|
      a.post-title href="/announcements/#{recommended.id}"
        = recommended.title
