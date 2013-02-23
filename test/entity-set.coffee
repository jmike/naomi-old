assert = require("chai").assert
EntitySet = require("../src/entity-set")
StringDatatype = require("../src/datatypes/string")

test = new EntitySet("test", {
	name: new StringDatatype().nullable(true).maxLength(100)
}, {
	engine: "MYISAM"
})
	
describe("Entity set", ->
	
	it("should accept a valid filter", ->
		assert.doesNotThrow(->
			test.filter("entity.name === 'Mitsos'")
		)
		return
	)
	
	it("should reject an invalid filter", ->
		assert.throws(->
			test.filter("entity.name @#& 'Mitsos'")
		)
		return
	)

)