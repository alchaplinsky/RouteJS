var root,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

root = typeof exports !== "undefined" && exports !== null ? exports : this;

root.Route = (function() {
  function Route(handlers, pattern) {
    this.handlers = handlers;
    this.pattern = pattern;
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

  Route.prototype.matches = function(path) {
    return path.match(this.regexp()) !== null;
  };

  Route.prototype.regexp = function() {
    var segment, segments, _i, _len, _ref;
    segments = [];
    _ref = this.pattern.split('/');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      segment = _ref[_i];
      segments.push(segment.replace(/\:.+/, '.+'));
    }
    segments[segments.length - 1] = segments[segments.length - 1] + "$";
    return segments.join('\\/');
  };

  Route.prototype.params = function(path) {
    var i, params, segment, segments, _i, _len, _ref;
    params = {};
    segments = path.split('/');
    _ref = this.pattern.split('/');
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

root.RouteJS = (function() {
  function RouteJS(handlers) {
    this.handlers = handlers;
    this.route = __bind(this.route, this);
    this.match = __bind(this.match, this);
    this.routes = [];
  }

  RouteJS.prototype.before = function(callback) {
    return this.beforeCallback = callback;
  };

  RouteJS.prototype.after = function(callback) {
    return this.afterCallback = callback;
  };

  RouteJS.prototype.map = function(callback) {
    return callback.call(this, this.match, this.route);
  };

  RouteJS.prototype.match = function(path, callback) {
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

  RouteJS.prototype.location = function() {
    return window.location.pathname;
  };

  RouteJS.prototype.route = function() {
    var params, route, _i, _len, _ref;
    _ref = this.routes;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      route = _ref[_i];
      if (route.matches(this.location())) {
        params = route.params(this.location());
        if (typeof this.beforeCallback === "function") {
          this.beforeCallback(params);
        }
        route.callback(params);
        return typeof this.afterCallback === "function" ? this.afterCallback(params) : void 0;
      }
    }
    if (typeof this.beforeCallback === "function") {
      this.beforeCallback();
    }
    return typeof this.afterCallback === "function" ? this.afterCallback() : void 0;
  };

  return RouteJS;

})();
