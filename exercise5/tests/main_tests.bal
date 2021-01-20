import ballerina/io;
import ballerina/test;

string city = "Colombo";

##########################################
# Obtain a API keys afer signup
# https://home.openweathermap.org/api_keys
##########################################
Config config = {apiKey: "OPENWEATHER_API_KEY"};

Client wclient = check new (config);

##############
# TESTS
#############
@test:Config {}
function testGetWeatherByCity() {
    json|error res = wclient->getWeatherByCity(city);
    io:print(res);
}
