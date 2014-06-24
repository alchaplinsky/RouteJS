root = exports ? this

class root.Route

  constructor: (@handlers, @pattern) ->

  to: (callback) ->
    if typeof callback is 'function'
      @callback = callback
      return @
    else if typeof callback is "string"
      if @handlers[callback]?
        @callback = @handlers[callback]
        return @
      else
        console.error "Handler '#{callback}' not found!"
        false
    else
      console.error "Unaccepted handler value!"
      false

  matches: (path) ->
    path.match(@regexp()) isnt null

  regexp: ->
    segments = []
    for segment in @pattern.split('/')
      segments.push(segment.replace(/\:.+/, '.+'))
    segments[segments.length-1] = segments[segments.length-1]+"$"
    segments.join('\\/')

  params: (path) ->
    params = {}
    segments = path.split('/')
    for segment, i in @pattern.split('/')
      params[segment.slice(1)] = segments[i] if segment.match(/^:.+/)
    params

class root.Router

  constructor: (@handlers) ->
    @routes = []

  map: (callback) ->
    callback.call @, @match, @route

  match: (path, callback = null) =>
    route = new root.Route(@handlers, path)
    route.to(callback) if callback?
    @routes.push(route)
    route

  location: ->
    window.location.pathname

  route: =>
    for route in @routes
      return route.callback(route.params(@location())) if route.matches(@location())
