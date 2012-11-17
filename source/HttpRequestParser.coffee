class HttpRequestParser

    sample = {
        select: {
            fields: [
                {
                    name: "id"
                    alias: "uuid"
                }
                {
                    name: "name"
                }
            ]
            from: [
                {
                    name: "table1"
                    alias: "tbl"
                }
                {
                    innerJoin: {
                        name: "table2"
                        alias: "tbr"
                    }
                    on: "tbl.id = tbr.id"
                }
            ],
            where: [
                {
                    key: "id"
                    operator: ">="
                    value: 1
                }
                {
                    and: {
                        key: "id"
                        operator: "!="
                        value: null
                    }
                }
            ],
            order: [
                {
                    by: "id"
                    asc: true
                },
                {
                    by: "name"
                    asc: false
                },
            ]
            limit: 1
            offset: 5
        }
    }

    ###*
    * Constructs a new HTTPRequestParser for the given request.
    * @param method {string} the HTTP method, i.e. "GET".
    * @param url {string} the request's URL, i.e. "/status?name=ryan".
    * @param payload {object=} the request's payload as an object (optional).
    * @throw {Error} if a required parameter is unspecified or invalid.
    ###
    constructor: (method, url, payload) ->
        #make sure input parameters are valid
#        switch method
#            when "GET" then @_method = "SELECT"
#            when "POST" then @_method = "INSERT"
#            when "PUT" then @method = "INSERT ON DUPLICATE KEY UPDATE"
#        when "Fri", "Sat"
#            if day is bingoDay
#            go bingo
#            go dancing
#        when "Sun" then go church
#        else go work
        if method not in ["GET", "POST", "PUT", "DELETE"]
            throw new Error("Unspecified or unsupported HTTP method")
        if typeof url isnt "string" || url.length is 0
            throw new Error("Invalid or unspecified url")
        if typeof payload not in ["undefined", "object"]
            throw new Error("Invalid or unspecified payload")
        filters = this._getFilters(url)
        where = this._getWhereClause(filters)
            

    _getWhereClause: (filters) ->
        re = /([\+\|]?)(\(?)([\w\d]+)(:[!=<>]*)([\w\d,]*)(\)?)/g
        arr = []
        for filter in filters
            while match = re.exec(filter)
                key = match[3]
                value = match[5]
                switch match[4]# operator
                    when ""
                        operator = "is not null"
                        value = undefined
                    when ":", ":=" then operator = "="
                    when ":!", ":!=" then operator = "!="
                    when ":>" then operator = ">"
                    when ":<" then operator = "<"
                    when ":<=" then operator = "<="
                    when ":>=" then operator = ">="
                    else throw Error("Invalid query operator")
                i = arr.push({}) - 1
                if match[1] isnt ""
                    arr[i]
                andor = match[1]
                openParenthesis = match[2]
                closeParenthesis = match[6]
                console.log("2 >>", match)

    ###*
    * Extracts and returns an array of filters from the given URL.
    * @param url {string} the request's URL, i.e. "/status?name=ryan".
    * @return {Array<string>}.
    ###
    _getFilters: (url) ->
        re = /[\?&]filter=([^&#]+)/gi
        while match = re.exec(url)
            match[1]
            
    getAbstractSql: ->
        return null