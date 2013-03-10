assert = require("chai").assert
Filter = require("../../src/connectors/mysql/filter")
Attribute = require("../../src/attribute")

attributes = {
	"name": Attribute.string().maxLength(100)
	"gender": Attribute.string().equals("MALE", "FEMALE")
	"age": Attribute.integer().min(0).max(133)
	"email": Attribute.email()
}
		
describe("MySql filter", ->
	
	it("should be able to parse !== operator", ->
		assert.doesNotThrow(->
			new Filter("age !== 23", attributes)
		)
		return
	)
	
	it("should be able to parse != operator", ->
		assert.doesNotThrow(->
			new Filter("age != 23", attributes)
		)
		return
	)
	
	it("should be able to parse === operator", ->
		assert.doesNotThrow(->
			new Filter("age === 23", attributes)
		)
		return
	)
	
	it("should be able to parse == operator", ->
		assert.doesNotThrow(->
			new Filter("age == 23", attributes)
		)
		return
	)
	
	it("should be able to parse && operator", ->
		assert.doesNotThrow(->
			new Filter("age !== 23 && gender === 'MALE'", attributes)
		)
		return
	)
	
	it("should be able to parse || operator", ->
		assert.doesNotThrow(->
			new Filter("age !== 23 || gender === 'MALE'", attributes)
		)
		return
	)
	
	it("should understand precedence of && over ||", ->
		filter = new Filter("age !== 23 && gender === 'MALE' || gender === 'FEMALE' && email !== null", attributes)
		assert.match(filter.sql, /\(\([^\(]+\) AND \([^\(]+\)\) OR \(\([^\(]+\) AND \([^\(]+\)\)/)
		return
	)

)