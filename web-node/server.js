var os = require('os');
var request = require('request');
var morgan = require('morgan');
var express = require('express');
var app = express();

app.use(express.static(__dirname + '/public'));
app.use(require("morgan")("dev"));

app.get('/api', function (req, res) {
    request('http://api-dotnet:5000/api/hello', function (error, response, body) {
        res.send('From api-dotnet: ' + body);
    });    
});

app.get('/', function (req, res) {
    res.sendFile(__dirname + '/public/index.html');
});

var port = process.env.PORT || 8080;
app.listen(port, function () {
    console.log("Listening on port " + port);
});
