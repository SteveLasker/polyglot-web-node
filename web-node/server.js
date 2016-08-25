var os = require('os');
var request = require('request');
var morgan = require('morgan');
var express = require('express');
var app = express();

app.use(express.static(__dirname + '/public'));
app.use(require("morgan")("dev"));

// #######################################
// Default content page
// #######################################
app.get('/', function (req, res) {
    res.sendFile(__dirname + '/public/index.html');
});

// #######################################
// Call the WebAPI for information
// #######################################
// build up the URL using environment info
var apiPort = process.env.APIPORT || 80
var apiURL = process.env.APIURL || "apidotnet"
var requestApi = "http://"+apiURL+":"+apiPort+"/api/hello";
app.get('/api', function (req, res) {
    request(requestApi, function (error, response, body) {
        res.send('From api-dotnet: ' + body);
    });    
});

// #######################################
// Start the web server
// #######################################
// Set the web server listenting port, based on an environment var
// default to the local 3000 port
var port = process.env.HTTPPORT || 3000;
app.listen(port, function () {
    console.log("Listening on port " + port);
});
