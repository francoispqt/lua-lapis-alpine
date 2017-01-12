lapis = require "lapis"

class App extends lapis.Application
  views_prefix: "app.views"
  layout: require "app.views.layout.layout"

  @before_filter =>
    @default_title = "Lapi Bootstrap © François Parquet | www.parquet.ninja"

  handle_404: =>
    status: 404, layout: false, "Not Found!"

  "/": => render: "index"
