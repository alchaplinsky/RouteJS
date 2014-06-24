## Router.js

 Router.js is a lightweight JavaScript library - router for non-SPA applications.

### Usage

Defining handler callbacks inline while define routes.
```
router = new Router()
router.map (match, done)->
  match('/page/:slug').to (params) ->
    # Do whatever you need on this page. params.slug is available

  match('/country/:country_id/city/:id').to (params) ->
    # Do whatever you need on this page. params.country_id, params.id are available

  done()
```

Pre-defined object with handler callbacks, to simplify routes description.
```
handlers =
  findPage: ->
    ....
  findCity: ->
    ....

router = new Router(handlers)
router.map (match, done)->
  match('/page/:slug').to('findPage')
  match('/country/:country_id/city/:id').to(findCity)
  done()
```
