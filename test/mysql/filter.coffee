assert = require("chai").assert
Filter = require("../../src/connectors/mysql/filter")

describe("MySql filter", ->

	it("should be able to understand the !== operator", ->
		assert.doesNotThrow(->
			new Filter("e.age !== 23", "e")
		)
		return
	)

	it("should be able to understand the != operator", ->
		assert.doesNotThrow(->
			new Filter("e.age != 23", "e")
		)
		return
	)

	it("should be able to understand the === operator", ->
		assert.doesNotThrow(->
			new Filter("e.age === 23", "e")
		)
		return
	)

	it("should be able to understand the == operator", ->
		assert.doesNotThrow(->
			new Filter("e.age == 23", "e")
		)
		return
	)

	it("should be able to understand the && operator", ->
		assert.doesNotThrow(->
			new Filter("e.age !== 23 && e.gender === 'MALE'", "e")
		)
		return
	)

	it("should be able to understand the || operator", ->
		assert.doesNotThrow(->
			new Filter("e.age !== 23 || e.gender === 'MALE'", "e")
		)
		return
	)

	it("should be able to understand precedence of && over ||", ->
		filter = new Filter("e.age !== 23 && e.gender === 'MALE' || e.gender === 'FEMALE' && e.email !== '123@abc.com'", "e")
		assert.match(filter.sql, /\(\([^\(]+\) AND \([^\(]+\)\) OR \(\([^\(]+\) AND \([^\(]+\)\)/)
		return
	)

	it("should be able to understand the > operator", ->
		assert.doesNotThrow(->
			new Filter("e.age > 23", "e")
		)
		return
	)

	it("should be able to understand the < operator", ->
		assert.doesNotThrow(->
			new Filter("e.age < 23", "e")
		)
		return
	)

	it("should be able to understand the >= operator", ->
		assert.doesNotThrow(->
			new Filter("e.age > 23", "e")
		)
		return
	)

	it("should be able to understand the <= operator", ->
		assert.doesNotThrow(->
			new Filter("e.age < 23", "e")
		)
		return
	)

	it("should be able to understand the + operator", ->
		assert.doesNotThrow(->
			new Filter("age + 1 < 23")
		)
		return
	)

	it("should be able to understand the - operator", ->
		assert.doesNotThrow(->
			new Filter("e.age - 1 === 23", "e")
		)
		return
	)

	it("should be able to understand the * operator", ->
		assert.doesNotThrow(->
			new Filter("e.age * 3 === 6", "e")
		)
		return
	)

	it("should be able to understand the / operator", ->
		assert.doesNotThrow(->
			new Filter("e.age / 2 === 23", "e")
		)
		return
	)

	it("should be able to understand the % operator", ->
		assert.doesNotThrow(->
			new Filter("e.age % 2 === 1", "e")
		)
		return
	)

	it("should be able to understand member expressions of > 2 levels", ->
		assert.doesNotThrow(->
			new Filter("e.person.age === 10", "e")
		)
		return
	)

	it("should be able to understand member expressions of > 2 levels when the second member equals the entity name", ->
		filter = new Filter("entity.entity.age === 10", "entity")
		assert.match(filter.sql, /^`entity`\./)
		return
	)

	it("should be able to understand Math functions", ->
		assert.doesNotThrow(->
			new Filter("Math.ceil(e.weight) < 80", "e")
		)
		return
	)

	it("should be able to attach contains() on an attribute", ->
		assert.doesNotThrow(->
			new Filter("e.name.contains('mes')", "e")
		)
		return
	)

	it("should be able to attach startsWith() on an attribute", ->
		assert.doesNotThrow(->
			new Filter("e.name.startsWith('Jam')", "e")
		)
		return
	)

	it("should be able to attach endsWith() on an attribute", ->
		assert.doesNotThrow(->
			new Filter("e.name.endsWith('ike')", "e")
		)
		return
	)

	it("should be able to understand the null value", ->
		filter = new Filter("e.email !== null", "e")
		assert.match(filter.sql, /IS NOT \?$/i)
		return
	)

)