import ballerina/io;
// import ballerina/lang.'boolean;

LibraryClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    io:println("login using defualt username and password");
    Users addUserRequest = {userName: "ballerina", passWord: "ballerina", isAdmin: true};
    Responds addUserResponse = check ep->addUser(addUserRequest);
    io:println(addUserResponse);
    boolean running = true;

    while running{
    string exit = io:readln("Enter exit to exit the program or enter any button to continue: ");
    if (exit == "exit"){
        running = false;
    }
    else{
         
    string login_username = io:readln("enter Username: ");
    string login_password = io:readln("enter password: ");
    string login_isAdmin =  io:readln("Are you a Librarian: enter 1: Yes or 2. No:  ");
    boolean isAdmin_lo;
    if (login_isAdmin == "1"){
         isAdmin_lo = true;   
    }
    else if (login_isAdmin == "2"){
         isAdmin_lo = false; 
    } 

    else {return main();}

    Users loginRequest = {userName: login_username, passWord: login_password, isAdmin: isAdmin_lo};
    Users loginResponse = check ep->login(loginRequest);
    io:println(loginResponse);
    boolean at_Admin = loginResponse.isAdmin;
    string userID = loginResponse.userName;
    if (at_Admin == true){
        io:println("Welcome " + userID);

        boolean run_admin = true;
        while run_admin {

            io:println("=================");  
            io:println("1. Add Book");
            io:println("2. Delete Book");
            io:println("3. Update a book");
            io:println("4. add user");
            io:println("5. delete user");
            io:println("6. show all the borrowed book ");
            io:println("7. locate book");
            io:println("8. Show Available books");
            io:println("9. Exit");
            io:println("=================");

            

            string choice = io:readln("enter choice");
            if (choice == "1"){
                io:print(addBookFunction());
            }
            else if (choice == "2"){
                string book_ISBN = io:readln("Enter book's ISBN to delete book: ");
                string deleteBookRequest = book_ISBN;
                Responds deleteBookResponse = check ep->deleteBook(deleteBookRequest);
                io:println(deleteBookResponse);
            }
            else if (choice == "3"){
                string book_title = io:readln("enter book's title: ");
                string book_author_1 = io:readln("enter book's author: ");
                string book_optional = io:readln("enter book author 2, press enter if there is no other author: ");
                string book_location = io:readln("enter location: ");
                string book_ISBN = io:readln("enter book ISBN number: ");
                string book_available2 =io:readln("Is the book available, enter number for choice: 1. Available 2. Unavailable: ");
                
                if (book_available2== "1") {
                    book_available2 = "Available";
                }
                else if (book_available2 == "2") {
                    book_available2 = "Unavailable";
                }

            Book updateBookRequest = {title: book_title, author_1: book_author_1, option_author: book_optional, location: book_location, ISBN: book_ISBN, available: book_available2};
            Responds updateBookResponse = check ep->updateBook(updateBookRequest);
            io:println(updateBookResponse);
        
            }

            else if (choice == "4"){
                io:println(addUserFunction());
            }

            else if (choice == "5"){
                login_username = io:readln("Enter username for the user to be deleted: ");
                string deleteUserRequest = login_username;
                Responds deleteUserResponse = check ep->deleteUser(deleteUserRequest);
                io:println(deleteUserResponse);
            }
            else if (choice == "6"){
                stream<Book, error?> showBorrowedBookResponse = check ep->showBorrowedBook();
                check showBorrowedBookResponse.forEach(function(Book value) {
                io:println(value);
            }); 
            }


            else if (choice == "7"){
                string book_ISBN = io:readln("Enter book ISBN: ");
                string locateBookRequest = book_ISBN;
                Book locateBookResponse = check ep->locateBook(locateBookRequest);
                io:println(locateBookResponse);
            }

            else if(choice ==  "8"){
                stream<Book, error?> showAvailableResponse = check ep->showAvailableBook();
                check showAvailableResponse.forEach(function(Book value) {
                    io:println(value);
                });
            }
            else if(choice == "9"){
                run_admin = false;
            
        }
    }
}    
    else{
        boolean run_student =true;
        while run_student {
            io:println("<<<<<<<<<<<<<<<"+ userID +">>>>>>>>>>>>>>");
            io:println("1. Borrow book");
            io:println("2. Show Available books");
            io:println("3. Locate book");
            io:println("4. Return Book");
            io:println("5.Exit");
            io:println("<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>");

            string choice = io:readln("Enter Number for choice: ");

            if (choice == "1"){
                string book_ISBN = io:readln("Enter Book ISBN");
                
                Book getBook = check ep->locateBook(book_ISBN);
                getBook.borrow_by = userID;
                getBook.available = "Unavailable";

                Book borrowBookRequest = getBook;
                Book borrowBookResponse = check ep->borrowBook(borrowBookRequest);
                io:println(borrowBookResponse);
            }

            else if(choice ==  "2"){
                stream<Book, error?> showAvailableResponse = check ep->showAvailableBook();
                check showAvailableResponse.forEach(function(Book value) {
                    io:println(value);
                });
            }

            else if (choice == "3"){
                string book_ISBN = io:readln("Enter book ISBN: ");
                string locateBookRequest = book_ISBN;
                Book locateBookResponse = check ep->locateBook(locateBookRequest);
                io:println(locateBookResponse);
                
            }

            else if (choice == "4"){
                string book_ISBN = io:readln("Enter Book ISBN");
                Book getBook = check ep->locateBook(book_ISBN);
                getBook.borrow_by = "";
                getBook.available = "Available";
                
                
                Book borrowBookRequest = getBook;
                Book borrowBookResponse = check ep->borrowBook(borrowBookRequest);
                io:println(borrowBookResponse);
            }
            else if (choice == "5"){
                io:println("logout sucessfully");
                run_student = false;
            } 
        }
    }    
    } 
}
}
function addBookFunction() returns Responds | error {
    string book_title = io:readln("enter book's title:: ");
    string book_author_1 = io:readln("enter book's author: ");
    string book_optional = io:readln("enter book author 2, press enter if there is no other author: ");
    string book_location = io:readln("enter location: ");
    string book_ISBN = io:readln("enter book ISBN number: ");
    string book_available =io:readln("Is the book available, enter number for choice: 1. Available 2. Unavailable: ");

    if (book_available== "1") {
        book_available = "Available";
        }
        else if (book_available == "2") {
            book_available = "Unavailable";
        }

        Book addBookRequest = {title: book_title, author_1: book_author_1, option_author: book_optional, location: book_location, ISBN: book_ISBN, available: book_available};
        Responds addBookResponse = check ep->addBook(addBookRequest);
        io:println(addBookResponse);
    return addBookResponse;
}

//function updateBookFunction() returns Responds | error {             
//}

function addUserFunction() returns Responds | error {
    string login_username = io:readln("enter Username");
    string login_password = io:readln("enter password");
    string login_isAdmin =  io:readln("Are you a Librarian: enter 1: Yes or 2. No");
    boolean Admin_log = false;
    if (login_isAdmin == "1"){
        Admin_log = true;
    }
    else if (login_isAdmin == "2"){
        Admin_log = false;
    }
    Users addUserRequest = {userName: login_username, passWord: login_password, isAdmin: Admin_log};
    Responds addUserResponse = check ep->addUser(addUserRequest);
    io:println(addUserResponse);
    return addUserResponse;
}