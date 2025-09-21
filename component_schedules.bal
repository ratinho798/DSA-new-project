b import ballerina/http;
 
 type Component record {|
    string componentId;
    string name?;
|};

type Schedule record {|
    string scheduleId;
    string description?;
|};

type Asset record {|
    string assetTag;
    Component[] components = [];
    Schedule[] schedules = [];
|};

table<Asset> key(assetTag) assets = table [];

// Start an HTTP listener on port 8080
listener http:Listener listener = new(8080);

// Service bound to listener
service /assets on listener {


    // Adding a component
    resource function post [string assetTag]/components(@body Component component) returns string {
        var asset = assets[assetTag];
        if asset is Asset {
            asset.components.push(component);
            assets[assetTag] = asset;
            return "Component added to " + assetTag;
        }
        return "Asset not found!";
    }

    // Remove a component
    resource function delete [string assetTag]/components/[string componentId] returns string {
        var asset = assets[assetTag];
        if asset is Asset {
            asset.components = from var c in asset.components
                               where c.componentId != componentId
                               select c;
            assets[assetTag] = asset;
            return "Component removed from " + assetTag;
        }
        return "Asset not found!";
    }

    // Add a schedule
    resource function post [string assetTag]/schedules(@body Schedule schedule) returns string {
        var asset = assets[assetTag];
        if asset is Asset {
            asset.schedules.push(schedule);
            assets[assetTag] = asset;
            return "Schedule added to " + assetTag;
        }
        return "Asset not found!";
    }

    // Remove a schedule
    resource function delete [string assetTag]/schedules/[string scheduleId] returns string {
        var asset = assets[assetTag];
        if asset is Asset {
            asset.schedules = from var s in asset.schedules
                              where s.scheduleId != scheduleId
                              select s;
            assets[assetTag] = asset;
            return "Schedule removed from " + assetTag;
        }
        return "Asset not found!";
    }
}


