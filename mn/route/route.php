<?php
include '../conn.php';

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

function sanitize_input($data)
{
    return htmlspecialchars(strip_tags(trim($data)));
}

$response = array();
$request_method = $_SERVER["REQUEST_METHOD"];

switch ($request_method) {
    case 'GET':
        $sql = "SELECT r.*, p.place_name FROM route r JOIN place p ON r.place_code = p.place_code";
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
            $response['message'] = "Failed to fetch route data: " . mysqli_error($conn);
        }
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        $place_code = sanitize_input($data['place_code']);
        $time = sanitize_input($data['time']);

        $sql_max_no = "SELECT MAX(no) AS max_no FROM route";
        $result_max_no = mysqli_query($conn, $sql_max_no);
        $row_max_no = mysqli_fetch_assoc($result_max_no);
        $max_no = $row_max_no['max_no'];
        $next_no = str_pad((intval($max_no) + 1), strlen($max_no), "0", STR_PAD_LEFT);

        $sql = "INSERT INTO route (no, place_code, time) 
                    VALUES ('$next_no', '$place_code', '$time')";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 201;
            $response['message'] = "Route added successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to add route: " . mysqli_error($conn);
        }
        break;


    case 'PUT':
        $data = json_decode(file_get_contents("php://input"), true);
        $no = sanitize_input($data['no']);
        $place_code = sanitize_input($data['place_code']);
        $time = sanitize_input($data['time']);

        $sql = "UPDATE route 
                SET place_code='$place_code', time='$time' 
                WHERE no='$no'";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "Route updated successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to update route: " . mysqli_error($conn);
        }
        break;

    case 'DELETE':
        $data = json_decode(file_get_contents("php://input"), true);
        $no = sanitize_input($data['no']);

        $sql = "DELETE FROM route WHERE no='$no'";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "Route deleted successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to delete route: " . mysqli_error($conn);
        }
        break;

    default:
        $response['status'] = 400;
        $response['message'] = "Invalid request method";
        break;
}

echo json_encode($response);
mysqli_close($conn);
