assert = require("chai").assert
Sort = require("../../src/mysql/sort/index")

describe("MySql sort", ->

	it("should be able to accept the '-' operator", ->
		sort = new Sort((a, b) ->
			a.age - b.age
		)
		assert.strictEqual(sort.sql, "?? ASC")
		assert.deepEqual(sort.params, ["age"])

		sort = new Sort((a, b) ->
			b.age - a.age
		)
		assert.strictEqual(sort.sql, "?? DESC")
		assert.deepEqual(sort.params, ["age"])
		return
	)

	it("should be able to accept the localeCompare() callee", ->
		sort = new Sort((a, b) ->
			a.name.localeCompare(b.name)
		)
		assert.strictEqual(sort.sql, "?? ASC")
		assert.deepEqual(sort.params, ["name"])

		sort = new Sort((a, b) ->
			b.name.localeCompare(a.name)
		)
		assert.strictEqual(sort.sql, "?? DESC")
		assert.deepEqual(sort.params, ["name"])
		return
	)

	it("should throw an error if the supplied objects are uncomparable", ->
		assert.throw(->
			new Sort((a, b) ->
				a.age - b.id
			)
		)

		assert.throw(->
			new Sort((a, b) ->
				a.age - a.age
			)
		)

		assert.throw(->
			new Sort((a, b) ->
				age - b.age
			)
		)

		assert.throw(->
			new Sort((a, b) ->
				c.age - b.age
			)
		)
		return
	)

	it("should throw an error on unsupported javascript operator", ->
		assert.throw(->
			new Sort((a, b) ->
				a.age + b.age
			)
		)
		return
	)

)