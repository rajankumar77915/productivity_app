# productivity_app

Achieve a balanced, healthy, and stress-free life with the Productivity App. This application is built with a Flutter/Dart front-end, a Node.js/Express back-end, and MongoDB as the database. The app is securely implemented with JWT middleware for authentication.


## Live Demo
https://github.com/rajankumar77915/productivity_app/assets/105460862/24830581-513c-4abb-977a-1f3f9bda53bd

### Backend Repository
You can find the back-end code here: [Productivity Server Repository](https://github.com/rajankumar77915/productivityServer)

### Configuration

#### env.dart


String api = "https://productivityserver.onrender.com";

## Note:
if your backend localHost and You want to start in your physical phone then do below things for api
for androild mobile :
     go cmd and write ipconfig
     get IPv4 Address

otherwise 
for emulator:
     IPv4 Address=10.0.2.2

## backend .env example
```
PORT = 3000
DATABASE_URL = 'mongodb://localhost:27017/Productivity'
JWT_SECRET ='your_jwt'
