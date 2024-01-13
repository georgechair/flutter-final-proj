<?php
// Establish a database connection
$conn = new mysqli("localhost", "root", "", "grocerystore");
mysqli_query($conn, 'SET NAMES "utf8" COLLATE "utf8_general_ci"'); // For Arabic language

if (mysqli_connect_errno()) {
    echo json_encode(["success" => false, "message" => "Failed to connect to MySQL: " . mysqli_connect_error()]);
    exit();
}

// Set response content type as JSON
header("Content-Type: application/json");

// Allow CORS (Cross-Origin Resource Sharing)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// Check if the request is a POST request
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get the JSON data from the request body
    $data = json_decode(file_get_contents("php://input"));

    // Validate and sanitize the input data (for security purposes)
    $username = filter_var($data->username, FILTER_SANITIZE_STRING);
    $email = filter_var($data->email, FILTER_SANITIZE_EMAIL);
    $password = filter_var($data->password, FILTER_SANITIZE_STRING); // No hashing

    // Set the default role ID to 2 (User)
    $roleID = 2;

    // Perform the INSERT query
    $sql = "INSERT INTO `client` (`name`, `email`, `password`, `roleID`) VALUES ('$username', '$email', '$password', $roleID)";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["success" => true, "message" => "Registration successful"]);
    } else {
        echo json_encode(["success" => false, "message" => $conn->error]);
    }
} else {
    // Invalid request method
    echo json_encode(["success" => false, "message" => "Invalid request method"]);
}

// Close the database connection
$conn->close();
?>
