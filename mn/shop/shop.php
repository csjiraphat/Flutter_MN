<?php
include '../conn.php'; // Ensure that 'conn.php' contains your database connection logic

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

// Function to sanitize and validate input data
function sanitize_input($data)
{
    return htmlspecialchars(strip_tags(trim($data)));
}

$response = array();

// Use $_SERVER['REQUEST_METHOD'] to get the request method
$request_method = $_SERVER["REQUEST_METHOD"];

switch ($request_method) {
    case 'GET':
        // Check if it is a GET request
        if ($request_method == 'GET') {
            // Retrieve shop data
            $sql = "SELECT * FROM shop";
            $result = mysqli_query($conn, $sql);

            if ($result) {
                $rows = array();
                while ($row = mysqli_fetch_assoc($result)) {
                    $rows[] = $row;
                }
                $response['status'] = 200;
                $response['data'] = $rows;
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to fetch shop data: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }
        break;

    case 'POST':
        // Check if it is a POST request
        if ($request_method == 'POST') {
            // Insert shop data into the database
            $data = json_decode(file_get_contents("php://input"), true);
            $shop_code = sanitize_input($data['shop_code']);
            $shop_name = sanitize_input($data['shop_name']);

            $sql = "INSERT INTO shop (shop_code, shop_name)
                    VALUES ('$shop_code', '$shop_name')";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 201;
                $response['message'] = "Shop data added successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to add shop data: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }
        break;

    case 'PUT':
        // Check if it is a PUT request
        if ($request_method == 'PUT') {
            // Update shop data
            $data = json_decode(file_get_contents("php://input"), true);

            // Extract data from the request
            $shop_code = sanitize_input($data['shop_code']);
            $shop_name = sanitize_input($data['shop_name']);

            // Update shop data in the database
            $sql = "UPDATE shop
                    SET shop_name='$shop_name'
                    WHERE shop_code='$shop_code'";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 200;
                $response['message'] = "Shop data updated successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to update shop data: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }

        break;

    case 'DELETE':
        // Check if it is a DELETE request
        $data = json_decode(file_get_contents("php://input"), true);

        // Extract data from the request
        $shop_code = sanitize_input($data['shop_code']);
        $sql = "DELETE FROM shop WHERE shop_code='$shop_code'";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "Shop data deleted successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to delete shop data: " . mysqli_error($conn);
        }
        break;

    default:
        $response['status'] = 400;
        $response['message'] = "Invalid request method";
        break;
}

echo json_encode($response);
mysqli_close($conn);
