- query = params["query"]?

aside.widget.search
  form name="search" action="/"
    input.search-input name="query" type="text" pattern=".{3,}" placeholder="Search..." value="#{query}"
