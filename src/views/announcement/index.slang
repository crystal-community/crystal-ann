- if announcements.size > 0
  - announcements.each do |announcement|
    == render partial: "_entry.slang"

  == render partial: "shared/_pagination.slang"

- else
  div.page-content
    | Sorry, nothing found matching your query.
