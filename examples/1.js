var Naomi = require("../")

var naomi = new Naomi("MYSQL", {
	database: "test",
	username: "root",
	password: "",
	host: "127.0.0.1"
});
//naomi.extend("user", {
//	first_name: 
//})

//User = Naomi.extend("user", {
//	"name": new StringAttribute.maxLength(100)
//	"email": new EmailAttribute.nullable().maxLength(150)
//}, {
//	engine: Naomi.MYISAM
//})
//User.fetch(Query.filter(["id", "=", 10]).order("name").offset(5).limit(1), callback)
//User.fetch().where(["id", "=", 10]).order("name").offset(5).limit(1).execute(callback)
