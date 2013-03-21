assert = require("chai").assert
Map = require("../../src/connectors/mysql/map")

describe("MySql map", ->

	it("should be able to work", ->
		map = new Map("obj = {id: entity.id, name: entity.name}", "entity")
		assert.strictEqual(map.sql, "`id` AS 'id'")
		assert.strictEqual(map.params.length, 0)
		return
	)

)