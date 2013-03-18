assert = require("chai").assert
Sort = require("../../src/connectors/mysql/sort")

describe("MySql sort", ->

	it("should throw an error if property of 'a' is not equal to property of 'b'", ->
		assert.throw(->
			new Sort("a.age - b.id", "a", "b")
		)
		return
	)

	it("should throw an error if using an unsupported javascript operator", ->
		assert.throw(->
			new Sort("a.age + b.age", "a", "b")
		)
		return
	)

	it("should throw an error if a property is not fully qualified", ->
		assert.throw(->
			new Sort("age - b.age", "a", "b")
		)
		return
	)

	it("should throw an error if the compared properties are of the same object", ->
		assert.throw(->
			new Sort("a.age - a.age", "a", "b")
		)
		return
	)

	it("should throw an error if an unknown object is detected", ->
		assert.throw(->
			new Sort("c.age - a.age", "a", "b")
		)
		return
	)

	it("should be able to understand the - operator, where object a is on the left", ->
		sort = new Sort("a.age - b.age", "a", "b")
		assert.strictEqual(sort.sql, "`age` ASC")
		assert.strictEqual(sort.params.length, 0)
		return
	)

	it("should be able to understand the - operator, where object a is on the right", ->
		sort = new Sort("b.age - a.age", "a", "b")
		assert.strictEqual(sort.sql, "`age` DESC")
		assert.strictEqual(sort.params.length, 0)
		return
	)

)