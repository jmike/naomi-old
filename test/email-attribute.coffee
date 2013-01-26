assert = require("chai").assert
EmailAttribute = require("../src/attributes/email")

describe("Email attribute", ->
	
	it("should throw an error if value is not an email", ->
		assert.throws(->
			new EmailAttribute()
				.validate("sadsadsad")
		)
		return
	)

)