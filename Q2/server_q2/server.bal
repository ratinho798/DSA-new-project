import ballerina/grpc;
import ballerina/log;

type Car record {|
    string plate;
    string make;
    string model;
    int year;
    float dailyPrice;
    int mileage;
    string status; // AVAILABLE or UNAVAILABLE
|};

type User record {|
    string id;
    string name;
    string role; // ADMIN or CUSTOMER
|};

type CartItem record {|
    string plate;
    string startDate;
    string endDate;
|};

type Reservation record {|
    string userId;
    string plate;
    string startDate;
    string endDate;
    float totalPrice;
|};

service "CarRental" on new grpc:Listener(9090) {

    // In-memory storage
    private map<Car> cars = {};
    private map<User> users = {};
    private map<CartItem[]> carts = {};
    private Reservation[] reservations = [];

    // Add car
    remote function add_car(Car car) returns string {
        cars[car.plate] = car;
        log:printInfo("Car added: " + car.plate);
        return car.plate;
    }

    // Create multiple users
    remote function create_users(stream<User, string> clientStream) returns string|error {
        stream<User, error?>? incoming = check clientStream.receiveStream();
        error? e = incoming.forEach(function(User u) {
            users[u.id] = u;
            log:printInfo("User created: " + u.name);
        });
        if e is error {
            return e;
        }
        return "Users created successfully";
    }

    // Update car
    remote function update_car(Car car) returns string {
        if cars.hasKey(car.plate) {
            cars[car.plate] = car;
            return "Car " + car.plate + " updated successfully";
        }
        return "Car not found";
    }

    // Remove car
    remote function remove_car(string plate) returns stream<Car, error?> {
        if cars.hasKey(plate) {
            cars.remove(plate);
        }
        return getCarStream();
    }

    // List available cars
    remote function list_available_cars(string filter) returns stream<Car, error?> {
        return getCarStream(filter);
    }

    // Search car
    remote function search_car(string plate) returns Car|string {
        if cars.hasKey(plate) {
            return cars[plate];
        }
        return "Car not available";
    }

    // Add to cart
    remote function add_to_cart(string userId, CartItem item) returns string {
        if !cars.hasKey(item.plate) {
            return "Car does not exist";
        }
        var userCart = carts[userId];
        if userCart is () {
            carts[userId] = [item];
        } else {
            userCart.push(item);
            carts[userId] = userCart;
        }
        return "Car added to cart";
    }

    // Place reservation
    remote function place_reservation(string userId) returns Reservation[]|string {
        var cart = carts[userId];
        if cart is () {
            return "No items in cart";
        }
        Reservation[] newReservations = [];
        foreach var item in cart {
            if !cars.hasKey(item.plate) {
                return "Car " + item.plate + " no longer exists";
            }
            Car c = cars[item.plate];
            if c.status != "AVAILABLE" {
                return "Car " + c.plate + " is unavailable";
            }
            // Calculate days
            int days = 1; // Simplified: real-world needs date diff calculation
            float total = days * c.dailyPrice;
            Reservation r = {
                userId: userId,
                plate: c.plate,
                startDate: item.startDate,
                endDate: item.endDate,
                totalPrice: total
            };
            reservations.push(r);
            newReservations.push(r);
            // Mark car unavailable
            c.status = "UNAVAILABLE";
            cars[c.plate] = c;
        }
        carts.remove(userId);
        return newReservations;
    }

    // Helper: Stream cars
    function getCarStream(string filter = "") returns stream<Car, error?> {
        stream<Car, error?> s = new;
        var _ = start s.send(cars.values().toArray());
        return s;
    }
}
