<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$prname = addslashes($_POST['prname']);
$prdescription = addslashes($_POST['prdescription']);
$prtype = $_POST['prtype'];
$prbarcode = $_POST['prbarcode'];
$prdate = date('Y-m-d', strtotime($_POST['prdate']));
$prwarranty = $_POST['prwarranty'];
$prorigin = $_POST['prorigin'];
$prencryptedcode =  $_POST['prencryptedcode'];
$manufacturerid =  $_POST['manufacturerid'];
$base64image = $_POST['image'];

$sqlinsert = "INSERT INTO `tbl_product` (`product_name`, `product_description`, `product_type`, `product_barcode`, `product_date`, `product_warranty`, `product_origin`, `product_encryptedcode`, `manufacturer_id`) VALUES ('$prname', '$prdescription', '$prtype', '$prbarcode', '$prdate', '$prwarranty', '$prorigin', '$prencryptedcode', '$manufacturerid')";
if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    $filename = mysqli_insert_id($conn);
    $decoded_string = base64_decode($base64image);
    $path = '../assets/productimages/' . $filename . '.jpg';
    $is_written = file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>