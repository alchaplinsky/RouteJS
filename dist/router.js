var root,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

root = typeof exports !== "undefined" && exports !== null ? exports : this;

root.Route = (function() {
  function Route(handlers, path) {
    this.handlers = handlers;
    this.path = path;
  }

  Route.prototype.to = function(callback) {
    if (typeof callback === 'function') {
      this.callback = callback;
      return this;
    } else if (typeof callback === "string") {
      if (this.handlers[callback] != null) {
        this.callback = this.handlers[callback];
        return this;
      } else {
        console.error("Handler '" + callback + "' not found!");
        return false;
      }
    } else {
      console.error("Unaccepted handler value!");
      return false;
    }
  };

  Route.prototype.isMatching = function(path) {
    return path.match(this.parsedRoute()) !== null;
  };

  Route.prototype.parsedRoute = function() {
    var segment, segments, _i, _len, _ref;
    segments = [];
    _ref = this.path.split('/');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      segment = _ref[_i];
      segments.push(segment.replace(/\:.+/, '.+'));
    }
    return segments.join('\\/');
  };

  Route.prototype.getParams = function(path) {
    var i, params, segment, segments, _i, _len, _ref;
    params = {};
    segments = path.split('/');
    _ref = this.path.split('/');
    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
      segment = _ref[i];
      if (segment.match(/^:.+/)) {
        params[segment.slice(1)] = segments[i];
      }
    }
    return params;
  };

  return Route;

})();

root.Router = (function() {
  function Router(handlers) {
    this.handlers = handlers;
    this.route = __bind(this.route, this);
    this.match = __bind(this.match, this);
    this.routes = [];
  }

  Router.prototype.map = function(callback) {
    return callback.call(this, this.match, this.route);
  };

  Router.prototype.match = function(path, callback) {
    var route;
    if (callback == null) {
      callback = null;
    }
    route = new root.Route(this.handlers, path);
    if (callback != null) {
      route.to(callback);
    }
    this.routes.push(route);
    return route;
  };

  Router.prototype.getLocation = function() {
    return window.location.pathname;
  };

  Router.prototype.route = function() {
    var route, _i, _len, _ref;
    _ref = this.routes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      route = _ref[_i];
      if (route.isMatching(this.getLocation())) {
        route.callback(route.getParams(this.getLocation()));
        return;
      }
    }
  };

  return Router;

})();
