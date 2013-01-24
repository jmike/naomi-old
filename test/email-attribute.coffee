assert = require("chai").assert
EmailAttribute = require("../src/attributes/email")

describe("Email attribute", ->

	it("should throw an error if name is empty", ->
		assert.throws(-> new EmailAttribute(""))
		return
	)
	
	it("should throw an error if name is not String", ->
		assert.throws(-> new EmailAttribute(""))
		return
	)
	
	it("should throw an error if value is not an email", ->
		assert.throws(->
			new EmailAttribute("test")
				.validate("sadsadsad")
		)
		return
	)

)