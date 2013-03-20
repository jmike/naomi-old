assert = require("chai").assert
Sort = require("../../src/connectors/mysql/sort")

describe("MySql sort", ->

	it("should throw an error if the supplied objects are uncomparable", ->
		assert.throw(->
			new Sort("a.age - b.id", "a", "b")
		)

		assert.throw(->
			new Sort("a.age - a.age", "a", "b")
		)

		assert.throw(->
			new Sort("age - b.age", "a", "b")
		)

		assert.throw(->
			new Sort("c.age - a.age", "a", "b")
		)
		return
	)

	it("should throw an error on unsupported javascript operator", ->
		assert.throw(->
			new Sort("a.age + b.age", "a", "b")
		)
		return
	)

	it("should be able to understand the - operator", ->
		sort = new Sort("a.age - b.age", "a", "b")
		assert.strictEqual(sort.sql, "`age` ASC")
		assert.strictEqual(sort.params.length, 0)

		sort = new Sort("b.age - a.age", "a", "b")
		assert.strictEqual(sort.sql, "`age` DESC")
		assert.strictEqual(sort.params.length, 0)
		return
	)

	it("should be able to understand the localeCompare() function", ->
		sort = new Sort("a.name.localCompare(b.name)", "a", "b")
		assert.strictEqual(sort.sql, "`name` ASC")
		assert.strictEqual(sort.params.length, 0)

		sort = new Sort("b.name.localCompare(a.name)", "a", "b")
		assert.strictEqual(sort.sql, "`name` DESC")
		assert.strictEqual(sort.params.length, 0)
		return
	)

)