## Router.js

Router.js is a lightweight JavaScript library - router for non-SPA applications.

While working on rich client side (not a Single Page Application) web application, it is sometimes necessary to run different
bits of javascript code (like instantiating object, passing params to it and call some method)
on different pages. Where is the right place to do it?

View doesn't seem to be the right place even though it is easy to drom `<script>`
tag at the bottom of the file with three lines of javascript. It is easy to run into problems
with mangled bu assets pipeline javascript names wich are not modified in views. Besides that
it is really convenient to have all javascript initialization for various pages in one place.

That's why using JavaScript router similar will help to define what should be run and when.

  - It is placed in javascript code so it will be compiled/minified with whole javascript code.
  - It gathers all initializations in a single place, so you don't need to search for code through all views.
  - It uses URL path to determine state of your applications - exactly what URL was designed for.


## Usage

Defining handler callbacks inline while define routes.
```
router = new RouteJS()
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
  findPage: (params) ->
    ....
  findCity: (params) ->
    ....

router = new RouteJS(handlers)
router.map (match, done)->
  match('/page/:slug').to('findPage')
  match('/country/:country_id/city/:id').to(findCity)
  done()
```
