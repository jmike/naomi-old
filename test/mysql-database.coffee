assert = require("chai").assert
Naomi = require("../src/naomi")
Attribute = Naomi.Attribute

# create new Naomi database
db = new Naomi("MYSQL", {
	"database": "naomi_test",
	"username": "root",
	"password": "",
	"host": "127.0.0.1"	
})

# add table to database
user = db.extend("user", {
	"name": Attribute.string().maxLength(100)
	"gender": Attribute.string().equals("MALE", "FEMALE")
	"age": Attribute.integer().min(0).max(133)
	"email": Attribute.email()
}, {
	engine: Naomi.MYISAM
})
	
describe("MySql database", ->

	this.timeout(10000)
	
	it("should sync fine with remote database", (done) ->
		db.sync((error, data) ->
			assert.strictEqual(error, null)
			done()
		)
	)
	
	it("should be able to fetch records from the remote database", (done) ->
		user.filter((e) -> e.id > 2).fetch((error, data) ->
			assert.strictEqual(error, null)
			done()
		)
	)

)