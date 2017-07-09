- if announcements.size > 0
  - announcements.each do |announcement|
    == render "_entry.slang"

  == render "shared/_pagination.slang"

- else
  div.page-content
    | Sorry, nothing found matching your query.
