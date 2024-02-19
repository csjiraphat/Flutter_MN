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
        // ตรวจสอบว่าเป็น GET request
        if ($request_method == 'GET') {
            // Retrieve place data
            $sql = "SELECT * FROM place";
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
                $response['message'] = "Failed to fetch place data: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }
        break;

    case 'POST':
        // ตรวจสอบว่าเป็น POST request
        if ($request_method == 'POST') {
            // ดึง code สถานที่ท่องเที่ยวล่าสุด
            $query = "SELECT MAX(place_code) AS maxCode FROM place";
            $result = mysqli_query($conn, $query);
            $row = mysqli_fetch_assoc($result);

            // ตรวจสอบว่ามีข้อมูลหรือไม่
            if ($row['maxCode'] !== null) {
                // มีข้อมูล
                $lastCode = $row['maxCode'];
            } else {
                // ไม่มีข้อมูล (ฐานข้อมูลว่าง)
                $lastCode = 0;
            }

            // นำ code สถานที่ท่องเที่ยวล่าสุดมาบวก 1
            $newCode = $lastCode + 1;

            // เพิ่มเลข 0 ข้างหน้าเลขโค้ดเมื่อค่าโค้ดน้อยกว่า 100
            if ($newCode < 100) {
                $newCode = str_pad($newCode, 5, "0", STR_PAD_LEFT);
            }

            // ทำการ INSERT ข้อมูล
            $data = json_decode(file_get_contents("php://input"), true);
            $place_name = sanitize_input($data['place_name']);
            $latitude = sanitize_input($data['latitude']);
            $longtitude = sanitize_input($data['longtitude']);

            $sql = "INSERT INTO place (place_code, place_name, latitude, longtitude)
            VALUES ('$newCode', '$place_name', '$latitude', '$longtitude')";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 201;
                $response['message'] = "Place data added successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to add place data: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }
        break;

    case 'PUT':
        // ตรวจสอบว่าเป็น PUT request
        if ($request_method == 'PUT') {
            // Update place data
            $data = json_decode(file_get_contents("php://input"), true);

            // Extract data from the request
            $place_code = sanitize_input($data['place_code']);
            $place_name = sanitize_input($data['place_name']);
            $latitude = sanitize_input($data['latitude']);
            $longtitude = sanitize_input($data['longtitude']);

            // Update place data in the database
            $sql = "UPDATE place
            SET place_name=?, latitude=?, longtitude=?
            WHERE place_code=?";

            $stmt = mysqli_prepare($conn, $sql);

            mysqli_stmt_bind_param($stmt, "ssdd", $place_name, $latitude, $longtitude, $place_code);

            if (mysqli_stmt_execute($stmt)) {
                $response['status'] = 200;
                $response['message'] = "Place data updated successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to update place data: " . mysqli_stmt_error($stmt);

                // บันทึกข้อผิดพลาดลงใน error logs
                error_log(mysqli_stmt_error($stmt));
            }

            mysqli_stmt_close($stmt);
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }

        break;

    case 'DELETE':

        $data = json_decode(file_get_contents("php://input"), true);

        // Extract data from the request
        $place_code = sanitize_input($data['place_code']);
        $sql = "DELETE FROM place WHERE place_code='$place_code'";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "Place data deleted successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to delete place data: " . mysqli_error($conn);
        }
        break;

    default:
        $response['status'] = 400;
        $response['message'] = "Invalid request method";
        break;
}

echo json_encode($response);
mysqli_close($conn);
