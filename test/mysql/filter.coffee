assert = require("chai").assert
Filter = require("../../src/mysql/filter")

describe("MySql filter", ->

	it("should be able to accept binary expressions", ->
		filter = new Filter((entity) ->
			entity.age is 23
		)
		assert.strictEqual(filter.sql, "(?? = ?)")
		assert.deepEqual(filter.params, ["age", 23])

		filter = new Filter((entity) ->
			entity.age isnt 23
		)
		assert.strictEqual(filter.sql, "(?? != ?)")
		assert.deepEqual(filter.params, ["age", 23])

		filter = new Filter((entity) ->
			entity.age > 23
		)
		assert.strictEqual(filter.sql, "(?? > ?)")
		assert.deepEqual(filter.params, ["age", 23])

		filter = new Filter((entity) ->
			entity.age < 23
		)
		assert.strictEqual(filter.sql, "(?? < ?)")
		assert.deepEqual(filter.params, ["age", 23])

		filter = new Filter((entity) ->
			entity.age >= 23
		)
		assert.strictEqual(filter.sql, "(?? >= ?)")
		assert.deepEqual(filter.params, ["age", 23])

		filter = new Filter((entity) ->
			entity.age <= 23
		)
		assert.strictEqual(filter.sql, "(?? <= ?)")
		assert.deepEqual(filter.params, ["age", 23])

		filter = new Filter((entity) ->
			entity.age + 1 is 23
		)
		assert.strictEqual(filter.sql, "((?? + ?) = ?)")
		assert.deepEqual(filter.params, ["age", 1, 23])

		filter = new Filter((entity) ->
			entity.age - 1 is 23
		)
		assert.strictEqual(filter.sql, "((?? - ?) = ?)")
		assert.deepEqual(filter.params, ["age", 1, 23])

		filter = new Filter((entity) ->
			entity.age * 2 is 46
		)
		assert.strictEqual(filter.sql, "((?? * ?) = ?)")
		assert.deepEqual(filter.params, ["age", 2, 46])

		filter = new Filter((entity) ->
			entity.age / 23 is 1
		)
		assert.strictEqual(filter.sql, "((?? / ?) = ?)")
		assert.deepEqual(filter.params, ["age", 23, 1])

		filter = new Filter((entity) ->
				entity.age % 2 is 1
		)
		assert.strictEqual(filter.sql, "((?? % ?) = ?)")
		assert.deepEqual(filter.params, ["age", 2, 1])
		return
	)

	it("should be able to accept logical expressions", ->
		filter = new Filter((entity) ->
			entity.age isnt 23 and entity.gender is "MALE"
		)
		assert.strictEqual(filter.sql, "((?? != ?) AND (?? = ?))")
		assert.deepEqual(filter.params, ["age", 23, "gender", "MALE"])

		filter = new Filter((entity) ->
			entity.age is 23 or entity.gender is "FEMALE"
		)
		assert.strictEqual(filter.sql, "((?? = ?) OR (?? = ?))")
		assert.deepEqual(filter.params, ["age", 23, "gender", "FEMALE"])
		return
	)

	it("should be able to understand precedence of && over ||", ->
		filter = new Filter((entity) ->
			entity.age isnt 23 and entity.gender is "MALE" or entity.gender is "FEMALE" and entity.name is "Jane"
		)
		assert.strictEqual(filter.sql, "(((?? != ?) AND (?? = ?)) OR ((?? = ?) AND (?? = ?)))")
		assert.deepEqual(filter.params, ["age", 23, "gender", "MALE", "gender", "FEMALE", "name", "Jane"])
		return
	)

	it("should be able to understand member expressions of 2 levels deep", ->
		filter = new Filter((entity) ->
			entity.person.age is 23
		)
		assert.strictEqual(filter.sql, "(??.?? = ?)")
		assert.deepEqual(filter.params, ["person", "age", 23])

		filter = new Filter((entity) ->
			entity.entity.age is 23
		)
		assert.strictEqual(filter.sql, "(??.?? = ?)")
		assert.deepEqual(filter.params, ["entity", "age", 23])
		return
	)

	it("should be able to accept Math functions", ->
		filter = new Filter((entity) ->
			Math.ceil(entity.weight) < 80
		)
		assert.strictEqual(filter.sql, "(CEIL(??) < ?)")
		assert.deepEqual(filter.params, ["weight", 80])
		return
	)

	it("should be able to accept String functions", ->
		filter = new Filter((entity) ->
			entity.name.contains("mes")
		)
		assert.strictEqual(filter.sql, "(?? LIKE ?)")
		assert.deepEqual(filter.params, ["name", "%mes%"])

		filter = new Filter((entity) ->
			entity.name.startsWith("Jam")
		)
		assert.strictEqual(filter.sql, "(?? LIKE ?)")
		assert.deepEqual(filter.params, ["name", "Jam%"])

		filter = new Filter((entity) ->
			entity.name.endsWith("es")
		)
		assert.strictEqual(filter.sql, "(?? LIKE ?)")
		assert.deepEqual(filter.params, ["name", "%es"])
		return
	)

	it("should be able to distinguish the null value", ->
		filter = new Filter((entity) ->
			entity.email isnt null
		)
		assert.strictEqual(filter.sql, "(?? IS NOT ?)")
		assert.deepEqual(filter.params, ["email", null])
		return
	)

	it("should be able to understand expressions where the literal value is on the left side", ->
		filter = new Filter((entity) ->
			null isnt entity.email
		)
		assert.strictEqual(filter.sql, "(?? IS NOT ?)")
		assert.deepEqual(filter.params, ["email", null])
		return
	)

)