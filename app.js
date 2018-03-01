if( !/[0-9]{4}/.test(process.argv[2]) ){
	console.log("Port number must be provided as first parameter");
	process.exit(-1);
}else if(process.argv[3] === undefined){
	console.log("Folder name must be provided as second parameter");
	process.exit(-1);
}

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
	console.log("Hosting "+app.get('staticFolder'));
});