import Widget from require "lapis.html"

class Layout extends Widget
  content: =>
      html_5 ->
        head ->
          meta charset: "utf-8"
          title ->
            if @title
              text @title
            else
              text @default_title

        body ->
          div class:"menu"
          @content_for "inner"
          div class:"footer"
