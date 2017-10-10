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

        - if user.handle
          | /
          i.fa.fa-twitter
          a href=user.twitter_url target="_blank" rel="noopener noreferrer"
            = user.handle

          - if current_user.try &.me?(user)
            | (
              a href="/users/remove_handle?_method=put" title="Disconnect Twitter" onclick="return confirm('Are you sure?');"
                | disconnect
            | )

  - if !user.handle && current_user.try &.me?(user)

    div.connect-twitter
      form action="/oauth/new" method="get"
        input type="hidden" name="provider" value="twitter"
        button type="submit"
          i.fa.fa-twitter
          | Connect Twitter
      p
        small
          | You'll be mentioned alongside your announcement.

  div style="clear:left;"
