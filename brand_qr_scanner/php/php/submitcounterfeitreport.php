<?php
// Validate if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    sendJsonResponse(array('status' => 'failed', 'data' => null));
    die();
}

// Include the database connection file
include_once("dbconnect.php");

// Validate and sanitize input values
$cprname = sanitizeInput($_POST['cprname']);
$cprdescription = sanitizeInput($_POST['cprdescription']);
$cprplatform = sanitizeInput($_POST['cprplatform']);
$cprorgin = sanitizeInput($_POST['cprorgin']);
$cprlocation = sanitizeInput($_POST['cprlocation']);
$cprsellername = sanitizeInput($_POST['cprsellername']);
$cprpurchasedate = sanitizeInput($_POST['cprpurchasedate']);
$cprencryptedcode = sanitizeInput($_POST['cprencryptedcode']);
$cprbuyerid = sanitizeInput($_POST['cprbuyerid']);
$base64image = $_POST['image'];

// Prepare the SQL statement using prepared statements
$sqlinsert = "INSERT INTO `tbl_counterfeitproduct` (`cproduct_name`, `cproduct_description`, `cproduct_platform`, `cproduct_origin`, `cproduct_location`, 
`cproduct_sellername`, `cproduct_purchasedate`, `cproduct_encryptedcode`, `cproduct_buyerid`) 
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sqlinsert);
$stmt->bind_param("sssssssss", $cprname, $cprdescription, $cprplatform, $cprorgin, $cprlocation, $cprsellername, $cprpurchasedate, $cprencryptedcode, $cprbuyerid);

// Execute the prepared statement
if ($stmt->execute()) {
    $response = array('status' => 'success', 'data' => null);

    // Get the inserted ID
    $filename = $stmt->insert_id;

    // Save the image file
    $path = '../assets/counterfeitproductimages/' . $filename . '.jpg';
    $decoded_string = base64_decode($base64image);
    $is_written = file_put_contents($path, $decoded_string);

    if ($is_written === false) {
        // Failed to save the image
        $response['status'] = 'failed';
    }

    sendJsonResponse($response);
} else {
    // Failed to execute the SQL statement
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

$stmt->close();
$conn->close();

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

function sanitizeInput($input)
{
    // Add appropriate input validation and sanitization here
    // Example: $sanitizedInput = trim($input);
    return $input;
}
