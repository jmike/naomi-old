assert = require("chai").assert
NumberDatatype = require("../../src/datatypes/number")

describe("Number datatype", ->

	it("should parse '0' as 0", ->
		assert.strictEqual(NumberDatatype.parse("0"), 0)
		return
	)
	
	it("should parse '132.123213' as 132.123213", ->
		assert.strictEqual(NumberDatatype.parse("132.123213"), 132.123213)
		return
	)
	
	it("should parse true as NaN", ->
		assert.strictEqual(isNaN(NumberDatatype.parse(true)), true)
		return
	)
	
	it("should accept null values if nullable", ->
		assert.doesNotThrow(->
			new NumberDatatype()
				.nullable(true)
				.validate(null)
		)
		return
	)
	
	it("should not accept null values if not nullable", ->
		assert.throw(->
			new NumberDatatype()
				.validate(null)
		)
		return
	)
	
	it("should have a precision constraint", ->
		assert.throw(->
			new NumberDatatype()
				.precision(5)
				.validate(100000)
		)
		return
	)
	
	it("should have a scale constraint", ->
		assert.throw(->
			new NumberDatatype()
				.scale(5)
				.validate(100000.213452)
		)
		return
	)
	
	it("should work fine with scale and precision constraints combined", ->
		assert.doesNotThrow(->
			new NumberDatatype()
				.precision(10)
				.scale(5)
				.validate(10000.23452)
		)
		return
	)
	
	it("should accept a minimum allowed value", ->
		assert.throw(->
			new NumberDatatype()
				.min(8.53)
				.validate(4)
		)
		return
	)
	
	it("should accept a maximum allowed value", ->
		assert.throw(->
			new NumberDatatype()
				.max(10)
				.validate(11)
		)
		return
	)
	
	it("should use precision and scale to calculate the maximum allowed value if not explicitely defined", ->
		assert.strictEqual(new NumberDatatype().precision(4).scale(1).max(), 999.9)
		return
	)
	
	it("should use equals to calculate the maximum allowed value if not explicitely defined", ->
		assert.strictEqual(new NumberDatatype().equals(33, 29.78, 1928.9902).max(), 1928.9902)
		return
	)
	
	it("should not be equal to specified value", ->
		assert.throw(->
			new NumberDatatype()
				.notEquals(100.34)
				.validate(100.34)
		)
		return
	)
	
	it("should accept a set of allowed values", ->
		assert.throw(->
			new NumberDatatype()
				.equals(1, 2, 5, 12.4)
				.validate(3)
		)
		return
	)
	
	it("should reject a set of restricted values", ->
		assert.throw(->
			new NumberDatatype()
				.notEquals(1, 2, 5, 12.4)
				.validate(12.4)
		)
		return
	)
	
	it("should throw an error if a restricted value is invalid", ->
		assert.throw(->
			new NumberDatatype()
				.notEquals(1, 2, "5", 12.4)
		)
		return
	)
	

)