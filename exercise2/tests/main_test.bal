import ballerina/http;
import ballerina/test;
import ballerina/log;

http:Client endpoint = new ("http://localhost:9090/customerAPI");

Customer customer1 = {
    _id: 1,
    name: "Nuwan Tissera",
    country: "SL",
    email: "sliit.sk95@gmail.com"
};

@test:Config {}
public function testAddCustomer() {

    http:Request req = new;
    req.setJsonPayload(customer1);
    var response = endpoint->post("/customer", req);

    if (response is http:Response) {
        var res = response.getJsonPayload();
        log:print("Status : " + response.statusCode.toString() + " JSON : " + res.toString());
    } else {
        test:assertFail(msg = "[POST TEST FAILED] AssertFailed");
        log:printError("[POST TEST FAILED] Add customer failed !!");
    }
}

@test:Config {dependsOn: ["testAddCustomer"]}
public function testGetCustomer() {

    http:Request req = new;

    var response = endpoint->get("/customer/1");

    if (response is http:Response) {
        var res = response.getJsonPayload();
        log:print("Status : " + response.statusCode.toString() + " JSON : " + res.toString());
    } else {
        test:assertFail(msg = "[GET TEST FAILED] AssertFailed");
        log:printError("[GET TEST FAILED] Get customer failed !!");
    }
}
