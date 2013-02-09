assert = require("chai").assert
StringDatatype = require("../src/datatypes/string")

describe("String datatype", ->

	it("should parse 0 as '0'", ->
		assert.strictEqual(StringDatatype.parse(0), "0")
		return
	)
	
	it("should parse 132.123213 as '132.123213'", ->
		assert.strictEqual(StringDatatype.parse(132.123213), "132.123213")
		return
	)
	
	it("should parse true as 'true'", ->
		assert.strictEqual(StringDatatype.parse(true), "true")
		return
	)
	
	it("should accept null values if nullable", ->
		assert.doesNotThrow(->
			new StringDatatype()
				.nullable(true)
				.validate(null)
		)
		return
	)
	
	it("should not accept null values if not nullable", ->
		assert.throw(->
			new StringDatatype()
				.validate(null)
		)
		return
	)
	
	it("should have a minimum length constraint", ->
		assert.throw(->
			new StringDatatype()
				.minLength(3)
				.validate("a")
		)
		return
	)
	
	it("should have a maximum length constraint", ->
		assert.throw(->
			new StringDatatype()
				.maxLength(3)
				.validate("abcd")
		)
		return
	)
	
	it("should have an exact length constraint", ->
		assert.throw(->
			new StringDatatype()
				.length(3)
				.validate("abcd")
		)
		return
	)
	
	it("should be not be equal to a specified value", ->
		assert.throw(->
			new StringDatatype()
				.notEquals("abcd")
				.validate("abcd")
		)
		return
	)
	
	it("should accept a set of allowed values", ->
		assert.throw(->
			new StringDatatype()
				.equals("a", "b", "c", "d")
				.validate("abcd")
		)
		return
	)
	
	it("should accept a set of restricted values", ->
		assert.throw(->
			new StringDatatype()
				.notEquals("a", "b", "c", "d")
				.validate("a")
		)
		return
	)
	
	it("should accept an infinite number of allowed values", ->
		attr = new StringDatatype()
			.equals("a", "b", "c", "d")
		assert.strictEqual(attr.options.equals.length, 4)
		return
	)
	
	it("should be able to match a regex", ->
		assert.throw(->
			new StringDatatype()
				.regex(/^[a-z]+$/)
				.validate("asd3")
		)
		return
	)
	
	it("should be able to not match a regex", ->
		assert.throw(->
			new StringDatatype()
				.notRegex(/^[a-z]+$/)
				.validate("asd")
		)
		return
	)
	
	it("should contain a specified value", ->
		assert.throw(->
			new StringDatatype()
				.contains("zzz")
				.validate("asd3")
		)
		return
	)
	
	it("should not contain a specified value", ->
		assert.throw(->
			new StringDatatype()
				.notContains("as")
				.validate("asd")
		)
		return
	)

)