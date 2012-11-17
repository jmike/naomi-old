// Generated by CoffeeScript 1.3.3
var HttpRequestParser;

HttpRequestParser = (function() {
  var sample;

  sample = {
    select: {
      fields: [
        {
          name: "id",
          alias: "uuid"
        }, {
          name: "name"
        }
      ],
      from: [
        {
          name: "table1",
          alias: "tbl"
        }, {
          innerJoin: {
            name: "table2",
            alias: "tbr"
          },
          on: "tbl.id = tbr.id"
        }
      ],
      where: [
        {
          key: "id",
          operator: ">=",
          value: 1
        }, {
          and: {
            key: "id",
            operator: "!=",
            value: null
          }
        }
      ],
      order: [
        {
          by: "id",
          asc: true
        }, {
          by: "name",
          asc: false
        }
      ],
      limit: 1,
      offset: 5
    }
  };

  /**
  * Constructs a new HTTPRequestParser for the given request.
  * @param method {string} the HTTP method, i.e. "GET".
  * @param url {string} the request's URL, i.e. "/status?name=ryan".
  * @param payload {object=} the request's payload as an object (optional).
  * @throw {Error} if a required parameter is unspecified or invalid.
  */


  function HttpRequestParser(method, url, payload) {
    var filters, where, _ref;
    if (method !== "GET" && method !== "POST" && method !== "PUT" && method !== "DELETE") {
      throw new Error("Unspecified or unsupported HTTP method");
    }
    if (typeof url !== "string" || url.length === 0) {
      throw new Error("Invalid or unspecified url");
    }
    if ((_ref = typeof payload) !== "undefined" && _ref !== "object") {
      throw new Error("Invalid or unspecified payload");
    }
    filters = this._getFilters(url);
    where = this._getWhereClause(filters);
  }

  HttpRequestParser.prototype._getWhereClause = function(filters) {
    var andor, arr, closeParenthesis, filter, i, key, match, openParenthesis, operator, re, value, _i, _len, _results;
    re = /([\+\|]?)(\(?)([\w\d]+)(:[!=<>]*)([\w\d,]*)(\)?)/g;
    arr = [];
    _results = [];
    for (_i = 0, _len = filters.length; _i < _len; _i++) {
      filter = filters[_i];
      _results.push((function() {
        var _results1;
        _results1 = [];
        while (match = re.exec(filter)) {
          key = match[3];
          value = match[5];
          switch (match[4]) {
            case "":
              operator = "is not null";
              value = void 0;
              break;
            case ":":
            case ":=":
              operator = "=";
              break;
            case ":!":
            case ":!=":
              operator = "!=";
              break;
            case ":>":
              operator = ">";
              break;
            case ":<":
              operator = "<";
              break;
            case ":<=":
              operator = "<=";
              break;
            case ":>=":
              operator = ">=";
              break;
            default:
              throw Error("Invalid query operator");
          }
          i = arr.push({}) - 1;
          if (match[1] !== "") {
            arr[i];
          }
          andor = match[1];
          openParenthesis = match[2];
          closeParenthesis = match[6];
          _results1.push(console.log("2 >>", match));
        }
        return _results1;
      })());
    }
    return _results;
  };

  /**
  * Extracts and returns an array of filters from the given URL.
  * @param url {string} the request's URL, i.e. "/status?name=ryan".
  * @return {Array<string>}.
  */


  HttpRequestParser.prototype._getFilters = function(url) {
    var match, re, _results;
    re = /[\?&]filter=([^&#]+)/gi;
    _results = [];
    while (match = re.exec(url)) {
      _results.push(match[1]);
    }
    return _results;
  };

  HttpRequestParser.prototype.getAbstractSql = function() {
    return null;
  };

  return HttpRequestParser;

})();
