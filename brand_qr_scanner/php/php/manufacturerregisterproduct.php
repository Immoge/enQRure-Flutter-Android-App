<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$userid = $_POST['userid'];
$manufacturerregdate = DateTime::createFromFormat('d/m/Y', $_POST['manufacturerregdate']);
$manufacturerregdate = $manufacturerregdate->format('Y-m-d');
$encryptedcode = $_POST['encryptedcode'];
$sqlmanufacturerregisterproduct = "UPDATE tbl_product SET manufacturer_regid=?, manufacturer_regdate=? WHERE product_encryptedcode=?";

$stmt = $conn->prepare($sqlmanufacturerregisterproduct);
$stmt->bind_param("iss", $userid, $manufacturerregdate, $encryptedcode);
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
