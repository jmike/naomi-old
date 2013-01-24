assert = require("chai").assert
BooleanAttribute = require("../src/attributes/boolean")

describe("Boolean attribute", ->

	it("should throw an error if name is empty", ->
		assert.throws(-> new BooleanAttribute(""))
		return
	)
	
	it("should throw an error if name is not String", ->
		assert.throws(-> new BooleanAttribute(""))
		return
	)
	
	it("should parse 0 as false", ->
		assert.equal(new BooleanAttribute("test").parse(0), false)
		return
	)
	
	it("should parse 1 as true", ->
		assert.equal(new BooleanAttribute("test").parse(1), true)
		return
	)
	
	it("should parse '0' as false", ->
		assert.equal(new BooleanAttribute("test").parse("0"), false)
		return
	)
	
	it("should parse '1' as true", ->
		assert.equal(new BooleanAttribute("test").parse("1"), true)
		return
	)
	
	it("should parse 'false' as false", ->
		assert.equal(new BooleanAttribute("test").parse("false"), false)
		return
	)
	
	it("should parse 'tRUe' as true", ->
		assert.equal(new BooleanAttribute("test").parse("tRUe"), true)
		return
	)
	
	it("should parse an empty object as true", ->
		assert.equal(new BooleanAttribute("test").parse({}), true)
		return
	)
	
	it("should parse NaN as false", ->
		assert.equal(new BooleanAttribute("test").parse(NaN), false)
		return
	)
	
	it("should parse null as null", ->
		assert.isNull(new BooleanAttribute("test").parse(null))
		return
	)
	
	it("should parse undefined as null", ->
		assert.isNull(new BooleanAttribute("test").parse())
		return
	)
	
	it("should accept null values if nullable", ->
		assert.doesNotThrow(->
			new BooleanAttribute("test")
				.nullable()
				.validate(null)
		)
		return
	)
	
	it("should not accept null values if not nullable", ->
		assert.throw(->
			new BooleanAttribute("test")
				.validate(null)
		)
		return
	)

)