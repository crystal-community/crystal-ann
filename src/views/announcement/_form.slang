- if announcement.errors
  ul.errors
    - announcement.errors.each do |error|
      li = error

- action = (announcement.id ? "/announcements/#{ announcement.id.to_s }" : "/announcements")

form action="#{ action }" method="post"
  == csrf_tag

  - if announcement.id
    input type="hidden" name="_method" value="patch"

  input type="text" name="title" autofocus="true" placeholder="Title goes here..." value="#{ announcement.title }"

  textarea rows="10" name="description" placeholder="Describe your announcement here and include links..." = announcement.description

  select name="type"
    option value="-1" selected="selected" = "-- select type --"
    - Announcement::TYPES.each do |type, name|
      - if type == announcement.type
        option value="#{ type }" selected="selected" = name
      - else
        option value="#{ type }" = name

  div.actions
    button type="submit" Submit

link rel="stylesheet" href="https://cdn.jsdelivr.net/simplemde/latest/simplemde.min.css"
script src="https://cdn.jsdelivr.net/simplemde/latest/simplemde.min.js"

javascript:
  var simplemde = new SimpleMDE();
