class Entity

	###*
	* Constructs a new entity of the specified properties.
	* @param name {string} the name of the entity.
	* @param attributes {object=} the entity's attributes (optional).
	* @param options {object=} key/value settings (optional).
	###
	constructor: (name, attributes = {}, options = {}) ->
	
	fetch: -> null
	count: -> null
	destroy: -> null
	update: -> null
	create: -> null
	
module.exports = Entity

#User = Naomi.extend("user", [
#	Attribute.string("name").maxLength(100)
#	Attribute.email("email")
#], {
#	engine: Naomi.MYISAM
#})
#User.fetch(Query.filter(["id", "=", 10]).order("name").offset(5).limit(1), callback)
#User.fetch().where(["id", "=", 10]).order("name").offset(5).limit(1).execute(callback)
