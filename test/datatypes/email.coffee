assert = require("chai").assert
EmailDatatype = require("../../src/datatypes/email")

describe("Email datatype", ->
	
	it("should throw an error if value is not an email", ->
		assert.throws(->
			new EmailDatatype()
				.validate("sadsadsad")
		)
		return
	)

)