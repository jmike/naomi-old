assert = require("chai").assert
CreateStatement = require("../../src/mysql/create")
Datatypes = require("../../src/datatypes")

describe("MySql create statement", ->

	it("should be able to accept boolean datatypes", ->
		stmt = new CreateStatement.Boolean(
			Datatypes.bool()
		)
		assert.strictEqual(stmt.sql, "TINYINT(1) UNSIGNED NOT NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.Boolean(
			Datatypes.bool().nullable(true)
		)
		assert.strictEqual(stmt.sql, "TINYINT(1) UNSIGNED NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.Boolean(
			Datatypes.bool().nullable(false)
		)
		assert.strictEqual(stmt.sql, "TINYINT(1) UNSIGNED NOT NULL")
		assert.deepEqual(stmt.params, [])
		return
	)

	it("should be able to accept numeric datatypes", ->
		stmt = new CreateStatement.Number(
			Datatypes.integer()
		)
		assert.strictEqual(stmt.sql, "INT NOT NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.Number(
			Datatypes.integer().nullable(true)
		)
		assert.strictEqual(stmt.sql, "INT NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.Number(
			Datatypes.integer().min(0).max(255)
		)
		assert.strictEqual(stmt.sql, "TINYINT UNSIGNED NOT NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.Number(
			Datatypes.integer().min(0).max(65535)
		)
		assert.strictEqual(stmt.sql, "SMALLINT UNSIGNED NOT NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.Number(
			Datatypes.integer().min(0).max(16777215)
		)
		assert.strictEqual(stmt.sql, "MEDIUMINT UNSIGNED NOT NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.Number(
			Datatypes.integer().min(0).max(10000000000)
		)
		assert.strictEqual(stmt.sql, "BIGINT UNSIGNED NOT NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.Number(
			Datatypes.number()
		)
		assert.strictEqual(stmt.sql, "FLOAT NOT NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.Number(
			Datatypes.number().precision(7).scale(2)
		)
		assert.strictEqual(stmt.sql, "FLOAT(7, 2) NOT NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.Number(
			Datatypes.number().precision(7).scale(2).min(0)
		)
		assert.strictEqual(stmt.sql, "FLOAT(7, 2) UNSIGNED NOT NULL")
		assert.deepEqual(stmt.params, [])
		return
	)

	it("should be able to accept string datatypes", ->
		stmt = new CreateStatement.String(
			Datatypes.string().nullable(true)
		)
		assert.strictEqual(stmt.sql, "VARCHAR(100) NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.String(
			Datatypes.string().length(3)
		)
		assert.strictEqual(stmt.sql, "CHAR(3) NOT NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.String(
			Datatypes.string().maxLength(255)
		)
		assert.strictEqual(stmt.sql, "VARCHAR(255) NOT NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.String(
			Datatypes.string().maxLength(65535)
		)
		assert.strictEqual(stmt.sql, "TEXT NOT NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.String(
			Datatypes.string().maxLength(16777215).nullable(true)
		)
		assert.strictEqual(stmt.sql, "MEDIUMTEXT NULL")
		assert.deepEqual(stmt.params, [])

		stmt = new CreateStatement.String(
			Datatypes.string().maxLength(16777216)
		)
		assert.strictEqual(stmt.sql, "LONGTEXT NOT NULL")
		assert.deepEqual(stmt.params, [])
		return
	)

)