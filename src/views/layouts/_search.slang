- query = params["query"]?

aside.widget.search
  form name="search" action="/"
    input.search-input name="query" type="text" placeholder="Search..." value="#{query}"
