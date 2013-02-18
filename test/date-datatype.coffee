assert = require("chai").assert
DateDatatype = require("../src/datatypes/date")

describe("Date datatype", ->

	it("should be able to parse '2013-02-18'", ->
		assert.strictEqual(DateDatatype.parse("2013-02-18").getTime(), 1361138400000)
		return
	)
	
	it("should be able to parse '2013-02-18T23:03:01+0200'", ->
		assert.strictEqual(DateDatatype.parse("2013-02-18T23:03:01+0200").getTime(), 1361221381000)
		return
	)
	
	it("should be able to parse '2013-02-18 23:11:34'", ->
		assert.strictEqual(DateDatatype.parse("2013-02-18 23:11:34").getTime(), 1361221894000)
		return
	)
	
	it("should accept null values if nullable", ->
		assert.doesNotThrow(->
			new DateDatatype()
				.nullable(true)
				.validate(null)
		)
		return
	)
	
	it("should not accept null values if not nullable", ->
		assert.throw(->
			new DateDatatype()
				.validate(null)
		)
		return
	)

)