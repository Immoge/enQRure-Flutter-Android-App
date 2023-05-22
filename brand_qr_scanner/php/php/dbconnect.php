<?php
$servername = "localhost";
$username = "yuelleco_immoge";
$password = "Immoge@11";
$dbname = "yuelleco_enQRsure_db";

$conn = new mysqli($servername, $username, $password, $dbname);
if($conn->connect_error){
    die("Connection failed: " . $conn->connect_error);
}
?>