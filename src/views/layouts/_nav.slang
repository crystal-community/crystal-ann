nav#site-navigration.main-navigation
  ul.nav-menu
    li
      a href="/"
        i.fa.fa-home
        | Home
    li
      a href="/announcements/new"
        i.fa.fa-plus
        | Announce
    li
      a href="/about"
        i.fa.fa-info-circle
        | About
    - if signed_in?
      li
        a href="/sessions" id="sign-out-btn" csrf-token="#{csrf_token}"
          i.fa.fa-sign-out
          | Sign out
