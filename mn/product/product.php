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
        $sql = "SELECT p.*, s.shop_name FROM product p JOIN shop s ON p.shop_code = s.shop_code";
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
            $response['message'] = "Failed to fetch product data: " . mysqli_error($conn);
        }
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        $shop_code = sanitize_input($data['shop_code']);
        $product_name = sanitize_input($data['product_name']);
        $unit = sanitize_input($data['unit']);
        $price = sanitize_input($data['price']);

        // หาค่าสูงสุดของ product_code ในฐานข้อมูล
        $sql_max_product_code = "SELECT MAX(product_code) AS max_product_code FROM product";
        $result_max_product_code = mysqli_query($conn, $sql_max_product_code);
        $row_max_product_code = mysqli_fetch_assoc($result_max_product_code);
        $max_product_code = $row_max_product_code['max_product_code'];

        // เพิ่ม product_code ที่ถูกสร้างโดยการเพิ่ม 1 จากค่าสูงสุดและเพิ่ม 0 ข้างหน้า
        $next_product_code = str_pad((intval($max_product_code) + 1), strlen($max_product_code), "0", STR_PAD_LEFT);

        $sql = "INSERT INTO product (shop_code, product_code, product_name, unit, price) 
                    VALUES ('$shop_code', '$next_product_code', '$product_name', '$unit', '$price')";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 201;
            $response['message'] = "Product added successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to add product: " . mysqli_error($conn);
        }
        break;


    case 'PUT':
        $data = json_decode(file_get_contents("php://input"), true);
        $product_code = sanitize_input($data['product_code']);
        $product_name = sanitize_input($data['product_name']);
        $unit = sanitize_input($data['unit']);
        $price = sanitize_input($data['price']);

        $sql = "UPDATE product 
                SET product_name='$product_name', unit='$unit', price='$price' 
                WHERE product_code='$product_code'";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "Product updated successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to update product: " . mysqli_error($conn);
        }
        break;

    case 'DELETE':
        $data = json_decode(file_get_contents("php://input"), true);
        $product_code = sanitize_input($data['product_code']);

        $sql = "DELETE FROM product WHERE product_code='$product_code'";

        if (mysqli_query($conn, $sql)) {
            $response['status'] = 200;
            $response['message'] = "Product deleted successfully";
        } else {
            $response['status'] = 500;
            $response['message'] = "Failed to delete product: " . mysqli_error($conn);
        }
        break;

    default:
        $response['status'] = 400;
        $response['message'] = "Invalid request method";
        break;
}

echo json_encode($response);
mysqli_close($conn);
