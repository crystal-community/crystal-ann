div.site-info
  div.footer-block.copyright
    | © #{Time.now.year} #{SITE["title"]}. #{SITE["description"]}

  div.footer-block
    h3 = SITE["title"]
    a href="/announcements/new" = "Announce"
    a href="/about" = "About"
    a href="/rss" = "RSS"
    a href="https://twitter.com/crystallang_ann" target="_blank" = "Twitter"
    a href="https://github.com/veelenga/crystal-ann" target="_blank" = "Github"

  div.footer-block
    h3 = "Crystal Language"
    a href="https://crystal-lang.org/docs/" target="_blank" = "Learn"
    a href="https://github.com/crystal-lang/crystal" target="_blank" = "Source Code"
    a href="https://play.crystal-lang.org/#/cr" target="_blank" = "Play Online"
    a href="https://github.com/veelenga/awesome-crystal" target="_blank" = "Awesome Crystal List"
    a href="https://crystalshards.xyz" target="_blank" = "Crystal Shards"

  br style="clear:left;"
