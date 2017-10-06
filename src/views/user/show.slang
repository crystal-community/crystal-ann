- page_title user.name

div.page-content
  div.author-info
    div.author-avatar
      img.avatar src=user.avatar_url

    div.author-description
      h3.author-title
        = user.name
      p
        i
          - if (total_announcements = user.total_announcements) > 0
            a href="/?user=#{user.login}"
              | An author of #{total_announcements} #{total_announcements == 1 ? "announcement" : "announcements"}
          - else
            | Is going to make an announcement.

      p
        i.fa.fa-github
        a href=user.github_url target="_blank" rel="noopener noreferrer"
          = user.login

        /- if user.twitter_login
        /| /
        /i.fa.fa-twitter
        /a href=user.twitter_url target="_blank" rel="noopener noreferrer"
        /  = user.twitter_login

  div style="clear:left;"
