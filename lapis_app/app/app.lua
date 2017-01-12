local lapis = require("lapis")
local App
do
  local _class_0
  local _parent_0 = lapis.Application
  local _base_0 = {
    views_prefix = "app.views",
    layout = require("app.views.layout.layout"),
    handle_404 = function(self)
      return {
        status = 404,
        layout = false
      }, "Not Found!"
    end,
    ["/"] = function(self)
      return {
        render = "index"
      }
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "App",
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
  local self = _class_0
  self:before_filter(function(self)
    self.default_title = "Lapi Bootstrap © François Parquet | www.parquet.ninja"
  end)
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  App = _class_0
  return _class_0
end
