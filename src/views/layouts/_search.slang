- query = params["query"]?
- user  = params["user"]?
- type  = params["type"]?

aside.widget.search
  form name="search" action="/"
    input.search-input name="query" type="text" placeholder="Search..." value="#{query}"
    - if user
      input type="hidden" name="user" value="#{user}"
    - if type
      input type="hidden" name="type" value="#{type}"
