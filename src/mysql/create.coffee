BooleanDatatype = require("../datatypes/boolean")
StringDatatype = require("../datatypes/string")
NumberDatatype = require("../datatypes/number")
DateDatatype = require("../datatypes/date")
TimeDatatype = require("../datatypes/time")

class Create

	###
	Constructs a parameterized "CREATE TABLE" SQL expression.
	@param {String} name the name of the table.
	@param {Object} columns an object containing column names and their associated datatypes.
	@param {Object} options key/value settings (optional).
	@option options {String} engine the table's internal engine, e.g. "MYISAM" or "InnoDB".
	###
	constructor: (name, columns, options = {}) ->
		sql = "CREATE TABLE IF NOT EXISTS ??"
		params = [name]

		sql += " ("
		for own key, datatype of columns
			if next
				sql += ", "
			else
				next = true

			sql += "?? "
			params.push(key)

			if datatype instanceof BooleanDatatype
				stmt = new Create.Boolean(datatype)
			else if datatype instanceof NumberDatatype
				stmt = new Create.Number(datatype)
			else if datatype instanceof StringDatatype
				stmt = new Create.String(datatype)
			else
				throw new Error("Unsupported column datatype")

			sql += stmt.sql
			params = params.concat(stmt.params)

			if datatype.nullable()
				sql += " NULL"
			else
				sql += " NOT NULL"
		sql += ")"

		sql += " ENGINE = ?"
		params.push(options.engine || "InnoDB")

		sql += ";"

		@sql = sql
		@params = params

class Create.Boolean

	###
	Constructs a parameterized SQL expression that defines a boolean column.
	###
	constructor: ->
		@sql = "TINYINT(1) UNSIGNED"
		@params = []
		console.log @sql, @params

class Create.Number

	###
	Constructs a parameterized SQL expression that defines a numeric column.
    @param {NumberDatatype} datatype the column's datatype.
	###
	constructor: (datatype) ->
		sql = ""
		params = []

		precision = datatype.precision()
		scale = datatype.scale()

		if scale is 0 #integer
			min = datatype.min()
			max = datatype.max()

			if min >= 0 #unsigned
				if max < 256
					sql += "TINYINT"
				else if max < 65536
					sql += "SMALLINT"
				else if max < 16777216
					sql += "MEDIUMINT"
				else if max < 4294967296 or max is undefined
					sql += "INT"
				else
					sql += "BIGINT"
				sql += " UNSIGNED"

			else #signed
				if min >= -128 and max < 128
					sql += "TINYINT"
				else if min >= -32768 and max < 32768
					sql += "SMALLINT"
				else if min >= -8388608 and max < 8388608
					sql += "MEDIUMINT"
				else if (min >= -2147483648 or min is undefined) and (max < 2147483648 or max is undefined)
					sql += "INT"
				else
					sql += "BIGINT"

		else #float
			sql += "FLOAT"
			if precision isnt undefined and scale isnt undefined
				sql += "(#{precision}, #{scale})"
			if min >= 0 #unsigned
				sql += " UNSIGNED"

		@sql = sql
		@params = params

class Create.String

	###
	Constructs a parameterized SQL expression that defines a textual column.
	@param {StringDatatype} datatype the column's datatype.
	###
	constructor: (datatype) ->
		sql = ""
		params = []

		equals = datatype.equals()

		if equals? #accepts predefined values
			if equals.length <= 64
				sql += "SET"
			else
				sql += "ENUM"

			sql += "("
			for value, i in equals
				if i isnt 0 then sql += ", "
				sql += "?"
				params.push(value)
			sql += ")"

		else #accepts free values
			exactLength = datatype.length()
			maxLength = datatype.maxLength()
			length = exactLength || maxLength || 100

			if length < 256
				if exactLength isnt undefined
					sql += "CHAR"
				else
					sql += "VARCHAR"
				sql += "(#{length})"
			else if length < 65536
				sql += "TEXT"
			else if length < 16777216
				sql += "MEDIUMTEXT"
			else
				sql += "LONGTEXT"

		@sql = sql
		@params = params

module.exports = Create