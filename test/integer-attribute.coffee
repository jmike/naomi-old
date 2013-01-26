assert = require("chai").assert
IntegerAttribute = require("../src/attributes/integer")

describe("Integer attribute", ->
	
	it("should parse '0' as 0", ->
		assert.strictEqual(IntegerAttribute.parse("0"), 0)
		return
	)
	
	it("should parse '132.123213' as 132.123213", ->
		assert.strictEqual(IntegerAttribute.parse("132.123213"), 132.123213)
		return
	)
	
	it("should parse true as NaN", ->
		assert.strictEqual(isNaN(IntegerAttribute.parse(true)), true)
		return
	)
	
	it("should accept null values if nullable", ->
		assert.doesNotThrow(->
			new IntegerAttribute()
				.nullable()
				.validate(null)
		)
		return
	)
	
	it("should not accept null values if not nullable", ->
		assert.throw(->
			new IntegerAttribute()
				.validate(null)
		)
		return
	)
	
	it("should reject fractional numbers", ->
		assert.throw(->
			new IntegerAttribute()
				.validate(100000.213452)
		)
		return
	)
	
	it("should not allow it's 'scale' property to change", ->
		attr = new IntegerAttribute().scale(35)
		assert.strictEqual(attr.options.scale, 0)
		return
	)

)