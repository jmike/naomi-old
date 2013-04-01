assert = require("chai").assert
Map = require("../../src/connectors/mysql/map")

describe("MySql map", ->

	it("should be able to accept member expressions", ->
		map = new Map((entity) ->
			{
				id: entity.id
			}
		)
		assert.strictEqual(map.sql, "`id` AS ?")
		assert.deepEqual(map.params, ["id"])

		map = new Map((entity) ->
			{
				id: entity.id,
				name: entity.name
				age: entity.age
			}
		)
		assert.strictEqual(map.sql, "`id` AS ?, `name` AS ?, `age` AS ?")
		assert.deepEqual(map.params, ["id", "name", "age"])
		return
	)

	it("should be able to accept literals", ->
		map = new Map((entity) ->
			{
				id: entity.id,
				number: 777
				string: "test"
				bool: false
			}
		)
		assert.strictEqual(map.sql, "`id` AS ?, ? AS ?, ? AS ?, ? AS ?")
		assert.deepEqual(map.params, ["id", 777, "number", "test", "string", false, "bool"])
		return
	)

	it("should be able to accept logical expressions", ->
		map = new Map((entity) ->
			{
				id: entity.id
				test: true and false or false
			}
		)
		assert.strictEqual(map.sql, "`id` AS ?, ((? AND ?) OR ?) AS ?")
		assert.deepEqual(map.params, ["id", true, false, false, "test"])
		return
	)

	it("should be able to accept binary expressions", ->
		map = new Map((entity) ->
			{
				id: entity.id
				senior: entity.age > 70
			}
		)
		assert.strictEqual(map.sql, "`id` AS ?, (`age` > ?) AS ?")
		assert.deepEqual(map.params, ["id", 70, "senior"])

		map = new Map((entity) ->
			{
				id: entity.id
				oddYear: entity.age % 2 is 1
			}
		)
		assert.strictEqual(map.sql, "`id` AS ?, ((`age` % ?) = ?) AS ?")
		assert.deepEqual(map.params, ["id", 2, 1, "oddYear"])
		return
	)

	it("should be able to accept math functions", ->
		map = new Map((entity) ->
			{
				id: entity.id
				tan: Math.tan(entity.age)
			}
		)
		assert.strictEqual(map.sql, "`id` AS ?, TAN(`age`) AS ?")
		assert.deepEqual(map.params, ["id", "tan"])

		assert.throw(->
			new Map((entity) ->
				{
					whatever: Math.whatever(entity.age)
				}
			)
		)
		return
	)

	it("should be able to accept math functions", ->
		map = new Map((entity) ->
			{
				id: entity.id
				tan: Math.tan(entity.age)
			}
		)
		assert.strictEqual(map.sql, "`id` AS ?, TAN(`age`) AS ?")
		assert.deepEqual(map.params, ["id", "tan"])

		assert.throw(->
			new Map((entity) ->
				{
					whatever: Math.whatever(entity.age)
				}
			)
		)
		return
	)

	it("should be able to accept a this object", ->
		map = new Map((entity) ->
			{
				sum: entity.age + this.num
			}
		, {num: 55})
		assert.strictEqual(map.sql, "(`age` + ?) AS ?")
		assert.deepEqual(map.params, [55, "sum"])

		assert.throw(->
			new Map((entity) ->
				{
					sum: entity.age + this.whatever
				}
			)
		)
		return
	)

)