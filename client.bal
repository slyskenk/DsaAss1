import ballerinax/mysql.driver as _;
import ballerinax/mysql;
import ballerina/sql;

public type LECTURERS record {|
    int staff_number?;
    int office_number;
    string staff_name;
    string title;
    string courses;
    int courseNo;
|};

configurable string USER = ?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;
configurable string DATABASE = ?;

final mysql:Client dbClient = check new(
    host=HOST, user=USER, password=PASSWORD, port=PORT, database="dsa_assignment"
);

isolated function addLecturer(LECTURERS lect) returns int|error {
    sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO LECTURER (staff_number, office_number, staff_name, title, courses)

        VALUES (${lect.staff_number}, ${lect.office_number}, ${lect.staff_name},  
                ${lect.title}, ${lect.courses}, ${lect.courseNo})
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID");
    }
}

isolated function getLecturer(int staffNo) returns LECTURERS|error {
    LECTURERS lects = check dbClient->queryRow(
        `SELECT * FROM LECTURER WHERE staff_number = ${staffNo}`
    );
    return lects;
}

isolated function getAllLecturers() returns LECTURERS[]|error {
    LECTURERS[] lectu = [];
    stream<LECTURERS, error?> resultStream = dbClient->query(
        `SELECT * FROM LECTURER`
    );
    check from LECTURERS LECT in resultStream
        do {
            lectu.push(LECT);
        };
    check resultStream.close();
    return lectu;
}

isolated function updateLecturer(LECTURERS le) returns int|error {
    sql:ExecutionResult result = check dbClient->execute(`
        UPDATE LECTURER SET
            office_number = ${le.office_number}, 
            staff_name = ${le.staff_name},
            title = ${le.title},
            courses = ${le.courses},
            courseNo = ${le.courseNo}
        WHERE staff_number = ${le.staff_number}  
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID");
    }
}

 

isolated function removeLecturer(int staffNo) returns int|error {
    sql:ExecutionResult result = check dbClient->execute(`
        DELETE FROM LECTURER WHERE staff_number = ${staffNo}
    `);
    int? affectedRowCount = result.affectedRowCount;
    if affectedRowCount is int {
        return affectedRowCount;
    } else {
        return error("Unable to obtain the affected row count");
    }
}

isolated function getLecturerOffice(int officeNo) returns LECTURERS[]|error {
    LECTURERS[] lectu = [];
    stream<LECTURERS, error?> resultStream = dbClient->query(
        `SELECT * FROM LECTURER WHERE office_number = ${officeNo}`
    );
    check from LECTURERS LECT in resultStream
        do {
            lectu.push(LECT);
        };
    check resultStream.close();
    return lectu;
}

isolated function getLecturerCourse(int courseNo) returns LECTURERS[]|error {
    LECTURERS[] lectu = [];
    stream<LECTURERS, error?> resultStream = dbClient->query(
        `SELECT * FROM LECTURER WHERE courseNo = ${courseNo}`
    );
    check from LECTURERS LECT in resultStream
        do {
            lectu.push(LECT);
        };
    check resultStream.close();
    return lectu;
}