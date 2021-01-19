import ballerina/http;
import ballerina/io;

#######################
# Configuration record
# #####################

public type Config record {
    string apiKey;
};

################
# Client class
################

public client class Client {

    string apiKey;
    http:Client weatherClient;

    public function init(Config config) returns error?{
        self.apiKey = config.apiKey;
        self.weatherClient = new(API_URL);
    }

    remote function getWeatherByCity (string city) returns @tainted json|error {
        http:Request request = new;

        error err;
        string pathBuilder = ENDPOINT+CITY_PARAM+city+APP_ID_PARAM+self.apiKey;
        var response = self.weatherClient->get(pathBuilder);

        if(response is http:Response){
            var code = response.statusCode;
            json | error payload = check response.getJsonPayload();
            if(payload is json) && (code==http:STATUS_OK){
                io:print(payload);
                return payload;
            } else {
                err = error("Error in JSON retreived from weather API : "+ payload.toString());
                return err;
            }
        } else {
            err = error("Error in Response retreived from weather API");
            return err;
        }
    }
}