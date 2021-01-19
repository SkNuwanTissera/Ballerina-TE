import ballerina/sql;
import ballerina/jdbc;
import ballerina/log;

// Customer Object
public type Customer record {|
    int _id;
    string name;
    string country;
    string email;
|};

// Database Configuration
public type DatabaseConfig record {
    string dbUrl;
    string username;
    string password;
};

// Client Initialization
public client class Client{
    
    jdbc:Client jdbcClient;

    public function init(DatabaseConfig config)returns error?{
        self.jdbcClient = check new(config.dbUrl,config.username,config.password);
        log:print("DB connected !!");
    }
    // GET customer
    remote function getCustomer(string customerId)returns @untainted json|error{

        // Query | DB to stream
        stream<record{}, error> rs = self.jdbcClient->query(`SELECT * FROM Customer WHERE Id=${<@untainted>customerId}`);

        //Map resultset to type Customer
        record {|record{} value;|}? entry = check rs.next();

        if (entry is record{|record{} value;|}) {
            json|error result=entry.value.cloneWithType(json);
            if (result is error) {
                log:printError(result.toString());
                return error("Error parsing the result to JSON");
            }else{
                return <@untainted>result;
            }
        }else{
            log:printError(entry.toString());
            return error("Error: customer not found");
        }
    }

    // POST customer
    remote function addCustomer(Customer customer) returns string|error?{
        var result = self.jdbcClient->execute(`INSERT INTO Customer(name, country, email) VALUES(${<@untainted>customer.name},${<@untainted>customer.country},${<@untainted>customer?.email})`);

        if result is sql:ExecutionResult{
            return "Customer "+<@untainted> customer.name+" is added successfully!"; 
        }else{
            log:printError(result.toString());
            return result.toString();
        }
    }

    // PUT customer
    remote function updateCustomer(Customer customer, string customerId) returns string|error?{
        
        var result = self.jdbcClient->execute(`UPDATE Customer SET name=${<@untainted> customer.name}, country=${<@untainted> customer.country}, email=${<@untainted> customer.email} WHERE Id = ${<@untainted>customerId}`);

        if result is sql:ExecutionResult{
            return "Customer "+<@untainted> customer.name+" is updated successfully!"; 
        } else {
            log:printError(result.toString());
            return result.toString();
        }
    }

    // DELETE customer
    remote function deleteCustomer(string customerId) returns string|error? {

        var result = self.jdbcClient->execute(`DELETE FROM Customer WHERE Id=${<@untainted> customerId}`);
        if result is sql:ExecutionResult {
            return "Customer ID"+<@untainted> customerId+" is deleted successfully!";
        } else {
            log:printError(result.toString());
            return result.toString();
        }
    }

}