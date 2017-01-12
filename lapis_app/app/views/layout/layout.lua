local Widget
Widget = require("lapis.html").Widget
local Layout
do
  local _class_0
  local _parent_0 = Widget
  local _base_0 = {
    content = function(self)
      return html_5(function()
        head(function()
          meta({
            charset = "utf-8"
          })
          return title(function()
            if self.title then
              return text(self.title)
            else
              return text(self.default_title)
            end
          end)
        end)
        return body(function()
          div({
            class = "menu"
          })
          self:content_for("inner")
          return div({
            class = "footer"
          })
        end)
      end)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Layout",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Layout = _class_0
  return _class_0
end
