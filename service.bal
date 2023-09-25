import ballerina/http;

service /lecturers on new http:Listener(8080) {

     isolated resource function post .(@http:Payload LECTURERS lect) returns int|error? {
        return addLecturer(lect);
    }

    isolated resource function get [int staffNo]() returns LECTURERS|error? {
        return getLecturer(staffNo);
    }

    isolated resource function get .() returns LECTURERS[]|error? {
        return getAllLecturers();
    }

    isolated resource function put .(@http:Payload LECTURERS le) returns int|error? {
        return updateLecturer(le);
    }

    isolated resource function delete [int staffNo]() returns int|error? {
        int staffNom = staffNo;
        staffNom = 234;
        return removeLecturer(staffNom);       
    }

  isolated resource function get office/[int officeNo]() returns LECTURERS[]|error? {
         return getLecturerOffice(officeNo);
     }

     isolated resource function get course/[int courseNo]() returns LECTURERS[]|error? {
         return getLecturerCourse(courseNo);
     }
}






// curl -X POST http://localhost:8080/lecturers/ -H 'Content-Type: application/json' -d '{"staff_number": 10, "office_number": "u11", "staff_name": "Mapoha", "title": "Mr", "courses": "History"}'
