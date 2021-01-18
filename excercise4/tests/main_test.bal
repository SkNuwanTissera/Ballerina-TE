#############################################################
# Please start the server on Excercise 2 before building this.
# (excercise2) > ballerina build
# (excercise2) > ballerina run target/bin/excercise2.jar
#############################################################

import ballerina/http;
import ballerina/test;
import ballerina/log;

http:Client httpClientEndpoint = new ("http://localhost:9090");

Customer customer1 ={
    _id:9,
    name:"Nuwan Tissera",
    country:"SL",
    email:"sliit.sk95@gmail.com"
};

@test:Config{}
public function testAddCustomer(){
    http:Request req = new;

    json jsonRequest = {name:customer1.name, country:customer1.country, email:customer1?.email};

    req.setJsonPayload(jsonRequest);
    var res = httpClientEndpoint -> post("/customerAPI/customer", req);
    if(res is http:Response){
        var jsonResponse = res.getJsonPayload();
        log:print("Status Code : "+ res.statusCode.toString()+ " Message : "+ jsonResponse.toString());
    }
    else{
        log:printError("Test Request Failed");
        test:assertFail(res.toString());
    }
}


@test:Config{
    dependsOn:["testAddCustomer"]
}
public function testGetCustomer(){
    var res = httpClientEndpoint -> get("/customerAPI/customer/" + customer1?._id.toString());

    if(res is http:Response){
        var jsonResponse = res.getJsonPayload();
        if(jsonResponse is json){
            log:print("Status Code : "+ res.statusCode.toString()+ " Message : "+ jsonResponse.toString());
        }
        else{
            log:print("Status Code : "+ res.statusCode.toString()+ " Message : Malformed payload recieved");
        }
    }
    else{
        log:printError("Test Request Failed");
        test:assertFail(res.toString());
    }
}
