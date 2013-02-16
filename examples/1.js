var Naomi = require("../");
var Attribute = Naomi.Attribute;

var db = new Naomi("MYSQL", {
	database: "test",
	username: "root",
	password: "",
	host: "127.0.0.1"
});

var User = db.extend("user", {
	"name": Attribute.integer().max(100),
	"email": Attribute.boolean()
}, {
	engine: Naomi.MYISAM
});

db.sync();

//User.fetch(Query.filter(["id", "=", 10]).order("name").offset(5).limit(1), callback)
//User.fetch().where(["id", "=", 10]).order("name").offset(5).limit(1).execute(callback)
