doctype html
html
  head
    title = page_title
    meta charset="utf-8"
    meta http-equiv="X-UA-Compatible" content="IE=edge"
    meta name="viewport" content="width=device-width, initial-scale=1.0"
    link rel="manifest" href="/manifest.json"
    link rel="stylesheet" href="/stylesheets/main.css"
    link rel="stylesheet" href="/stylesheets/monokai-sublime.min.css"
    link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"

  body.home
    div#page.hfeed.site
      div#sidebar.sidebar
        header#masthead.site-header role="banner"
          div.site-branding
            h1.site-title
              a href="/" = SITE.name
            p.site-description = SITE.description

            button.secondary-toggle

        div.secondary
          div
            == render partial: "layouts/_nav.slang"
            - if signed_in?
              == render partial: "layouts/_profile.slang"
            == render partial: "layouts/_search.slang"
            == render partial: "layouts/_tags.slang"
            == render partial: "layouts/_social_nav.slang"

      div#content.site-content
        div#primary.content-area
          main#main.site-main role="main"
            == content

      footer#colophon.site-footer role="contentinfo"
        == render partial: "layouts/_footer.slang"

    script src="/javascripts/main.js"
    script src="/javascripts/highlight.pack.js"
    script src="https://cdnjs.cloudflare.com/ajax/libs/mark.js/8.11.1/mark.min.js"

    == render partial: "layouts/_ga.slang"
