assert = require("chai").assert
BooleanAttribute = require("../src/attributes/boolean")

describe("Boolean attribute", ->
	
	it("should parse 0 as false", ->
		assert.strictEqual(BooleanAttribute.parse(0), false)
		return
	)
	
	it("should parse 1 as true", ->
		assert.strictEqual(BooleanAttribute.parse(1), true)
		return
	)
	
	it("should parse '0' as false", ->
		assert.strictEqual(BooleanAttribute.parse("0"), false)
		return
	)
	
	it("should parse '1' as true", ->
		assert.strictEqual(BooleanAttribute.parse("1"), true)
		return
	)
	
	it("should parse 'false' as false", ->
		assert.strictEqual(BooleanAttribute.parse("false"), false)
		return
	)
	
	it("should parse 'tRUe' as true", ->
		assert.strictEqual(BooleanAttribute.parse("tRUe"), true)
		return
	)
	
	it("should parse an empty object as true", ->
		assert.strictEqual(BooleanAttribute.parse({}), true)
		return
	)
	
	it("should parse NaN as false", ->
		assert.strictEqual(BooleanAttribute.parse(NaN), false)
		return
	)
	
	it("should parse null as null", ->
		assert.isNull(BooleanAttribute.parse(null))
		return
	)
	
	it("should parse undefined as null", ->
		assert.isNull(BooleanAttribute.parse())
		return
	)
	
	it("should accept null values if nullable", ->
		assert.doesNotThrow(->
			new BooleanAttribute()
				.nullable()
				.validate(null)
		)
		return
	)
	
	it("should not accept null values if not nullable", ->
		assert.throw(->
			new BooleanAttribute()
				.validate(null)
		)
		return
	)

)