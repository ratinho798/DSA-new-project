import ballerina/http;
import ballerina/time;

// Assume this `assets` table/map is shared across the team
public type Schedule record {|
    string type;
    string nextDueDate; // yyyy-MM-dd
|};

public type Asset record {|
    string assetTag;
    string name;
    string faculty;
    string department;
    string status;
    string acquiredDate;
    Schedule[] schedules?;
|};

// main database (in-memory)
table<Asset> key(assetTag) assets = table [
    {
        assetTag: "EQ-001",
        name: "3D Printer",
        faculty: "Computing & Informatics",
        department: "Software Engineering",
        status: "ACTIVE",
        acquiredDate: "2024-03-10",
        schedules: [
            { type: "Quarterly", nextDueDate: "2024-06-10" },
            { type: "Yearly", nextDueDate: "2025-03-10" }
        ]
    },
    {
        assetTag: "EQ-002",
        name: "Server",
        faculty: "Engineering",
        department: "Networks",
        status: "UNDER_REPAIR",
        acquiredDate: "2023-05-20",
        schedules: [
            { type: "Monthly", nextDueDate: "2024-09-01" }
        ]
    }
];

service /assets on new http:Listener(8080) {

    // 1. View all assets
    resource function get .() returns Asset[] {
        return assets.toArray();
    }

    // 2. View assets by faculty
    resource function get faculty/[string facultyName]() returns Asset[] {
        Asset[] result = from var asset in assets
                         where asset.faculty == facultyName
                         select asset;
        return result;
    }

    // 3. Overdue check
    resource function get overdue() returns Asset[] {
        time:Date today = time:currentTime().date;
        Asset[] overdueAssets = [];

        foreach var asset in assets {
            if asset.schedules is Schedule[] {
                foreach var sched in asset.schedules {
                    time:Date? due = time:parseDateTime(sched.nextDueDate, "yyyy-MM-dd").date;
                    if due is time:Date && time:utcCompare(due, today) < 0 {
                        overdueAssets.push(asset);
                        break; // no need to check more schedules for this asset
                    }
                }
            }
        }
        return overdueAssets;
    }
}
 
