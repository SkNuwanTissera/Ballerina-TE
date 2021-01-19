# Learning Ballerina
### Description
#### Exercise 1
Implement a Ballerina service which allows following RESTful operations. Use an in-memory storage to store the customer details.
GET /customer/{id}
POST /customer
PUT /customer/{id}

#### Exercise 2
Extend the Exercise 1 to use a database to store the customer information
Database : Mysql JDBC
GET /customer/{id}
POST /customer
PUT /customer/{id}

#### Exercise 3
Write a ballerina program to invoke an API secured with Oauth2. It should be able to handle the case of expired tokens.
I have used Graph API to build a connector to facebook.

#### Exercise 4
Build a connector to a database system.
I have build a connector to JDBC mysql system.

#### Exercise 5
Build a connector to a webAPI (weather API)
I used openweathermap.org API for this purpose.

### Run
```
ballerina build
ballerina run target\bin\<jar_name>.jar
```

### Version
Ballerina Swan Lake Preview 8

### Syntax Help
Refer https://ballerina.io/swan-lake/learn/by-example

