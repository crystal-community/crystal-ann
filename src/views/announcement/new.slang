div.page-content
  h1 Make an Announcement

  - if signed_in?
    - if limit_reached?
      ul.errors
        li
          = "You can create up to #{max_anns_per_hour} announcements per hour"
    - else
      == render partial: "_form.slang"
  - else
    form action="/oauth/new"
      button type="submit"
        i.fa.fa-github
        | Sign in and post
