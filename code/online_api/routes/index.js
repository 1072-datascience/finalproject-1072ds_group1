var express = require('express');
var router = express.Router();
var MongoClient = require('mongodb').MongoClient;
var exec = require('child_process').exec;


/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'colgate hi' ,message: ''});
});

router.get('/signup', function(req, res, next) {
  res.render('create_account', {message: ''});
});

router.get('/home', function(req, res, next) {
  res.render('login_success', { title: 'success' ,name: req.session.name});
});

router.post('/result', function(req, res, next) {
  if(req.body.GRE_Score) gre = req.body.GRE_Score 
  else gre = ' '
  if(req.body.TOEFL_Score) toefl = req.body.TOEFL_Score 
  else toefl = ' '
  if(req.body.University_Rating) university = req.body.University_Rating 
  else university = ' '
  if(req.body.SOP) sop = req.body.SOP 
  else sop = ' '
  if(req.body.LOR) lor = req.body.LOR 
  else lor = ' '
  if(req.body.CGPA) cgpa = req.body.CGPA 
  else cgpa = ' '
  if(req.body.Research) research = req.body.Research 
  else research = ' ' 
  // var toefl = req.body.TOEFL_Score;
  // var university = req.body.University_Rating;
  // var sop = req.body.SOP;
  // var lor = req.body.LOR
  // var cgpa = req.body.CGPA;
  // var research = req.body.Research;
  // if(req.body.GRE_Score) ? req.body.GRE_Score : ' '
  // console.log(gre)
  var filename = '/Users/sam/Desktop/UCLA_admissions/colgateDemo/script/model.py'
  exec('python3'+' '+filename+' '+gre+' '+toefl+' '+university+' '+sop+' '+lor+' '+cgpa+' '+research,function(err,stdout,stderr){  
  // exec('python'+' '+filename+' '+arg1+' '+arg2,function(err,stdout,stderr){             
	if(stdout){
	    console.log("py success", stdout);
	    res.render('result', { title: 'colgate hi' ,name: req.session.name ,GRE: gre ,TOEFL: toefl ,University_Rating: university ,SOP: sop ,LOR: lor ,CGPA: cgpa ,RESEARCH: research ,admission: stdout});
	} 
	    if(err){console.log("py fail", err);}
	});
  
});

router.post('/create', function(req, res, next) {
    var account = req.body.username;
    var password = req.body.password;
    MongoClient.connect("mongodb://localhost:27017", function(err, db) {
        if (err) throw err;
        console.log('mongodb is running!');
        const mydb = db.db('testDB');
        mydb.collection('Persons', function(err, collection) {
            collection.insertOne({ Name: account, Password: password });

            collection.count(function(err, count) {
                if (err) throw err;
                console.log('Total Rows:' + count);
            });
            // collection.find({ Name: account }).toArray(function(err, items) {
            //     if (items.length === 0){
            //       collection.insertOne({ Name: account, Password: password });
            //       res.render('index', { title: 'colgate hi', message: '' });
            //     }
            //     else {
            //       res.render('create_account', {message: 'this account name has been used'});
            //     }
            //     console.log(items.length)
            // });
            
        });

        db.close();
    });
    res.render('index', { title: 'colgate hi', message: '' });
});

router.post('/login', function(req, res, next) {
    var account = req.body.username;
    var password = req.body.password;
    console.log("name : " + account + " password : " + password);
    MongoClient.connect("mongodb://localhost:27017", function(err, db) {
        if (err) throw err;
        //Write databse Insert/Update/Query code here..
        console.log('mongodb is running!');
        const mydb = db.db('testDB');
        mydb.collection("Persons", function(err, collection) {
            collection.find({ Name: account , Password: password}).toArray(function(err, items) {
                if (items.length === 0) res.render('index',{title: 'colgate hi', message: 'your account is not exist or your password is incorrect'});
                else {
                	req.session.name = account;
                	res.render('login_success', { title: 'success' ,name: account});
                }
                console.log(items.length)
            });
        });

        db.close();
    });

});
module.exports = router;
