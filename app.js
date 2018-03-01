const express = require('express');
const app = express();
app.set("port", process.argv[2] || 3000);
app.set("staticFolder", process.argv[3] || "public");

app.use("/",express.static(app.get("staticFolder")));

app.use("/getPort",(req,res)=>{
	res.end(req.app.get("port"));
})

app.listen(app.get('port'),()=>{
	console.log("listening on port "+app.get('port'));
});