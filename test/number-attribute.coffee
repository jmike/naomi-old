assert = require("chai").assert
NumberAttribute = require("../src/attributes/number")

describe("Number attribute", ->

	it("should throw an error if name is empty", ->
		assert.throws(-> new NumberAttribute(""))
		return
	)
	
	it("should throw an error if name is not String", ->
		assert.throws(-> new NumberAttribute(""))
		return
	)
	
	it("should parse '0' as 0", ->
		assert.equal(NumberAttribute.parse("0"), 0)
		return
	)
	
	it("should parse '132.123213' as 132.123213", ->
		assert.equal(NumberAttribute.parse("132.123213"), 132.123213)
		return
	)
	
	it("should parse true as NaN", ->
		assert.strictEqual(isNaN(NumberAttribute.parse(true)), true)
		return
	)
	
	it("should accept null values if nullable", ->
		assert.doesNotThrow(->
			new NumberAttribute("test")
				.nullable()
				.validate(null)
		)
		return
	)
	
	it("should not accept null values if not nullable", ->
		assert.throw(->
			new NumberAttribute("test")
				.validate(null)
		)
		return
	)
	
	it("should have a precision constraint", ->
		assert.throw(->
			new NumberAttribute("test")
				.precision(5)
				.validate(100000)
		)
		return
	)
	
	it("should have a scale constraint", ->
		assert.throw(->
			new NumberAttribute("test")
				.scale(5)
				.validate(100000.213452)
		)
		return
	)
	
	it("should work fine with scale and precision constraints combined", ->
		assert.doesNotThrow(->
			new NumberAttribute("test")
				.precision(10)
				.scale(5)
				.validate(10000.23452)
		)
		return
	)
	
	it("should accept a minimum allowed value", ->
		assert.throw(->
			new NumberAttribute("test")
				.min(8.53)
				.validate(4)
		)
		return
	)
	
	it("should accept a maximum allowed value", ->
		assert.throw(->
			new NumberAttribute("test")
				.max(10)
				.validate(11)
		)
		return
	)
	
	it("should not be equal to specified value", ->
		assert.throw(->
			new NumberAttribute("test")
				.notEquals(100.34)
				.validate(100.34)
		)
		return
	)
	
	it("should accept a set of allowed values", ->
		assert.throw(->
			new NumberAttribute("test")
				.isIn(1, 2, 5, 12.4)
				.validate(3)
		)
		return
	)
	
	it("should reject a set of restricted values", ->
		assert.throw(->
			new NumberAttribute("test")
				.notIn(1, 2, 5, 12.4)
				.validate(12.4)
		)
		return
	)
	

)