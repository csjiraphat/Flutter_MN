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
            // Retrieve tram data
            $sql = "SELECT * FROM tram";
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
                $response['message'] = "Failed to fetch tram data: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }
        break;

    case 'POST':
        // ตรวจสอบว่าเป็น POST request
        if ($request_method == 'POST') {
            // ดึง code รถรางล่าสุด
            $query = "SELECT MAX(code) AS maxCode FROM tram";
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

            // นำ code รถรางล่าสุดมาบวก 1
            $newCode = $lastCode + 1;

            // ทำการ INSERT ข้อมูล
            $data = json_decode(file_get_contents("php://input"), true);
            $tram_code = sanitize_input($data['tram_code']);

            $sql = "INSERT INTO tram (code, tram_code)
                        VALUES ('$newCode', '$tram_code')";

            if (mysqli_query($conn, $sql)) {
                $response['status'] = 201;
                $response['message'] = "Tram data added successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to add tram data: " . mysqli_error($conn);
            }
        } else {
            $response['status'] = 400;
            $response['message'] = "Invalid request method";
        }
        break;

    case 'PUT':
        // ตรวจสอบว่าเป็น PUT request
        if ($request_method == 'PUT') {
            // Update tram data
            $data = json_decode(file_get_contents("php://input"), true);

            // Extract data from the request
            $code = sanitize_input($data['code']);
            $tram_code = sanitize_input($data['tram_code']);

            // Update tram data in the database
            $sql = "UPDATE tram
            SET tram_code=?
            WHERE code=?";

            $stmt = mysqli_prepare($conn, $sql);

            mysqli_stmt_bind_param($stmt, "si", $tram_code, $code);

            if (mysqli_stmt_execute($stmt)) {
                $response['status'] = 200;
                $response['message'] = "Tram data updated successfully";
            } else {
                $response['status'] = 500;
                $response['message'] = "Failed to update tram data: " . mysqli_stmt_error($stmt);

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
        $code = sanitize_input($data['code']);
        $sql = "DELETE FROM tram WHERE code='$code'";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "Tram data deleted successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to delete tram data: " . mysqli_error($conn);
        }
        break;

    default:
        $response['status'] = 400;
        $response['message'] = "Invalid request method";
        break;
}

echo json_encode($response);
mysqli_close($conn);
