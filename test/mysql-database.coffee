assert = require("chai").assert
Naomi = require("../src/naomi")
Attribute = Naomi.Attribute

describe("MySql database", ->

	this.timeout(10000)
	
	db = new Naomi("MYSQL", {
		"database": "test",
		"username": "root",
		"password": "",
		"host": "localhost"	
	})
	User = db.extend("user", {
		"name": Attribute.string().maxLength(100)
		"gender": Attribute.string().equals("MALE", "FEMALE")
		"age": Attribute.integer().min(0).max(133)
		"email": Attribute.email()
	}, {
		engine: Naomi.MYISAM
	})
	
	it("should sync fine with remote database", (done) ->
		db.sync((error, data) ->
			assert.strictEqual(error, null)
			done()
		)
	)

)