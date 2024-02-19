<?php

header('Access-Control-Allow-Origin: *');
include "./conn.php";

// Check if all required parameters are provided
if (
    isset($_POST['firstname']) &&
    isset($_POST['lastname']) &&
    isset($_POST['email']) &&
    isset($_POST['phone']) &&
    isset($_POST['password'])
) {
    $firstname = $_POST['firstname'];
    $lastname = $_POST['lastname'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];
    $password = $_POST['password'];

    // Validate input
    if (empty($firstname) || empty($lastname) || empty($email) || empty($phone) || empty($password)) {
        http_response_code(400);
        echo json_encode(array("message" => "Incomplete data. Please provide all required parameters."));
        exit;
    }

    // Get the last user_id from the database
    $sql = "SELECT MAX(user_id) AS MAX_ID FROM users";
    $result = mysqli_query($conn, $sql);

    if ($row = mysqli_fetch_assoc($result)) {
        $lastUserId = $row['MAX_ID'];
        $newUserId = str_pad((int) $lastUserId + 1, 5, '0', STR_PAD_LEFT); // Increment and pad with zeros
    } else {
        // If no records found, start with user_id '00001'
        $newUserId = '00001';
    }

    // Use prepared statement to prevent SQL injection
    $stmt = $conn->prepare("INSERT INTO users (user_id, firstname, email, phone, password, lastname) VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssss", $newUserId, $firstname, $email, $phone, $password, $lastname);

    // Check if the query executed successfully
    if ($stmt->execute()) {
        http_response_code(200);
        echo json_encode(array("message" => "Registration successful."));
    } else {
        http_response_code(500);
        echo json_encode(array("message" => "Registration failed. Please try again later."));
    }

    // Close the statement
    $stmt->close();
} else {
    // Missing required parameters
    http_response_code(400);
    echo json_encode(array("message" => "Missing required parameters."));
}
