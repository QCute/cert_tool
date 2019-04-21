// https-server.js
var https = require('https');
var fs = require('fs');
var args = process.argv.splice(2);

var options = {
    key: fs.readFileSync(args[0] + '.key'),
    cert: fs.readFileSync(args[0] + '.crt')
};

https.createServer(options, function(req, res) {
    res.writeHead(200);
    res.end('hello world');
}).listen(8000, function(){
    console.log('Open URL: https://' + args[0] + ':8000');
});