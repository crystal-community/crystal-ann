doctype html
html
  head
    title #{SITE["title"]} | #{SITE["description"]}
    meta charset="utf-8"
    meta http-equiv="X-UA-Compatible" content="IE=edge"
    meta name="viewport" content="width=device-width, initial-scale=1.0"

    link rel="stylesheet" href="/stylesheets/icon.css"
    link rel="stylesheet" href="/stylesheets/style.css"
    link rel="stylesheet" href="/stylesheets/main.css"

    link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"

  body.home
    div#page.hfeed.site
      div#sidebar.sidebar
        header#masthead.site-header role="banner"
          div.site-branding
            h1.site-title
              a href="/" = SITE["title"]
            p.site-description = SITE["description"]

            button.secondary-toggle

        div.secondary
          div
            == render_template "layouts/_nav.slang"
            == render_template "layouts/_search.slang"
            == render_template "layouts/_social_nav.slang"

      div#content.site-content
        div#primary.content-area
          main#main.site-main role="main"
            == content

      footer#colophon.site-footer role="contentinfo"
        == render_template "layouts/_footer.slang"

    script src="/javascripts/main.js"
    script src="/javascripts/ga.js"
