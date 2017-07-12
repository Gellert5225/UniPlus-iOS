Parse.Cloud.define('hello', function(req, res) {
  res.success('Hi');
});

Parse.Cloud.define("testPush", function(request, response) {
    Parse.Cloud.useMasterKey();
    var username = request.params.user;
    var query = new Parse.Query(Parse.User);
    query.equalTo('username', username);

    var pushQuery = new Parse.Query(Parse.Installation);
    //pushQuery.matchesQuery("user", query);

    Parse.Push.send({
        where: pushQuery,
        data: {
            alert: "This is a test push to test localhost"
        }
    }, {
        success: function() {
            // Push was successful
            console.log("#### PUSH OK");
        },
        error: function(error) {
            // Handle error
            console.log("#### PUSH ERROR" + error.message);
        },useMasterKey:true
    });
    response.success('success');
});

Parse.Cloud.define("testPushToCurrentUser", function(request, response) {
    Parse.Cloud.useMasterKey();

    var query = new Parse.Query(Parse.Installation);
    query.equalTo('user', request.user);

    Parse.Push.send({
        where: query,
        data: {
            alert: "This is a test push to test currentUser"
        }
    }, {
        success: function() {
            // Push was successful
            console.log("#### PUSH OK");
        },
        error: function(error) {
            // Handle error
            console.log("#### PUSH ERROR" + error.message);
        },useMasterKey:true
    });
    response.success('success');
});

//increment user reputation
Parse.Cloud.define("changeReputation", function(request, response) {
    var userId = request.params.userId;
    var repChange = request.params.repChange;

    var User = Parse.Object.extend("_User");
    var user = new User({ objectId: userId });

    user.increment("reputation", repChange);

    Parse.Cloud.useMasterKey();
    user.save().then(function(user) {
        console.log("Hooray");
        response.success(user);
    }, function(error) {
        response.error(error)
    });
});

Parse.Cloud.define("commentNotification", function(request, response) {
    Parse.Cloud.useMasterKey();
    var targetUser = request.params.targetUser;
    var message = request.params.message;
    
    var userQuery = new Parse.Query(Parse.User);
    userQuery.equalTo("objectId", targetUser);

    var pushQuery = new Parse.Query(Parse.Installation);
    pushQuery.matchesQuery("user", userQuery);
    
    if (request.user.id !== targetUser) {
        Parse.Push.send({
            where: pushQuery,
            data: {
                alert: message
            }
        }, {
            success: function() {
                // Push was successful
                console.log("#### PUSH OK");
            },
            error: function(error) {
                // Handle error
                console.log("#### PUSH ERROR" + error.message);
            },useMasterKey:true
        });
        response.success('success');
    } else {
        response.success('will not send push');
    }
});

// Parse.Cloud.define("upVote", function(request, response) {
//     Parse.Cloud.useMasterKey();

    
// });

// Parse.Cloud.define("setCorrectAnswer", function(request, response) {
//     var correctID = request.params.answerID;

//     var answerQuery = new Parse.Query(Parse.Answers);
//     query.get(correctID, {
//         success: function(gameScore) {
//             // The object was retrieved successfully.

//         },
//         error: function(object, error) {
            
//         }
//     });
// });