const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });



exports.addCar = functions.https.onCall((data, context) => {
    const users = admin.firestore().collection('users').doc(data['email']).collection('cars');
    return users.add({
        carMake: data['carMake'],
        carModel: data['carModel'],
        regNo: data['regNo']
    }).then(() => {
        return {
            message: 'Success'
        }
    }).catch(err => {
        return err;
    });
});