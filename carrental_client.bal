import ballerina/io;

CarRentalClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    AddCarRequest addCarRequest = {car: {plate: "ballerina", make: "ballerina", model: "ballerina", year: 1, daily_price: 1, status: "CAR_STATUS_UNSPECIFIED", mileage: 1, description: "ballerina"}};
    AddCarResponse addCarResponse = check ep->AddCar(addCarRequest);
    io:println(addCarResponse);

    UpdateCarRequest updateCarRequest = {plate: "ballerina", updated_car: {plate: "ballerina", make: "ballerina", model: "ballerina", year: 1, daily_price: 1, status: "CAR_STATUS_UNSPECIFIED", mileage: 1, description: "ballerina"}};
    UpdateCarResponse updateCarResponse = check ep->UpdateCar(updateCarRequest);
    io:println(updateCarResponse);

    RemoveCarRequest removeCarRequest = {plate: "ballerina"};
    RemoveCarResponse removeCarResponse = check ep->RemoveCar(removeCarRequest);
    io:println(removeCarResponse);

    SearchCarRequest searchCarRequest = {plate: "ballerina"};
    SearchCarResponse searchCarResponse = check ep->SearchCar(searchCarRequest);
    io:println(searchCarResponse);

    AddToCartRequest addToCartRequest = {user_id: "ballerina", item: {plate: "ballerina", start_date: [1659688553, 0.310073000d], end_date: [1659688553, 0.310073000d]}};
    AddToCartResponse addToCartResponse = check ep->AddToCart(addToCartRequest);
    io:println(addToCartResponse);

    PlaceReservationRequest placeReservationRequest = {user_id: "ballerina"};
    PlaceReservationResponse placeReservationResponse = check ep->PlaceReservation(placeReservationRequest);
    io:println(placeReservationResponse);

    ListReservationsRequest listReservationsRequest = {admin_user_id: "ballerina"};
    stream<ListReservationsResponse, error?> listReservationsResponse = check ep->ListReservations(listReservationsRequest);
    check listReservationsResponse.forEach(function(ListReservationsResponse value) {
        io:println(value);
    });

    ListAvailableCarsRequest listAvailableCarsRequest = {filter: "ballerina"};
    stream<ListAvailableCarsResponse, error?> listAvailableCarsResponse = check ep->ListAvailableCars(listAvailableCarsRequest);
    check listAvailableCarsResponse.forEach(function(ListAvailableCarsResponse value) {
        io:println(value);
    });

    CreateUsersRequest createUsersRequest = {user: {user_id: "ballerina", name: "ballerina", email: "ballerina", role: "USER_ROLE_UNSPECIFIED"}};
    CreateUsersStreamingClient createUsersStreamingClient = check ep->CreateUsers();
    check createUsersStreamingClient->sendCreateUsersRequest(createUsersRequest);
    check createUsersStreamingClient->complete();
    CreateUsersResponse? createUsersResponse = check createUsersStreamingClient->receiveCreateUsersResponse();
    io:println(createUsersResponse);
}
