// Example express application adding the parse-server module to expose Parse
// compatible API routes.

var express     = require('express');
var ParseServer = require('parse-server').ParseServer;
var path        = require('path');

//var databaseUri = process.env.DATABASE_URI || process.env.MONGODB_URI;
//
//if (!databaseUri) {
//  console.log('DATABASE_URI not specified, falling back to localhost.');
//}

var api = new ParseServer({
  databaseURI : 'mongodb://gellert:5917738ljh@ds031975.mlab.com:31975/uniplus',
  cloud       : process.env.CLOUD_CODE_MAIN || './cloud/main.js',
  appId       : process.env.APP_ID || 'ycUcZbElpxaa0UbV5wUGpGvjaj2wIbauRCyJFUyG',
  masterKey   : process.env.MASTER_KEY || 'OxPlldKK0wVIjVDJgZxTGrXA1PzhJaXu7u4P2dik', //Add your master key here. Keep it secret!
  fileKey     : process.env.FILE_KEY || 'cfdb4ad8-6c05-4ef7-b4c2-4aad24fcd65c', // Add the file key to provide access to files already hosted on Parse
  serverURL   : process.env.SERVER_URL || 'http://uniplusserver.herokuapp.com/parse',  // Don't forget to change to https if needed
  liveQuery   : {
        classNames: ["Posts", "Comments"] // List of classes to support for query subscriptions
    },
  push        : {
                ios: [
                  {
                    pfx        : './Cert/ShutteradioPushCert.p12', // Dev PFX or P12
                    bundleId   : 'com.Quicky.Shutteradio',
                    production : false,
                    //adaptor    : ParsePushAdapter
                  },
                  {
                    pfx        : './Cert/ShutteradioProductionPush.p12', // Prod PFX or P12
                    bundleId   : 'com.Quicky.Shutteradio',  
                    production : true, // Prod
                    //adaptor    : ParsePushAdapter
                  }
                ]
    }
});
// Client-keys like the javascript key or the .NET key are not necessary with parse-server
// If you wish you require them, you can set them as options in the initialization above:
// javascriptKey, restAPIKey, dotNetKey, clientKey

var app = express();

// Serve static assets from the /public folder
app.use('/public', express.static(path.join(__dirname, '/public')));

// Serve the Parse API on the /parse URL prefix
var mountPath = process.env.PARSE_MOUNT || '/parse';
app.use(mountPath, api);

// Parse Server plays nicely with the rest of your web routes
app.get('/', function(req, res) {
  res.status(200).send('Make sure to star the parse-server repo on GitHub!');
});

// There will be a test page available on the /test path of your server url
// Remove this before launching your app
app.get('/test', function(req, res) {
  res.sendFile(path.join(__dirname, '/public/test.html'));
});

var port = process.env.PORT || 1337;
var httpServer = require('http').createServer(app);
httpServer.listen(port, function() {
    console.log('parse-server-example running on port ' + port + '.');
});

// This will enable the Live Query real-time server
ParseServer.createLiveQueryServer(httpServer);
