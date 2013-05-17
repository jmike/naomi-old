assert = require("chai").assert
CreateStatement = require("../../src/mysql/create")
BooleanDatatype = require("../../src/datatypes/boolean")
NumberDatatype = require("../../src/datatypes/number")
IntegerDatatype = require("../../src/datatypes/integer")
StringDatatype = require("../../src/datatypes/string")

describe("MySql create statement", ->

	it("should accept boolean datatypes", ->
		stmt = new CreateStatement("test", {
			id: new IntegerDatatype().min(0)
			code: new StringDatatype().length(5).nullable(true)
			price: new NumberDatatype().precision(9).scale(2)
			available: new BooleanDatatype()
		})
		assert.strictEqual(stmt.sql, "CREATE TABLE IF NOT EXISTS ?? (?? INT UNSIGNED NOT NULL, ?? CHAR(5) NULL, ?? FLOAT(9, 2) NOT NULL, ?? TINYINT(1) UNSIGNED NOT NULL) ENGINE = ?;")
		assert.deepEqual(stmt.params, ["test", "id", "code", "price", "available", "InnoDB"])
		return
	)

)