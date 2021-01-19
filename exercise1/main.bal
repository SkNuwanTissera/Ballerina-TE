import ballerina/io;
import ballerina/http;
import ballerina/log;

// Variable to handle customer data
map<json> data = {};

// Customer Object
type Customer record {|
    int _id;
    string name;
    string country;
    string email;
|};


service http:Service /customerAPI on new http:Listener(9091) {

    // GET resource
    resource function get customer/[int _id] (http:Caller caller, http:Request request) {

        io:println("[GET] _cusomerID : ", _id);

        //Response declaration
        http:Response res=new;
        res.setJsonPayload(_id.toString());
        
        if(_id > 0){
            json? customer = data[_id.toString()];
            if (customer is ()){
                res.statusCode=404;
                res.setJsonPayload("[GET] Customer Not found !! ");
                log:printError("[GET] Customer Not found !!");
            } else {
               res.statusCode=200;
               res.setJsonPayload(<@untainted><json>customer);
            }
        } else {
            res.statusCode=400;
            res.setJsonPayload("[GET] Invalid !! CustomerID should be a number more than 0");
            log:printError("[GET] CustomerID should be a number more than 0");
        }

        //Execute response
        var result = caller->respond(res);

        if (result is error) {
           log:printError("[GET] Error in responding", err = result);
        }
        
    }

    // POST resource
    resource function post customer (http:Caller caller, http:Request request) {
        
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
                var cusId = payload._id;
                var cusName = payload.name;
                var cusEmail = payload.email;
                var cusCountry = payload.country;

                Customer cus = {_id:<int> cusId, name: <string>cusName, email: <string> cusEmail, country: <string> cusCountry};

                data[cusId.toString()] = <@untainted> cus;
                res.statusCode=201;
                res.setJsonPayload({status:"Successfully Saved", customerId: <@untainted> cusId.toString(), customerName: <@untainted> cusName.toString()});
                io:println("[POST] Successfully Saved ___data____ : ", <@untainted> cus);
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
                res.setJsonPayload("[PUT] Empty JSON !!");
                log:printError("[PUT] Empty JSON !!");
            }
            else {
                // Map values from payload to type Customer
                var cusId = payload._id;
                var cusName = payload.name;
                var cusEmail = payload.email;
                var cusCountry = payload.country;

                Customer cus = {_id:<int> cusId, name: <string>cusName, email: <string> cusEmail, country: <string> cusCountry};

                data[_id.toString()] = <@untainted> cus;
         
                res.statusCode=201;
                res.setJsonPayload({status:"Successfully Modified", customerId: <@untainted> cusId.toString(), customerName: <@untainted> cusName.toString()});
                io:println("[PUT] Successfully Modified");
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

}
