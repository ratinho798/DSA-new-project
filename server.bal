import ballerina/http;

// TODO: These types are based on our proto definitions - might need to update later
type Empty record {};

type Car record {
string plate;
string model;
string brand;
float price;
};

type CarList record {
Car[] cars;
};

type CarRequest record {
string plate;
};

type Reservation record {
string plate;
string customerName;
string date;
};

type ReservationList record {
Reservation[] reservations;
};

type ReservationRequest record {
string plate;
string customerName;
};

type Response record {
string message;
};

// Simple in-memory storage 
Car[] carInventory = []; 
Reservation[] bookings = []; 

// Setting up HTTP listener to simulate our gRPC service
listener http:Listener serverEp = new(9090);

service /CarService on serverEp {

smali

// Getting all available cars
resource function get BrowseCars(http:Caller caller, http:Request req) returns error? {
    CarList response = { cars: carInventory };
    check caller->respond(response);
}

// Finding a specific car by plate number
resource function post SearchCar(http:Caller caller, http:Request req) returns error? {
    CarRequest|error carReq = req.getJsonPayload();
    if (carReq is error) {
        check caller->respond({ message: "Invalid request format" });
        return;
    }
    
    Car? foundCar = ();  // Initialize as null
    // Linear search through cars - not as efficient, but works for small datasets
    foreach var vehicle in carInventory {
        if vehicle.plate == carReq.plate {
            foundCar = vehicle;
            break;  // Found it, no need to continue - so we break out
        }
    }
    
    if (foundCar is Car) {
        check caller->respond(foundCar);
    } else {
        check caller->respond({});  // Return empty if car is  not found
    }
}

// Make a reservation for a car
resource function post PlaceReservation(http:Caller caller, http:Request req) returns error? {
    ReservationRequest|error reservationReq = req.getJsonPayload();
    if (reservationReq is error) {
        check caller->respond({ message: "Bad request data" });
        return;
    }
    
    // Note: hardcoding date for now - should probably use current date + some offset
    Reservation newReservation = { 
        plate: reservationReq.plate, 
        customerName: reservationReq.customerName, 
        date: "2025-09-20" 
    };
    bookings.push(newReservation);
    
    Response successMsg = { message: "Reservation placed successfully" };
    check caller->respond(successMsg);
}

// Adding a new car to the inventory
resource function post AddCar(http:Caller caller, http:Request req) returns error? {
    Car|error carData = req.getJsonPayload();
    if (carData is error) {
        check caller->respond({ message: "Invalid car data provided" });
        return;
    }
    
    carInventory.push(carData);
    check caller->respond({ message: "Car added successfully" });
}

// Update any existing car details
resource function post UpdateCar(http:Caller caller, http:Request req) returns error? {
    Car|error updatedCarData = req.getJsonPayload();
    if (updatedCarData is error) {
        check caller->respond({ message: "Invalid update data" });
        return;
    }
    
    boolean wasUpdated = false;
    int index = 0;
    while (index < carInventory.length()) {
        if carInventory[index].plate == updatedCarData.plate {
            carInventory[index] = updatedCarData;
            wasUpdated = true;
            break;
        }
        index = index + 1;
    }
    
    string resultMessage = wasUpdated ? "Car updated successfully" : "Car not found in inventory";
    check caller->respond({ message: resultMessage });
}

// Remove any car from inventory
resource function post RemoveCar(http:Caller caller, http:Request req) returns error? {
    CarRequest|error plateInfo = req.getJsonPayload();
    if (plateInfo is error) {
        check caller->respond({ message: "Invalid plate information" });
        return;
    }
    
    boolean carRemoved = false;
    int idx = 0;
    // Manual iteration to find and remove a car
    while (idx < carInventory.length()) {
        if carInventory[idx].plate == plateInfo.plate {
            _ = carInventory.remove(idx);
            carRemoved = true;
            break;
        }
        idx += 1;
    }
    
    string msg = carRemoved ? "Car removed from inventory" : "Car with that plate not found";
    check caller->respond({ message: msg });
}

// Get all current reservations
resource function get ListReservations(http:Caller caller, http:Request req) returns error? {
    ReservationList allBookings = { reservations: bookings };
    check caller->respond(allBookings);
}
}