import ballerina/grpc;
import ballerina/protobuf;
import ballerina/time;

public const string CAR_RENTAL_DESC = "0A106361725F72656E74616C2E70726F746F120C63617272656E74616C2E76311A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F22E7010A0343617212140A05706C6174651801200128095205706C61746512120A046D616B6518022001280952046D616B6512140A056D6F64656C18032001280952056D6F64656C12120A0479656172180420012805520479656172121F0A0B6461696C795F7072696365180520012801520A6461696C795072696365122F0A0673746174757318062001280E32172E63617272656E74616C2E76312E436172537461747573520673746174757312180A076D696C6561676518072001280352076D696C6561676512200A0B6465736372697074696F6E180820012809520B6465736372697074696F6E22750A045573657212170A07757365725F6964180120012809520675736572496412120A046E616D6518022001280952046E616D6512140A05656D61696C1803200128095205656D61696C122A0A04726F6C6518042001280E32162E63617272656E74616C2E76312E55736572526F6C655204726F6C652292010A08436172744974656D12140A05706C6174651801200128095205706C61746512390A0A73746172745F6461746518022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520973746172744461746512350A08656E645F6461746518032001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D705207656E6444617465224D0A044361727412170A07757365725F69641801200128095206757365724964122C0A056974656D7318022003280B32162E63617272656E74616C2E76312E436172744974656D52056974656D7322AF010A0F5265736572766174696F6E4974656D12140A05706C6174651801200128095205706C61746512390A0A73746172745F6461746518022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520973746172744461746512350A08656E645F6461746518032001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D705207656E644461746512140A057072696365180420012801520570726963652297020A0B5265736572766174696F6E12250A0E7265736572766174696F6E5F6964180120012809520D7265736572766174696F6E496412170A07757365725F6964180220012809520675736572496412330A056974656D7318032003280B321D2E63617272656E74616C2E76312E5265736572766174696F6E4974656D52056974656D73121F0A0B746F74616C5F7072696365180420012801520A746F74616C507269636512370A0673746174757318052001280E321F2E63617272656E74616C2E76312E5265736572766174696F6E537461747573520673746174757312390A0A637265617465645F617418062001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520963726561746564417422340A0D4164644361725265717565737412230A0363617218012001280B32112E63617272656E74616C2E76312E4361725203636172224F0A0E416464436172526573706F6E736512230A0363617218012001280B32112E63617272656E74616C2E76312E436172520363617212180A076D65737361676518022001280952076D657373616765225C0A105570646174654361725265717565737412140A05706C6174651801200128095205706C61746512320A0B757064617465645F63617218022001280B32112E63617272656E74616C2E76312E436172520A7570646174656443617222520A11557064617465436172526573706F6E736512230A0363617218012001280B32112E63617272656E74616C2E76312E436172520363617212180A076D65737361676518022001280952076D65737361676522280A1052656D6F76654361725265717565737412140A05706C6174651801200128095205706C61746522540A1152656D6F7665436172526573706F6E736512250A046361727318012003280B32112E63617272656E74616C2E76312E43617252046361727312180A076D65737361676518022001280952076D657373616765223C0A1243726561746555736572735265717565737412260A047573657218012001280B32122E63617272656E74616C2E76312E5573657252047573657222540A134372656174655573657273526573706F6E736512230A0D637265617465645F636F756E74180120012805520C63726561746564436F756E7412180A076D65737361676518022001280952076D65737361676522320A184C697374417661696C61626C65436172735265717565737412160A0666696C746572180120012809520666696C74657222400A194C697374417661696C61626C6543617273526573706F6E736512230A0363617218012001280B32112E63617272656E74616C2E76312E436172520363617222280A105365617263684361725265717565737412140A05706C6174651801200128095205706C61746522700A11536561726368436172526573706F6E736512230A0363617218012001280B32112E63617272656E74616C2E76312E4361725203636172121C0A09617661696C61626C651802200128085209617661696C61626C6512180A076D65737361676518032001280952076D65737361676522570A10416464546F436172745265717565737412170A07757365725F69641801200128095206757365724964122A0A046974656D18022001280B32162E63617272656E74616C2E76312E436172744974656D52046974656D22650A11416464546F43617274526573706F6E7365120E0A026F6B18012001280852026F6B12180A076D65737361676518022001280952076D65737361676512260A046361727418032001280B32122E63617272656E74616C2E76312E4361727452046361727422320A17506C6163655265736572766174696F6E5265717565737412170A07757365725F6964180120012809520675736572496422710A18506C6163655265736572766174696F6E526573706F6E7365123B0A0B7265736572766174696F6E18012001280B32192E63617272656E74616C2E76312E5265736572766174696F6E520B7265736572766174696F6E12180A076D65737361676518022001280952076D657373616765223D0A174C6973745265736572766174696F6E735265717565737412220A0D61646D696E5F757365725F6964180120012809520B61646D696E55736572496422570A184C6973745265736572766174696F6E73526573706F6E7365123B0A0B7265736572766174696F6E18012001280B32192E63617272656E74616C2E76312E5265736572766174696F6E520B7265736572766174696F6E2A580A09436172537461747573121A0A164341525F5354415455535F554E5350454349464945441000120D0A09415641494C41424C451001120F0A0B554E415641494C41424C451002120F0A0B4D41494E54454E414E434510032A3E0A0855736572526F6C6512190A15555345525F524F4C455F554E5350454349464945441000120C0A08435553544F4D4552100112090A0541444D494E10022A5D0A115265736572766174696F6E537461747573121B0A175245534552564154494F4E5F554E5350454349464945441000120D0A09434F4E4649524D45441001120D0A0943414E43454C4C45441002120D0A09434F4D504C455445441003328E060A0943617252656E74616C12430A06416464436172121B2E63617272656E74616C2E76312E416464436172526571756573741A1C2E63617272656E74616C2E76312E416464436172526573706F6E7365124C0A09557064617465436172121E2E63617272656E74616C2E76312E557064617465436172526571756573741A1F2E63617272656E74616C2E76312E557064617465436172526573706F6E7365124C0A0952656D6F7665436172121E2E63617272656E74616C2E76312E52656D6F7665436172526571756573741A1F2E63617272656E74616C2E76312E52656D6F7665436172526573706F6E736512630A104C6973745265736572766174696F6E7312252E63617272656E74616C2E76312E4C6973745265736572766174696F6E73526571756573741A262E63617272656E74616C2E76312E4C6973745265736572766174696F6E73526573706F6E7365300112540A0B437265617465557365727312202E63617272656E74616C2E76312E4372656174655573657273526571756573741A212E63617272656E74616C2E76312E4372656174655573657273526573706F6E7365280112660A114C697374417661696C61626C654361727312262E63617272656E74616C2E76312E4C697374417661696C61626C6543617273526571756573741A272E63617272656E74616C2E76312E4C697374417661696C61626C6543617273526573706F6E73653001124C0A09536561726368436172121E2E63617272656E74616C2E76312E536561726368436172526571756573741A1F2E63617272656E74616C2E76312E536561726368436172526573706F6E7365124C0A09416464546F43617274121E2E63617272656E74616C2E76312E416464546F43617274526571756573741A1F2E63617272656E74616C2E76312E416464546F43617274526573706F6E736512610A10506C6163655265736572766174696F6E12252E63617272656E74616C2E76312E506C6163655265736572766174696F6E526571756573741A262E63617272656E74616C2E76312E506C6163655265736572766174696F6E526573706F6E7365620670726F746F33";

