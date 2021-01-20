import ballerina/http;
import ballerina/oauth2;
import ballerina/log;
import ballerina/io;

oauth2:OutboundOAuth2Provider oauth2Provider = new ({
    accessToken: "ACCESS_TOKEN_FROM_API",
    refreshConfig: {
        clientId: "CLIENT_ID",
        clientSecret: "CLIENT_SECRET",
        refreshToken: "",
        refreshUrl: "",
        clientConfig: {secureSocket: {trustStore: {
                    path: "/usr/lib/ballerina/distributions/ballerina-slp8/bre/security/ballerinaTruststore.p12",
                    password: "ballerina"
                }}}
    }
});

http:BearerAuthHandler oauth2Handler = new (oauth2Provider);

http:Client clientEP = new ("https://graph.facebook.com/", {
    auth: {authHandler: oauth2Handler},
    secureSocket: {trustStore: {
            path: "/usr/lib/ballerina/distributions/ballerina-slp8/bre/security/ballerinaTruststore.p12",
            password: "ballerina"
        }}
});

service http:Service /fb on new http:Listener(9093) {

    // GET resource
    resource function get me(http:Caller caller, http:Request request) {
        //Response declaration
        http:Response res = new;
        io:println("[GET] My Profile  : ");
        var response = clientEP->get("/me");
        if (response is http:Response) {

            var result = response.getTextPayload();

            res.statusCode = 200;
            res.setJsonPayload(<@untainted><json>result);

            log:print((result is error) ? "Failed to retrieve payload." : result);
        } else {
            log:printError("Error in response");
        }

        //Execute response
        var result = caller->respond(res);

        if (result is error) {
            log:printError("[GET] Error in responding", err = result);
        }
    }
}
