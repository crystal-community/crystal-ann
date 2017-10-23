div.page-content
  h1 Make an Announcement

  - if signed_in?
    - if limit_reached?
      ul.errors
        li
          = "You can create up to #{max_anns_per_hour} announcements per hour"
    - else
      == render "_form.slang"
  - else
    form action="/sessions/new"
      button type="submit"
        i.fa.fa-github
        | Sign in and post
