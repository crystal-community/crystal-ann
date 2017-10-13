div.site-info
  div.footer-block.copyright
    | © #{Time.now.year} #{SITE.name}. #{SITE.description}

  div.footer-block
    h3 = SITE.name
    a href="/announcements/new" = "Announce"
    a href="/about" = "About"
    a href="/rss" = "RSS"
    a href="https://twitter.com/crystallang_ann" target="_blank" rel="noopener noreferrer" = "Twitter"
    a href="https://github.com/crystal-community/crystal-ann" target="_blank" rel="noopener noreferrer" = "Github"

  div.footer-block
    h3 = "Crystal Language"
    a href="https://crystal-lang.org/docs/" target="_blank" rel="noopener noreferrer" = "Learn"
    a href="https://github.com/crystal-lang/crystal" target="_blank" rel="noopener noreferrer" = "Source Code"
    a href="https://play.crystal-lang.org/#/cr" target="_blank" rel="noopener noreferrer" = "Play Online"
    a href="https://github.com/veelenga/awesome-crystal" target="_blank" rel="noopener noreferrer" = "Awesome Crystal List"
    a href="https://crystalshards.xyz" target="_blank" rel="noopener noreferrer" = "Crystal Shards"

  br style="clear:left;"
