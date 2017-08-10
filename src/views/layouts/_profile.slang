aside.widget.widget_meta
  h2.widget-title
    = current_user!.name

  ul
    li
      a href="/me"
        i.fa.fa-user-circle-o
        | Profile
    li
      a href="/?user=#{current_user!.login}"
        i.fa.fa-check-square-o
        | My announcements
    li
      a href="/sessions" id="sign-out-btn" csrf-token="#{csrf_token}"
        i.fa.fa-sign-out
        | Sign out
