aside.widget.widget_meta
  h2.widget-title
    a href="/me"
      img.avatar src=current_user!.avatar_url(45)
      = current_user!.name

  ul
    li
      a href="/?user=#{current_user!.login}"
        | My announcements
    li
      a href="/sessions" id="sign-out-btn" csrf-token="#{csrf_token}"
        | Sign out
