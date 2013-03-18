assert = require("chai").assert
Filter = require("../../src/connectors/mysql/filter")

describe("MySql filter", ->

	it("should be able to understand the !== operator", ->
		filter = new Filter("e.age !== 23", "e")
		assert.strictEqual(filter.sql, "`age` != ?")
		assert.strictEqual(filter.params[0], 23)
		return
	)

	it("should be able to understand the != operator", ->
		filter = new Filter("e.age != 23", "e")
		assert.strictEqual(filter.sql, "`age` != ?")
		assert.strictEqual(filter.params[0], 23)
		return
	)

	it("should be able to understand the === operator", ->
		filter = new Filter("e.age === 23", "e")
		assert.strictEqual(filter.sql, "`age` = ?")
		assert.strictEqual(filter.params[0], 23)
		return
	)

	it("should be able to understand the == operator", ->
		filter = new Filter("e.age == 23", "e")
		assert.strictEqual(filter.sql, "`age` = ?")
		assert.strictEqual(filter.params[0], 23)
		return
	)

	it("should be able to understand the && operator", ->
		filter = new Filter("e.age !== 23 && e.gender === 'MALE'", "e")
		assert.strictEqual(filter.sql, "(`age` != ?) AND (`gender` = ?)")
		assert.strictEqual(filter.params[0], 23)
		assert.strictEqual(filter.params[1], "MALE")
		return
	)

	it("should be able to understand the || operator", ->
		filter = new Filter("e.age !== 23 || e.gender === 'MALE'", "e")
		assert.strictEqual(filter.sql, "(`age` != ?) OR (`gender` = ?)")
		assert.strictEqual(filter.params[0], 23)
		assert.strictEqual(filter.params[1], "MALE")
		return
	)

	it("should be able to understand precedence of && over ||", ->
		filter = new Filter("e.age !== 23 && e.gender === 'MALE' || e.gender === 'FEMALE' && e.email !== '123@abc.com'", "e")
		assert.strictEqual(filter.sql, "((`age` != ?) AND (`gender` = ?)) OR ((`gender` = ?) AND (`email` != ?))")
		assert.strictEqual(filter.params[0], 23)
		assert.strictEqual(filter.params[1], "MALE")
		assert.strictEqual(filter.params[2], "FEMALE")
		assert.strictEqual(filter.params[3], "123@abc.com")
		return
	)

	it("should be able to understand the > operator", ->
		filter = new Filter("e.age > 23", "e")
		assert.strictEqual(filter.sql, "`age` > ?")
		assert.strictEqual(filter.params[0], 23)
		return
	)

	it("should be able to understand the < operator", ->
		filter = new Filter("e.age < 23", "e")
		assert.strictEqual(filter.sql, "`age` < ?")
		assert.strictEqual(filter.params[0], 23)
		return
	)

	it("should be able to understand the >= operator", ->
		filter = new Filter("e.age >= 23", "e")
		assert.strictEqual(filter.sql, "`age` >= ?")
		assert.strictEqual(filter.params[0], 23)
		return
	)

	it("should be able to understand the <= operator", ->
		filter = new Filter("e.age <= 23", "e")
		assert.strictEqual(filter.sql, "`age` <= ?")
		assert.strictEqual(filter.params[0], 23)
		return
	)

	it("should be able to understand the + operator", ->
		filter = new Filter("age + 1 < 23")
		assert.strictEqual(filter.sql, "`age` + ? < ?")
		assert.strictEqual(filter.params[0], 1)
		assert.strictEqual(filter.params[1], 23)
		return
	)

	it("should be able to understand the - operator", ->
		filter = new Filter("e.age - 1 === 23", "e")
		assert.strictEqual(filter.sql, "`age` - ? = ?")
		assert.strictEqual(filter.params[0], 1)
		assert.strictEqual(filter.params[1], 23)
		return
	)

	it("should be able to understand the * operator", ->
		filter = new Filter("e.age * 3 === 6", "e")
		assert.strictEqual(filter.sql, "`age` * ? = ?")
		assert.strictEqual(filter.params[0], 3)
		assert.strictEqual(filter.params[1], 6)
		return
	)

	it("should be able to understand the / operator", ->
		filter = new Filter("e.age / 2 === 23", "e")
		assert.strictEqual(filter.sql, "`age` / ? = ?")
		assert.strictEqual(filter.params[0], 2)
		assert.strictEqual(filter.params[1], 23)
		return
	)

	it("should be able to understand the % operator", ->
		filter = new Filter("e.age % 2 === 1", "e")
		assert.strictEqual(filter.sql, "`age` % ? = ?")
		assert.strictEqual(filter.params[0], 2)
		assert.strictEqual(filter.params[1], 1)
		return
	)

	it("should be able to understand member expressions of > 2 levels", ->
		filter = new Filter("e.person.age === 10", "e")
		assert.strictEqual(filter.sql, "`person`.`age` = ?")
		assert.strictEqual(filter.params[0], 10)
		return
	)

	it("should be able to understand member expressions of > 2 levels when the second member equals the entity name", ->
		filter = new Filter("entity.entity.age === 10", "entity")
		assert.strictEqual(filter.sql, "`entity`.`age` = ?")
		assert.strictEqual(filter.params[0], 10)
		return
	)

	it("should be able to understand Math functions", ->
		filter = new Filter("Math.ceil(e.weight) < 80", "e")
		assert.strictEqual(filter.sql, "CEIL(`weight`) < ?")
		assert.strictEqual(filter.params[0], 80)
		return
	)

	it("should be able to attach contains() on an attribute", ->
		filter = new Filter("e.name.contains('mes')", "e")
		assert.strictEqual(filter.sql, "`name` LIKE ?")
		assert.strictEqual(filter.params[0], "%mes%")
		return
	)

	it("should be able to attach startsWith() on an attribute", ->
		filter = new Filter("e.name.startsWith('Jam')", "e")
		assert.strictEqual(filter.sql, "`name` LIKE ?")
		assert.strictEqual(filter.params[0], "Jam%")
		return
	)

	it("should be able to attach endsWith() on an attribute", ->
		filter = new Filter("e.name.endsWith('ike')", "e")
		assert.strictEqual(filter.sql, "`name` LIKE ?")
		assert.strictEqual(filter.params[0], "%ike")
		return
	)

	it("should be able to understand the null value", ->
		filter = new Filter("e.email !== null", "e")
		assert.strictEqual(filter.sql, "`email` IS NOT ?")
		assert.strictEqual(filter.params[0], null)
		return
	)

	it("should be able to understand expressions where the literal value is on the left side", ->
		filter = new Filter("null !== e.email", "e")
		assert.strictEqual(filter.sql, "? IS NOT `email`")
		assert.strictEqual(filter.params[0], null)
		return
	)

)