public isolated client class CarRentalClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, CAR_RENTAL_DESC);
    }

    isolated remote function AddCar(AddCarRequest|ContextAddCarRequest req) returns AddCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddCarRequest message;
        if req is ContextAddCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.v1.CarRental/AddCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddCarResponse>result;
    }

    isolated remote function AddCarContext(AddCarRequest|ContextAddCarRequest req) returns ContextAddCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddCarRequest message;
        if req is ContextAddCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.v1.CarRental/AddCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddCarResponse>result, headers: respHeaders};
    }

    isolated remote function UpdateCar(UpdateCarRequest|ContextUpdateCarRequest req) returns UpdateCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateCarRequest message;
        if req is ContextUpdateCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.v1.CarRental/UpdateCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <UpdateCarResponse>result;
    }

    isolated remote function UpdateCarContext(UpdateCarRequest|ContextUpdateCarRequest req) returns ContextUpdateCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateCarRequest message;
        if req is ContextUpdateCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.v1.CarRental/UpdateCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <UpdateCarResponse>result, headers: respHeaders};
    }

    isolated remote function RemoveCar(RemoveCarRequest|ContextRemoveCarRequest req) returns RemoveCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.v1.CarRental/RemoveCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <RemoveCarResponse>result;
    }

    isolated remote function RemoveCarContext(RemoveCarRequest|ContextRemoveCarRequest req) returns ContextRemoveCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.v1.CarRental/RemoveCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <RemoveCarResponse>result, headers: respHeaders};
    }

    isolated remote function SearchCar(SearchCarRequest|ContextSearchCarRequest req) returns SearchCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchCarRequest message;
        if req is ContextSearchCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.v1.CarRental/SearchCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SearchCarResponse>result;
    }

    isolated remote function SearchCarContext(SearchCarRequest|ContextSearchCarRequest req) returns ContextSearchCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchCarRequest message;
        if req is ContextSearchCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.v1.CarRental/SearchCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SearchCarResponse>result, headers: respHeaders};
    }

    isolated remote function AddToCart(AddToCartRequest|ContextAddToCartRequest req) returns AddToCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.v1.CarRental/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddToCartResponse>result;
    }

    isolated remote function AddToCartContext(AddToCartRequest|ContextAddToCartRequest req) returns ContextAddToCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.v1.CarRental/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddToCartResponse>result, headers: respHeaders};
    }

    isolated remote function PlaceReservation(PlaceReservationRequest|ContextPlaceReservationRequest req) returns PlaceReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceReservationRequest message;
        if req is ContextPlaceReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.v1.CarRental/PlaceReservation", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PlaceReservationResponse>result;
    }

    isolated remote function PlaceReservationContext(PlaceReservationRequest|ContextPlaceReservationRequest req) returns ContextPlaceReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceReservationRequest message;
        if req is ContextPlaceReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.v1.CarRental/PlaceReservation", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PlaceReservationResponse>result, headers: respHeaders};
    }

    isolated remote function CreateUsers() returns CreateUsersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("carrental.v1.CarRental/CreateUsers");
        return new CreateUsersStreamingClient(sClient);
    }

    isolated remote function ListReservations(ListReservationsRequest|ContextListReservationsRequest req) returns stream<ListReservationsResponse, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ListReservationsRequest message;
        if req is ContextListReservationsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("carrental.v1.CarRental/ListReservations", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ListReservationsResponseStream outputStream = new ListReservationsResponseStream(result);
        return new stream<ListReservationsResponse, grpc:Error?>(outputStream);
    }

    isolated remote function ListReservationsContext(ListReservationsRequest|ContextListReservationsRequest req) returns ContextListReservationsResponseStream|grpc:Error {
        map<string|string[]> headers = {};
        ListReservationsRequest message;
        if req is ContextListReservationsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("carrental.v1.CarRental/ListReservations", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ListReservationsResponseStream outputStream = new ListReservationsResponseStream(result);
        return {content: new stream<ListReservationsResponse, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function ListAvailableCars(ListAvailableCarsRequest|ContextListAvailableCarsRequest req) returns stream<ListAvailableCarsResponse, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ListAvailableCarsRequest message;
        if req is ContextListAvailableCarsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("carrental.v1.CarRental/ListAvailableCars", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ListAvailableCarsResponseStream outputStream = new ListAvailableCarsResponseStream(result);
        return new stream<ListAvailableCarsResponse, grpc:Error?>(outputStream);
    }

    isolated remote function ListAvailableCarsContext(ListAvailableCarsRequest|ContextListAvailableCarsRequest req) returns ContextListAvailableCarsResponseStream|grpc:Error {
        map<string|string[]> headers = {};
        ListAvailableCarsRequest message;
        if req is ContextListAvailableCarsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("carrental.v1.CarRental/ListAvailableCars", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ListAvailableCarsResponseStream outputStream = new ListAvailableCarsResponseStream(result);
        return {content: new stream<ListAvailableCarsResponse, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public isolated client class CreateUsersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendCreateUsersRequest(CreateUsersRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextCreateUsersRequest(ContextCreateUsersRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveCreateUsersResponse() returns CreateUsersResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <CreateUsersResponse>payload;
        }
    }

    isolated remote function receiveContextCreateUsersResponse() returns ContextCreateUsersResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <CreateUsersResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class ListReservationsResponseStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|ListReservationsResponse value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if streamValue is () {
            return streamValue;
        } else if streamValue is grpc:Error {
            return streamValue;
        } else {
            record {|ListReservationsResponse value;|} nextRecord = {value: <ListReservationsResponse>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public class ListAvailableCarsResponseStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|ListAvailableCarsResponse value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if streamValue is () {
            return streamValue;
        } else if streamValue is grpc:Error {
            return streamValue;
        } else {
            record {|ListAvailableCarsResponse value;|} nextRecord = {value: <ListAvailableCarsResponse>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public type ContextListAvailableCarsResponseStream record {|
    stream<ListAvailableCarsResponse, error?> content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersRequestStream record {|
    stream<CreateUsersRequest, error?> content;
    map<string|string[]> headers;
|};

public type ContextListReservationsResponseStream record {|
    stream<ListReservationsResponse, error?> content;
    map<string|string[]> headers;
|};

public type ContextListReservationsRequest record {|
    ListReservationsRequest content;
    map<string|string[]> headers;
|};

public type ContextListAvailableCarsResponse record {|
    ListAvailableCarsResponse content;
    map<string|string[]> headers;
|};

public type ContextPlaceReservationResponse record {|
    PlaceReservationResponse content;
    map<string|string[]> headers;
|};

public type ContextRemoveCarRequest record {|
    RemoveCarRequest content;
    map<string|string[]> headers;
|};

public type ContextUpdateCarRequest record {|
    UpdateCarRequest content;
    map<string|string[]> headers;
|};

public type ContextAddCarResponse record {|
    AddCarResponse content;
    map<string|string[]> headers;
|};

public type ContextAddToCartResponse record {|
    AddToCartResponse content;
    map<string|string[]> headers;
|};

public type ContextUpdateCarResponse record {|
    UpdateCarResponse content;
    map<string|string[]> headers;
|};

public type ContextAddToCartRequest record {|
    AddToCartRequest content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersRequest record {|
    CreateUsersRequest content;
    map<string|string[]> headers;
|};

public type ContextListAvailableCarsRequest record {|
    ListAvailableCarsRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchCarRequest record {|
    SearchCarRequest content;
    map<string|string[]> headers;
|};

public type ContextAddCarRequest record {|
    AddCarRequest content;
    map<string|string[]> headers;
|};

public type ContextRemoveCarResponse record {|
    RemoveCarResponse content;
    map<string|string[]> headers;
|};

public type ContextListReservationsResponse record {|
    ListReservationsResponse content;
    map<string|string[]> headers;
|};

public type ContextPlaceReservationRequest record {|
    PlaceReservationRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchCarResponse record {|
    SearchCarResponse content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersResponse record {|
    CreateUsersResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type ListReservationsRequest record {|
    string admin_user_id = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type User record {|
    string user_id = "";
    string name = "";
    string email = "";
    UserRole role = USER_ROLE_UNSPECIFIED;
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type ListAvailableCarsResponse record {|
    Car car = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type PlaceReservationResponse record {|
    Reservation reservation = {};
    string message = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type RemoveCarRequest record {|
    string plate = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type UpdateCarRequest record {|
    string plate = "";
    Car updated_car = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type AddCarResponse record {|
    Car car = {};
    string message = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type AddToCartResponse record {|
    boolean ok = false;
    string message = "";
    Cart cart = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type UpdateCarResponse record {|
    Car car = {};
    string message = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type CartItem record {|
    string plate = "";
    time:Utc start_date = [0, 0.0d];
    time:Utc end_date = [0, 0.0d];
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type AddToCartRequest record {|
    string user_id = "";
    CartItem item = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type CreateUsersRequest record {|
    User user = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type ListAvailableCarsRequest record {|
    string filter = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type SearchCarRequest record {|
    string plate = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type AddCarRequest record {|
    Car car = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type RemoveCarResponse record {|
    Car[] cars = [];
    string message = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type Reservation record {|
    string reservation_id = "";
    string user_id = "";
    ReservationItem[] items = [];
    float total_price = 0.0;
    ReservationStatus status = RESERVATION_UNSPECIFIED;
    time:Utc created_at = [0, 0.0d];
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type ReservationItem record {|
    string plate = "";
    time:Utc start_date = [0, 0.0d];
    time:Utc end_date = [0, 0.0d];
    float price = 0.0;
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type Car record {|
    string plate = "";
    string make = "";
    string model = "";
    int year = 0;
    float daily_price = 0.0;
    CarStatus status = CAR_STATUS_UNSPECIFIED;
    int mileage = 0;
    string description = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type ListReservationsResponse record {|
    Reservation reservation = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type PlaceReservationRequest record {|
    string user_id = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type SearchCarResponse record {|
    Car car = {};
    boolean available = false;
    string message = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type CreateUsersResponse record {|
    int created_count = 0;
    string message = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type Cart record {|
    string user_id = "";
    CartItem[] items = [];
|};

public enum CarStatus {
    CAR_STATUS_UNSPECIFIED, AVAILABLE, UNAVAILABLE, MAINTENANCE
}

public enum UserRole {
    USER_ROLE_UNSPECIFIED, CUSTOMER, ADMIN
}

public enum ReservationStatus {
    RESERVATION_UNSPECIFIED, CONFIRMED, CANCELLED, COMPLETED
}
