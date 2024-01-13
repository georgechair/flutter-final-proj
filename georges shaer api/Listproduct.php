<?php
$con = new mysqli("localhost","root","","grocerystore");
mysqli_query($con, 'SET NAMES "utf8" COLLATE "utf8_general_ci"'); // For Arabic language

if (mysqli_connect_errno()) {
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
    exit();
}

$query = "SELECT * FROM `1`";
$result = mysqli_query($con, $query);

// Check if there are any results
if (mysqli_num_rows($result) > 0) {
    $c = array(); // Initialize an empty array to store results

    while ($row = mysqli_fetch_assoc($result)) {
        $c[] = $row;
    }

    echo json_encode($c);
} else {
    echo "No records found.";
}

mysqli_close($con);
?>
