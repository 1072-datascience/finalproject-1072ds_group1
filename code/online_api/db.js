var MongoClient = require('mongodb').MongoClient;

// Connect to the db
MongoClient.connect("mongodb://localhost:27017", function(err, db) {
    if (err) throw err;
    //Write databse Insert/Update/Query code here..
    console.log('mongodb is running!');
    const mydb = db.db('testDB2');
    mydb.collection('Persons', function(err, collection) {
        collection.insertOne({ firstName: 'Steve', lastName: 'Jobs' });
        collection.insertOne({ firstName: 'Bill', lastName: 'Gates' });
        collection.insertOne({ firstName: 'James', lastName: 'Bond' });

        collection.count(function(err, count) {
            if (err) throw err;
            console.log('Total Rows:' + count);
        });
    });
    mydb.collection('Persons', function(err, collection) {
        collection.remove({ id: 1 }, { w: 1 }, function(err, result) {
            if (err) throw err;
            console.log('Document Removed Successfully!');
        });
    });
    mydb.collection("Persons", function(err, collection) {
        collection.find({ firstName: "Bill" }).toArray(function(err, items) {
            if (err) throw err;
            console.log(items);
            console.log("We found " + items.length + " results!");
        });

    });
    mydb.collection('Persons', function(err, collection) {
        //collection.update
        //第一個參數是要更新的條件，第二個參數$set:更新的欄位及內容.
        //第三個參數writeConcern，第四個參數執行update後的callback函式
        collection.update({ firstName: 'Bill' }, { $set: { firstName: 'James', lastName: 'Gosling' } }, { w: 1 }, function(err, result) {
            if (err) throw err;
            console.log('Document Updated Successfully');
        });
    });
    db.close(); //關閉連線
});