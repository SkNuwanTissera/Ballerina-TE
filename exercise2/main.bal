import ballerina/io;
import ballerina/http;
import ballerina/log;
import ballerina/jdbc;

// DB clients

//JDBC
jdbc:Client dbClient =check new("jdbc:mysql://localhost:3306/training","root","");

//H2
// jdbc:Client dbClient = check new ("jdbc:h2:file:./target/sample1");

// Customer Object
type Customer record {|
    int _id;
    string name;
    string country;
    string email;
|};


service http:Service /customerAPI on new http:Listener(9090) {

    // GET resource - GET customer by ID
    resource function get customer/[int _id] (http:Caller caller, http:Request request) returns @untainted error?{

        io:println("[GET] _cusomerID : ", _id);

        // Query | DB to stream
        stream<record{}, error> resultStream = dbClient->query(`SELECT * FROM Customer WHERE Id = ${_id.toString()}`);

        //Map resultset to type Customer
        record {|record{} value;|}? entry = check resultStream.next();

        if (entry is record{|record{} value;|}) {
            io:println(entry.value);
            json|error r = entry.value.cloneWithType(json);
            if (r is error) {
                check caller->notFound();
            }else{
                check caller->ok(<@untainted>r);
            }
        }else{
            check caller->notFound();
        }
    }

    // GET resource - GET all customers
    resource function get customer/all (http:Caller caller, http:Request request) returns @untainted error?{

        io:println("[GET] _getAllCustomers");

        // Query | DB to stream
        stream<record{}, error> resultStream = dbClient->query(`SELECT * FROM Customer`);

        json[] data = [];

        error? e = resultStream.forEach(function(record {} result) {
            var cusObj = result.cloneWithType(json);
            if (cusObj is error){
                log:printError("[GET] Error in retreiving customer object");
            } else {
                data.push(cusObj);
            }
        }); 

        check caller->ok(<@untainted> data);

    }

    // POST resource
     resource function post customer (http:Caller caller, http:Request request) returns @untainted error?{
        json|error payload = request.getJsonPayload();

        http:Response res = new;

        if (payload is json) {
            if(payload is ()){
                res.statusCode=400;
                res.setJsonPayload("[POST] Empty JSON !!");
                log:printError("[POST] Empty JSON !!");
            }
            else {
                // Map values from payload to type Customer
                // var cusId = payload._id;
                var cusName = payload.name;
                var cusEmail = payload.email;
                var cusCountry = payload.country;

                 _ = check dbClient->execute(`INSERT INTO Customer(Name, Country, Email) VALUES(${<@untainted> <string>cusName},${<@untainted> <string>cusCountry},${<@untainted> <string>cusEmail})`);

                res.statusCode=201;
                res.setJsonPayload({status:"Successfully Saved", payload: <@untainted> payload});
                io:println("[POST] Successfully Saved ___data____ : ", <@untainted> payload);
            }

        } else {
            res.statusCode=400;
            res.setJsonPayload("[POST] Invalid JSON");
            log:printError("[POST] Invalid JSON");
        }

        var result = caller->respond(res);

        if (result is error) {
           log:printError("[POST] Error in responding", err = result);
        }
     }

    // PUT resource
    resource function put customer/[int _id] (http:Caller caller, http:Request request){
        json|error payload = request.getJsonPayload();

        http:Response res = new;

        if (payload is json) {
            if(payload is ()){
                res.statusCode=400;
                res.setJsonPayload("[POST] Empty JSON !!");
                log:printError("[POST] Empty JSON !!");
            }
            else {
                // Map values from payload to type Customer
                // var cusId = payload._id;
                var cusName = payload.name;
                var cusEmail = payload.email;
                var cusCountry = payload.country;

                var objj = dbClient->execute(`UPDATE Customer SET Name = ${<@untainted> <string>cusName} , Email = ${<@untainted> <string>cusEmail}, Country = ${<@untainted> <string>cusCountry} WHERE Id = ${_id.toString()} `);
                 
                res.statusCode=201;
                res.setJsonPayload({status:"Successfully Updated", payload: <@untainted> payload});
                io:println("[POST] Successfully Updated ___data____ : ", <@untainted> payload);
            }

        } else {
            res.statusCode=400;
            res.setJsonPayload("[POST] Invalid JSON");
            log:printError("[POST] Invalid JSON");
        }

        var result = caller->respond(res);

        if (result is error) {
           log:printError("[POST] Error in responding", err = result);
        }
    }

    //DELETE resource
    resource function delete customer/delete/[int _id] (http:Caller caller, http:Request request) returns error?{  

        http:Response res = new;
        
        _ = check dbClient->execute(`DELETE FROM Customer WHERE Id=${<@untainted>_id.toString()}`);

        res.statusCode=201;
        res.setJsonPayload({status:"[DELETE] Successfully Deleted" , _Id : _id.toString()});
        io:println("[DELETE] Successfully Deleted _customerID : ",_id.toString());

        var result = caller->respond(res);

        if (result is error) {
           log:printError("[DELETE] Error in responding", err = result);
        }
    }

}
