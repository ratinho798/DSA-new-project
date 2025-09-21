import ballerina/http;
import ballerina/io; // Need this for println 

// Setting up client to connect to our car service
http:Client carServiceClient = check new("http://localhost:9090/CarService");

// Simple helper to display server responses 
function printResponse(any responsePayload) {
io:println("Server Response: ", responsePayload.toJsonString());
}

// A function to handle errors
function handleError(error e) {
io:println("Oops, something went wrong: ", e.message());
}

public function main() returns error? {
io:println("Starting car service client demo...");

clojure

// Let's add a new car to the inventory
io:println("\n--- Adding a new car ---");
var addCarResponse = carServiceClient->post("/AddCar", { 
    plate: "ABC123", 
    model: "ModelX", 
    brand: "BrandY", 
    price: 10000.0 
});

if (addCarResponse is http:Response) {
    json|error payload = addCarResponse.getJsonPayload();
    if (payload is json) {
        printResponse(payload);
    } else {
        handleError(payload);
    }
}

// What cars are available
io:println("\n--- Browsing available cars ---");
var browseResponse = carServiceClient->get("/BrowseCars");
if (browseResponse is http:Response) {
    json|error carList = browseResponse.getJsonPayload();
    if (carList is json) {
        printResponse(carList);
    } else {
        io:println("Failed to get car list");
    }
}

// Time to make a reservation - Selma(customer) wants this car
io:println("\n--- Making a reservation ---");
json reservationData = { 
    plate: "ABC123", 
    customerName: "Selma" 
};
var reservationResponse = carServiceClient->post("/PlaceReservation", reservationData);

if (reservationResponse is http:Response) {
    json|error resPayload = reservationResponse.getJsonPayload();
    if (resPayload is json) {
        printResponse(resPayload);
    }
}

// Let's check all reservations
io:println("\n--- Checking all reservations ---");
var listResponse = carServiceClient->get("/ListReservations");
if (listResponse is http:Response) {
    json|error reservationList = listResponse.getJsonPayload();
    if (reservationList is json) {
        printResponse(reservationList);
    } else {
        io:println("Couldn't retrieve reservations");
    }
}

io:println("\nDemo completed!");

return;  // Explicit return 
}