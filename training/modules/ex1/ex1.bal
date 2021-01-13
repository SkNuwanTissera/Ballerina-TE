import ballerina/io;
import ballerina/http;

// Variable to handle customer data
map<json> data = {};

// public function main() {
//     io:println("STARTED");
// }

service http:Service /customerAPI on new http:Listener(9090) {

    resource function get customer/[int id] (http:Caller caller, http:Request request, string customerId) {
        io:println("GET");
    }

}
