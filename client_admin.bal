import ballerina/io;
import stubs/car_service_pb;   // generated stubs for gRPC calls

public function main() returns error? {

    // Hardcoding the URL later move it to config
    car_service_pb:CarServiceClient carClient = check new("http://localhost:50051");

    while true {
        // Simple menu loop, nothing fancy
        io:println("");
        io:println("==== Admin Menu ====");
        io:println("1. Add Car");
        io:println("2. Update Car");
        io:println("3. Remove Car");
        io:println("4. Show Reservations");  // slight change
        io:println("5. Quit");

        string userInput = io:readln("Enter your choice: ");

        match userInput {
            "1" => {
                // Collect details for new car
                string p = io:readln("Plate: ");
                string m = io:readln("Model: ");
                string b = io:readln("Brand: ");
                decimal priceVal = decimal:fromString(io:readln("Price: "));

                // just calling the stub here
                var addResult = carClient->AddCar({ plate: p, model: m, brand: b, price: priceVal });
                if addResult is car_service_pb:Response {
                    io:println(">> ", addResult.message);   // prefixed with >>
                } else {
                    io:println("Oops, failed to add car."); // unlikely, but whatever
                }
            }
            "2" => {
                // This is almost the same as add, could be reused... but let's duplicate for now
                string plateNo = io:readln("Plate: ");
                string mdl = io:readln("Model: ");
                string brandNm = io:readln("Brand: ");
                decimal cost = decimal:fromString(io:readln("Price: "));

                var updRes = carClient->UpdateCar({ plate: plateNo, model: mdl, brand: brandNm, price: cost });
                if updRes is car_service_pb:Response {
                    io:println(">> ", updRes.message);
                }
            }
            "3" => {
                // Remove an existing car
                string removePlate = io:readln("Plate to delete: ");  // slightly different wording
                var rmResult = carClient->RemoveCar({ plate: removePlate });
                if rmResult is car_service_pb:Response {
                    io:println(rmResult.message);
                } else {
                    io:println("Something went wrong while removing.");
                }
            }
            "4" => {
                // showing all reservations
                var listResp = carClient->ListReservations({});  // empty request 
                if listResp is car_service_pb:ReservationList {
                    if listResp.reservations.length() == 0 {
                        io:println("No reservations yet.");
                    } else {
                        // printing line by line
                        foreach var r in listResp.reservations {
                            io:println("Customer: ", r.customerName, " | Car: ", r.plate, " | Date: ", r.date);
                        }
                    }
                }
            }
            "5" => {
                io:println("Goodbye!");
                break;   // just using break here instead of return, more natural in a loop
            }
            _ => {
                // fallthrough case
                io:println("Not a valid option, try again.");
            }
        }
    }

    // NOTE: probably should close client here, but leaving as is for now
}
