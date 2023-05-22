<?php
if (!isset($_POST)){
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$email = $_POST['email'];
$name = $_POST['name'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$address = $_POST['address'];
$roleid = $_POST['roleid'];
$origin = $_POST['origin'];
$base64image = $_POST['image'];

$sqlinsert = "INSERT INTO `tbl_user`(`user_email`, `user_name`, `user_password`, `user_phone`, 
`user_homeAddress`,`role_id`,`user_origin`) VALUES ('$email','$name','$password','$phone','$address', '$roleid', '$origin')";

if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    $filename = mysqli_insert_id($conn);
    $decoded_string = base64_decode($base64image);
    $path = '../assets/profilesimages/' . $filename . '.jpg';
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