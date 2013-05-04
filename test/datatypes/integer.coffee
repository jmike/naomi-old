assert = require("chai").assert
NumberDatatype = require("../../src/datatypes/number")
IntegerDatatype = require("../../src/datatypes/integer")

describe("Integer datatype", ->
	
	it("should parse '0' as 0", ->
		assert.strictEqual(IntegerDatatype.parse("0"), 0)
		return
	)
	
	it("should parse '132.123213' as 132.123213", ->
		assert.strictEqual(IntegerDatatype.parse("132.123213"), 132)
		return
	)
	
	it("should parse true as NaN", ->
		assert.strictEqual(isNaN(IntegerDatatype.parse(true)), true)
		return
	)
	
	it("should accept null values if nullable", ->
		assert.doesNotThrow(->
			new IntegerDatatype()
				.nullable(true)
				.validate(null)
		)
		return
	)
	
	it("should not accept null values if not nullable", ->
		assert.throw(->
			new IntegerDatatype()
				.validate(null)
		)
		return
	)
	
	it("should reject fractional numbers", ->
		assert.throw(->
			new IntegerDatatype()
				.validate(100000.213452)
		)
		return
	)
	
	it("should not allow it's 'scale' property to change", ->
		attr = new IntegerDatatype().scale(35)
		assert.strictEqual(attr.scale(), 0)
		return
	)
	
	it("should be an instance of number datatype with zero (0) scale", ->
		attr = new IntegerDatatype()
		assert.isTrue(attr instanceof NumberDatatype, 0)
		assert.strictEqual(attr.scale(), 0)
		return
	)
	
	it("should inherit max() from number", ->
		attr = new IntegerDatatype().max(100)
		assert.strictEqual(attr.max(), 100)
		return
	)

)