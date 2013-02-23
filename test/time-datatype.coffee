assert = require("chai").assert
TimeDatatype = require("../src/datatypes/time")

describe("Time datatype", ->

	it("should be able to parse '22:35:34'", ->
		assert.strictEqual(TimeDatatype.parse("22:35:34").getTime(), -62167145066000)
		return
	)
	
	it("should be able to parse '22:59'", ->
		assert.strictEqual(TimeDatatype.parse("22:59").getTime(), -62167143660000)
		return
	)
	
	it("should be able to parse '13'", ->
		assert.strictEqual(TimeDatatype.parse("13").getTime(), -62167179600000)
		return
	)

)