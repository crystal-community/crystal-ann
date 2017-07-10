div.page-content
  h1 Make an Announcement

  - if signed_in?
    == render "_form.slang"
  - else
    form action="/sessions/new"
      button type="submit"
        i.fa.fa-github
        | Sign in and post
