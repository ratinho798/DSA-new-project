import ballerina/grpc;
import ballerina/io;

public type Car record {
    string make;
    string model;
    int year;
    float dailyPrice;
    float mileage;
    string plate;
    string status;
};

public type Reservation record {
    string reservationId;
    string carPlate;
    string customerId;
    string startDate;
    string endDate;
    float totalPrice;
    string status;
};

public type AddCarRequest record {
    Car car;
};

public type AddCarResponse record {
    string plate;
};

public type UpdateCarRequest record {
    string plate;
    Car car;
};

public type UpdateCarResponse record {
    Car car;
};

public type RemoveCarRequest record {
    string plate;
};

public type RemoveCarResponse record {
    Car[] cars;
};

public type ListReservationsRequest record {};

map<Car> carMap = {};
list<Reservation> reservationList = [];

service "CarRentalService" on new grpc:Listener(9090) {

    remote function addCar(AddCarRequest request) returns AddCarResponse|error {
        Car car = request.car;
        
        if car.plate == "" {
            return error(grpc:INVALID_ARGUMENT, "Please provide a license plate number");
        }
        
        if carMap.hasKey(car.plate) {
            return error(grpc:ALREADY_EXISTS, "Car with plate " + car.plate + " already exists");
        }
        
        if car.status != "AVAILABLE" && car.status != "UNAVAILABLE" {
            return error(grpc:INVALID_ARGUMENT, "Status must be AVAILABLE or UNAVAILABLE");
        }
        
        carMap[car.plate] = car;
        return {plate: car.plate};
    }

    remote function updateCar(UpdateCarRequest request) returns UpdateCarResponse|error {
        string plate = request.plate;
        Car car = request.car;
        
        if !carMap.hasKey(plate) {
            return error(grpc:NOT_FOUND, "Car with plate " + plate + " not found");
        }
        
        car.plate = plate;
        
        if car.status != "AVAILABLE" && car.status != "UNAVAILABLE" {
            return error(grpc:INVALID_ARGUMENT, "Status must be AVAILABLE or UNAVAILABLE");
        }
        
        carMap[plate] = car;
        return {car: car};
    }

    remote function removeCar(RemoveCarRequest request) returns RemoveCarResponse|error {
        string plate = request.plate;
        
        if !carMap.hasKey(plate) {
            return error(grpc:NOT_FOUND, "Car with plate " + plate + " not found");
        }
        
        _ = carMap.remove(plate);
        Car[] cars = carMap.values();
        return {cars: cars};
    }

    remote function listReservations(ListReservationsRequest request) returns stream<Reservation, error?>? {
        return reservationList.toStream();
    }
}