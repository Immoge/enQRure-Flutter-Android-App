<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$userid = $_POST['userid'];
$retailerregdate = DateTime::createFromFormat('d/m/Y', $_POST['retailerregdate']);
$retailerregdate = $retailerregdate->format('Y-m-d');
$encryptedcode = $_POST['encryptedcode'];
$sqlretailerregisterproduct = "UPDATE tbl_product SET retailer_id=?, retailer_regdate=? WHERE product_encryptedcode=?";

$stmt = $conn->prepare($sqlretailerregisterproduct);
$stmt->bind_param("iss", $userid, $retailerregdate, $encryptedcode);
$stmt->execute();

if ($stmt->affected_rows > 0) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
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
