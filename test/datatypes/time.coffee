assert = require("chai").assert
TimeDatatype = require("../../src/datatypes/time")

describe("Time datatype", ->

	it("should be able to parse '22:35:34'", ->
		time = TimeDatatype.parse("22:35:34")
		assert.strictEqual(time.getHours(), 22)
		assert.strictEqual(time.getMinutes(), 35)
		assert.strictEqual(time.getSeconds(), 34)
		return
	)
	
	it("should be able to parse '22:59'", ->
		time = TimeDatatype.parse("22:35")
		assert.strictEqual(time.getHours(), 22)
		assert.strictEqual(time.getMinutes(), 35)
		assert.strictEqual(time.getSeconds(), 0)
		return
	)
	
	it("should be able to parse '13'", ->
		time = TimeDatatype.parse("13")
		assert.strictEqual(time.getHours(), 13)
		assert.strictEqual(time.getMinutes(), 0)
		assert.strictEqual(time.getSeconds(), 0)
		return
	)

)