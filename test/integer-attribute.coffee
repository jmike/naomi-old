assert = require("chai").assert
IntegerAttribute = require("../src/attributes/integer")

describe("Number attribute", ->

	it("should throw an error if name is empty", ->
		assert.throws(-> new IntegerAttribute(""))
		return
	)
	
	it("should throw an error if name is not String", ->
		assert.throws(-> new IntegerAttribute(""))
		return
	)
	
	it("should parse '0' as 0", ->
		assert.equal(new IntegerAttribute("test").parse("0"), 0)
		return
	)
	
	it("should parse '132.123213' as 132.123213", ->
		assert.equal(new IntegerAttribute("test").parse("132.123213"), 132.123213)
		return
	)
	
	it("should parse true as NaN", ->
		assert.strictEqual(isNaN(new IntegerAttribute("test").parse(true)), true)
		return
	)
	
	it("should accept null values if nullable", ->
		assert.doesNotThrow(->
			new IntegerAttribute("test")
				.nullable()
				.validate(null)
		)
		return
	)
	
	it("should not accept null values if not nullable", ->
		assert.throw(->
			new IntegerAttribute("test")
				.validate(null)
		)
		return
	)
	
	it("should reject fractional numbers", ->
		assert.throw(->
			new IntegerAttribute("test")
				.validate(100000.213452)
		)
		return
	)

)