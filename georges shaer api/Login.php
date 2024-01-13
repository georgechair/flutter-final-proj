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
    $email = filter_var($data->email, FILTER_SANITIZE_EMAIL);
    $password = filter_var($data->password, FILTER_SANITIZE_STRING);

    // Perform the SELECT query to check the login
    $sql = "SELECT * FROM `client` WHERE `email` = '$email' AND `password` = '$password'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        echo json_encode(["success" => true, "message" => "Login successful", "role" => (int)$row['roleID']]);
    } else {
        echo json_encode(["success" => false, "message" => "Invalid email or password"]);
    }
} else {
    // Invalid request method
    echo json_encode(["success" => false, "message" => "Invalid request method"]);
}

// Close the database connection
$conn->close();
?>
