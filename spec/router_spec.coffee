subject = require '../src/routejs'

Klass =
  routeCallback: ->

handlers =
  handler1: ->
  handler2: ->

location = {}

describe 'Router', ->

  beforeEach ->
    @router = new subject.RouteJS(handlers)

  describe '.constructor', ->

    it 'should create set of routes', ->
      expect(@router.routes).toBeDefined()

    it 'should set handlers to objecr property', ->
      expect(@router.handlers).toEqual(handlers)

  describe '#before', ->
    beforeEach ->
      @router.before(Klass.routeCallback)

    it 'should set before routing action', ->
      expect(@router.beforeCallback).toEqual(Klass.routeCallback)

  describe '#after', ->
    beforeEach ->
      @router.after(Klass.routeCallback)

    it 'should set after routing action', ->
      expect(@router.afterCallback).toEqual(Klass.routeCallback)

  describe '#map', ->

    beforeEach ->
      spyOn Klass, 'routeCallback'
      @router.map(Klass.routeCallback)

    it 'should call passed callback', ->
      expect(Klass.routeCallback).toHaveBeenCalledWith(@router.match, @router.route)

  describe '#match', ->

    beforeEach ->
      @route = @router.match('/test')

    it 'should push route object ro array of routes', ->
      expect(@router.routes.length).toEqual(1)
      expect(@router.routes[0]).toEqual(@route)

    it 'should return route object', ->
      expect(@route instanceof subject.Route).toBeTruthy()

    it 'should pass a link to handlers to route object', ->
      expect(@route.handlers).toEqual(handlers)

    it 'should set path for route object', ->
      expect(@route.pattern).toEqual('/test')

  describe '#route', ->

    beforeEach ->
      @router.map (match, done) ->
        match '/page/num', ->
        match '/posts/:slug', ->
        match '/category/num', ->
      spyOn @router.routes[0], 'matches'
      spyOn @router.routes[1], 'matches'
      spyOn @router.routes[2], 'matches'

    describe 'when no route matches', ->

      beforeEach ->
        @router.location = -> '/some/path'
        @router.route()

      it 'should call isMatching for routes', ->
        expect(@router.routes[0].matches).toHaveBeenCalledWith('/some/path')
        expect(@router.routes[1].matches).toHaveBeenCalledWith('/some/path')
        expect(@router.routes[2].matches).toHaveBeenCalledWith('/some/path')

    describe 'when route matches', ->

      describe 'wihout after/before callbacks', ->
        beforeEach ->
          @router.location = -> '/posts/slug'
          @router.routes[1].matches = -> true
          spyOn @router.routes[1], 'callback'
          @router.route()

        it 'should call isMatching until it matches', ->
          expect(@router.routes[0].matches).toHaveBeenCalledWith('/posts/slug')
          expect(@router.routes[2].matches).not.toHaveBeenCalled()

        it 'should call route`s callback function', ->
          expect(@router.routes[1].callback).toHaveBeenCalledWith({slug: 'slug'})

      describe 'with before callback', ->

        beforeEach ->
          spyOn @router.routes[1], 'callback'
          spyOn Klass, 'routeCallback'
          @router.location = -> '/posts/slug'
          @router.routes[1].matches = -> true
          @router.before(Klass.routeCallback)
          @router.route()

        it 'should call before callback', ->
          expect(@router.beforeCallback).toHaveBeenCalledWith({slug: 'slug'})

        it 'should be callef after main callback', ->
          boolean = false
          @router.before ->
            boolean = true
          @router.routes[1].callback = ->
            return boolean
          @router.route()
          expect(boolean).toEqual(true)

      describe 'with after callback', ->

        beforeEach ->
          spyOn @router.routes[1], 'callback'
          spyOn Klass, 'routeCallback'
          @router.location = -> '/posts/slug'
          @router.routes[1].matches = -> true
          @router.after(Klass.routeCallback)
          @router.route()

        it 'should call after callback', ->
          expect(@router.afterCallback).toHaveBeenCalledWith({slug: 'slug'})

        it 'should be called after main callback', ->
          boolean = false
          @router.routes[1].callback = ->
            boolean = true
          @router.after ->
            return boolean
          @router.route()
          expect(boolean).toEqual(true)
