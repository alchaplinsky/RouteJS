subject = require '../src/router'

Klass =
  routeCallback: ->

handlers =
  handler1: ->
  handler2: ->

location = {}

describe 'Router', ->

  beforeEach ->
    @router = new subject.Router(handlers)

  describe '.constructor', ->

    it 'should create set of routes', ->
      expect(@router.routes).toBeDefined()

    it 'should set handlers to objecr property', ->
      expect(@router.handlers).toEqual(handlers)

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
        match '/posts/slug', ->
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

      beforeEach ->
        @router.location = -> '/posts/slug'
        @router.routes[1].matches = -> true
        spyOn @router.routes[1], 'callback'
        @router.route()

      it 'should call isMatching until it matches', ->
        expect(@router.routes[0].matches).toHaveBeenCalledWith('/posts/slug')
        expect(@router.routes[2].matches).not.toHaveBeenCalled()

      it 'should call route`s callback function', ->
        expect(@router.routes[1].callback).toHaveBeenCalled()
