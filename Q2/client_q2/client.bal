// =========================
// ballerina/client.bal
// Minimal client that demonstrates calls to the server
// =========================

import ballerina/io;
import ballerina/grpc;

public function main() returns error? {
    // Create a gRPC client pointing to the server
    grpc:Client client = check new ("http://localhost:9090/car_rental");

    // --- Add a car (Admin) ---
    json addReq = {
        car: {
            plate: "ABC123",
            make: "Toyota",
            model: "Corolla",
            year: 2019,
            daily_price: 30.5,
            mileage: 50000,
            status: "AVAILABLE"
        }
    };
    var addRes = client->AddCar(addReq);
    io:println("AddCar response: " + addRes.toJsonString());

    // --- Create Users (streaming) ---
    stream<json, error?> userStream = new stream<json, error?>();
    userStream.publish({ id: "u1", name: "Alice", role: "CUSTOMER" });
    userStream.publish({ id: "u2", name: "Bob", role: "ADMIN" });
    userStream.complete();

    var cuRes = client->CreateUsers(userStream);
    io:println("CreateUsers response: " + cuRes.toJsonString());

    // --- List Available Cars ---
    var listRespStream = client->ListAvailableCars({ query: "" });
    if (listRespStream is stream<json, error?>) {
        var it = listRespStream.getIterator();
        while (it.hasNext()) {
            var nxt = it.next();
            if (nxt is json) {
                io:println("Available Car: " + nxt.toJsonString());
            } else {
                break;
            }
        }
    }

    // --- Search Car by Plate ---
    var searchRes = client->SearchCar({ plate: "ABC123" });
    io:println("SearchCar response: " + searchRes.toJsonString());

    // --- Add to Cart ---
    var atc = client->AddToCart({
        user_id: "u1",
        plate: "ABC123",
        start_date: "2025-09-25",
        end_date: "2025-09-27"
    });
    io:println("AddToCart response: " + atc.toJsonString());

    // --- Place Reservation ---
    var pr = client->PlaceReservation({ user_id: "u1" });
    io:println("PlaceReservation response: " + pr.toJsonString());

    return;
}
