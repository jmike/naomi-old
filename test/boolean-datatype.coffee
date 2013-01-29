assert = require("chai").assert
BooleanDatatype = require("../src/datatypes/boolean")

describe("Boolean datatype", ->
	
	it("should parse 0 as false", ->
		assert.strictEqual(BooleanDatatype.parse(0), false)
		return
	)
	
	it("should parse 1 as true", ->
		assert.strictEqual(BooleanDatatype.parse(1), true)
		return
	)
	
	it("should parse '0' as false", ->
		assert.strictEqual(BooleanDatatype.parse("0"), false)
		return
	)
	
	it("should parse '1' as true", ->
		assert.strictEqual(BooleanDatatype.parse("1"), true)
		return
	)
	
	it("should parse 'false' as false", ->
		assert.strictEqual(BooleanDatatype.parse("false"), false)
		return
	)
	
	it("should parse 'tRUe' as true", ->
		assert.strictEqual(BooleanDatatype.parse("tRUe"), true)
		return
	)
	
	it("should parse an empty object as true", ->
		assert.strictEqual(BooleanDatatype.parse({}), true)
		return
	)
	
	it("should parse NaN as false", ->
		assert.strictEqual(BooleanDatatype.parse(NaN), false)
		return
	)
	
	it("should parse null as null", ->
		assert.isNull(BooleanDatatype.parse(null))
		return
	)
	
	it("should parse undefined as null", ->
		assert.isNull(BooleanDatatype.parse())
		return
	)
	
	it("should accept null values if nullable", ->
		assert.doesNotThrow(->
			new BooleanDatatype()
				.nullable()
				.validate(null)
		)
		return
	)
	
	it("should not accept null values if not nullable", ->
		assert.throw(->
			new BooleanDatatype()
				.validate(null)
		)
		return
	)

)