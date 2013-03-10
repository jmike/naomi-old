assert = require("chai").assert
Naomi = require("../../src/naomi")
Filter = require("../../src/connectors/mysql/filter")
Attribute = Naomi.Attribute

filter = new Filter({
	"name": Attribute.string().maxLength(100)
	"gender": Attribute.string().equals("MALE", "FEMALE")
	"age": Attribute.integer().min(0).max(133)
	"email": Attribute.email()
}, "entity.age !== 23")

describe("MySql filter", ->
	
#	it("should parse 0 as false", ->
#		assert.strictEqual(BooleanDatatype.parse(0), false)
#		return
#	)

)