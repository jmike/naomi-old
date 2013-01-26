assert = require("chai").assert
StringAttribute = require("../src/attributes/string")

describe("String attribute", ->

	it("should parse 0 as '0'", ->
		assert.strictEqual(StringAttribute.parse(0), "0")
		return
	)
	
	it("should parse 132.123213 as '132.123213'", ->
		assert.strictEqual(StringAttribute.parse(132.123213), "132.123213")
		return
	)
	
	it("should parse true as 'true'", ->
		assert.strictEqual(StringAttribute.parse(true), "true")
		return
	)
	
	it("should accept null values if nullable", ->
		assert.doesNotThrow(->
			new StringAttribute()
				.nullable()
				.validate(null)
		)
		return
	)
	
	it("should not accept null values if not nullable", ->
		assert.throw(->
			new StringAttribute()
				.validate(null)
		)
		return
	)
	
	it("should have a minimum length constraint", ->
		assert.throw(->
			new StringAttribute()
				.minLength(3)
				.validate("a")
		)
		return
	)
	
	it("should have a maximum length constraint", ->
		assert.throw(->
			new StringAttribute()
				.maxLength(3)
				.validate("abcd")
		)
		return
	)
	
	it("should have an exact length constraint", ->
		assert.throw(->
			new StringAttribute()
				.length(3)
				.validate("abcd")
		)
		return
	)
	
	it("should be not be equal to a specified value", ->
		assert.throw(->
			new StringAttribute()
				.notEquals("abcd")
				.validate("abcd")
		)
		return
	)
	
	it("should accept a set of allowed values", ->
		assert.throw(->
			new StringAttribute()
				.isIn("a", "b", "c", "d")
				.validate("abcd")
		)
		return
	)
	
	it("should accept a set of restricted values", ->
		assert.throw(->
			new StringAttribute()
				.notIn("a", "b", "c", "d")
				.validate("a")
		)
		return
	)
	
	it("should be able to match a regex", ->
		assert.throw(->
			new StringAttribute()
				.regex(/^[a-z]+$/)
				.validate("asd3")
		)
		return
	)
	
	it("should be able to not match a regex", ->
		assert.throw(->
			new StringAttribute()
				.notRegex(/^[a-z]+$/)
				.validate("asd")
		)
		return
	)
	
	it("should contain a specified value", ->
		assert.throw(->
			new StringAttribute()
				.contains("zzz")
				.validate("asd3")
		)
		return
	)
	
	it("should not contain a specified value", ->
		assert.throw(->
			new StringAttribute()
				.notContains("as")
				.validate("asd")
		)
		return
	)

)