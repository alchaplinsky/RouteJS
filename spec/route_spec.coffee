subject = require '../src/router'

handlers =
  exampleHandler: ->

handler = ->

route = '/page/:slug/comment/:id'

describe 'Route', ->

  describe '#to', ->

    beforeEach ->
      @route = new subject.Route(handlers)

    describe 'when param is function', ->
      it 'should set function as callback', ->
        @route.to(handler)
        expect(@route.callback).toEqual(handler)

      it 'should return this', ->
        expect(@route.to(handler) instanceof subject.Route).toBeTruthy()

    describe 'when param is string', ->

      describe 'when string matches handler key', ->
        it 'should set handler as callback', ->
          @route.to('exampleHandler')
          expect(@route.callback).toEqual(handlers.exampleHandler)

        it 'should return this', ->
          expect(@route.to('exampleHandler') instanceof subject.Route).toBeTruthy()

      describe 'when string doesn`t match handler key', ->
        beforeEach ->
          spyOn(console, 'error')
          @result = @route.to('someString')

        it 'should not define callback', ->
          expect(@route.callback).not.toBeDefined()

        it 'should log error', ->
          expect(console.error).toHaveBeenCalledWith("Handler 'someString' not found!")

        it 'should return false', ->
          expect(@result).toBeFalsy()

    describe 'when param is unsupported type', ->
      beforeEach ->
        spyOn(console, 'error')
        @result = @route.to(1)

      it 'should not define callback', ->
        expect(@route.callback).not.toBeDefined()

      it 'should log error', ->
        expect(console.error).toHaveBeenCalledWith("Unaccepted handler value!")

      it 'should return false', ->
        expect(@result).toBeFalsy()

  describe '#matches', ->

    describe 'not matching routes', ->
      beforeEach ->
        @route = new subject.Route(handlers, '/go')

      it 'should return false if route doesn`t match', ->
        expect(@route.matches('/welcome/page')).toBeFalsy()

      it 'should not return true on not full match', ->
        expect(@route.matches('/google')).toBeFalsy()

    describe 'matching routes', ->
      beforeEach ->
        @route = new subject.Route(handlers, route)

      it 'route matches with params', ->
        expect(@route.matches('/page/content/comment/32')).toBeTruthy()
        expect(@route.matches('/page/433/comment/show')).toBeTruthy()


  describe '#regexp', ->

    beforeEach ->
      @route = new subject.Route(handlers, route)

    it 'should return regexp from path', ->
      expect(@route.regexp()).toEqual('\\/page\\/.+\\/comment\\/.+$')

  describe '#params', ->

    beforeEach ->
      @route = new subject.Route(handlers, route)

    it 'should extraxt params', ->
      expect(@route.params('/page/hello/comment/34')).toEqual({slug: 'hello', id: '34'})
