assert = require("chai").assert
Filter = require("../../src/connectors/mysql/filter")

describe("MySql filter", ->

	it("should be able to understand the !== operator", ->
		assert.doesNotThrow(->
			new Filter("age !== 23")
		)
		return
	)

	it("should be able to understand the != operator", ->
		assert.doesNotThrow(->
			new Filter("age != 23")
		)
		return
	)

	it("should be able to understand the === operator", ->
		assert.doesNotThrow(->
			new Filter("age === 23")
		)
		return
	)
	
	it("should be able to understand the == operator", ->
		assert.doesNotThrow(->
			new Filter("age == 23")
		)
		return
	)

	it("should be able to understand the && operator", ->
		assert.doesNotThrow(->
			new Filter("age !== 23 && gender === 'MALE'")
		)
		return
	)

	it("should be able to understand the || operator", ->
		assert.doesNotThrow(->
			new Filter("age !== 23 || gender === 'MALE'")
		)
		return
	)

	it("should be able to understand precedence of && over ||", ->
		filter = new Filter("age !== 23 && gender === 'MALE' || gender === 'FEMALE' && email !== '123@abc.com'")
		assert.match(filter.sql, /\(\([^\(]+\) AND \([^\(]+\)\) OR \(\([^\(]+\) AND \([^\(]+\)\)/)
		return
	)

	it("should be able to understand the > operator", ->
		assert.doesNotThrow(->
			new Filter("age > 23")
		)
		return
	)

	it("should be able to understand the < operator", ->
		assert.doesNotThrow(->
			new Filter("age < 23")
		)
		return
	)

	it("should be able to understand the >= operator", ->
		assert.doesNotThrow(->
			new Filter("age > 23")
		)
		return
	)

	it("should be able to understand the <= operator", ->
		assert.doesNotThrow(->
			new Filter("age < 23")
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
			new Filter("age - 1 === 23")
		)
		return
	)

	it("should be able to understand the * operator", ->
		assert.doesNotThrow(->
			new Filter("age * 3 === 6")
		)
		return
	)

	it("should be able to understand the / operator", ->
		assert.doesNotThrow(->
			new Filter("age / 2 === 23")
		)
		return
	)

	it("should be able to understand the % operator", ->
		assert.doesNotThrow(->
			new Filter("age % 2 === 1")
		)
		return
	)

	it("should be able to understand the null value", ->
		assert.doesNotThrow(->
			new Filter("email !== null")
		)
		return
	)

	it("should be able to understand Math functions", ->
		assert.doesNotThrow(->
			new Filter("Math.ceil(age) > 14")
		)
		return
	)

)