<?php
$con = new mysqli("localhost", "root", "", "grocerystore");
mysqli_query($con, 'SET NAMES "utf8" COLLATE "utf8_general_ci"'); // For Arabic language

if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
    exit();
}

$jsonData = file_get_contents("php://input");
$data = json_decode($jsonData, true);

$originalName = isset($data["oldname"]) ? mysqli_real_escape_string($con, $data["oldname"]) : '';
$quantity = isset($data["quantity"]) ? intval($data["quantity"]) : 0;
$name = isset($data["name"]) ? mysqli_real_escape_string($con, $data["name"]) : '';
$price = isset($data["price"]) ? mysqli_real_escape_string($con, $data["price"]) : '';

if ($originalName !== '' && $quantity && $name !== '' && $price !== '') {
    $updateQuery = "UPDATE `1` SET `name`='$name', `quantity`='$quantity', `price`='$price' WHERE `name`='$originalName'";

    if ($con->query($updateQuery) === TRUE) {
        http_response_code(200);
        echo json_encode(['message' => 'Product data updated successfully']);
    } else {
        http_response_code(500);
        echo json_encode(['message' => 'Error updating Product data: ' . $con->error]);
    }
} else {
    http_response_code(400);
    echo json_encode(['message' => 'Invalid input data']);
}

$con->close();
?>
