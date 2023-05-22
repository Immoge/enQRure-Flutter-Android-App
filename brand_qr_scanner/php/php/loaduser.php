<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$results_per_page = 20;
$pageno = (int)$_POST['pageno'];
$search = $_POST['search'];
$page_first_result = ($pageno - 1) * $results_per_page;

$sqlloaduser = "SELECT * FROM `tbl_user` WHERE `user_name` LIKE '%$search%' ORDER BY user_name ASC";
$result = $conn->query($sqlloaduser);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloaduser = $sqlloaduser . " LIMIT $page_first_result, $results_per_page";
$result = $conn->query($sqlloaduser);

if ($result->num_rows > 0) {
    $users["users"] = array();
    while ($row = $result->fetch_assoc()) {
        $userlist = array();
        $userlist['user_id'] = $row['user_id'];
        $userlist['user_email'] = $row['user_email'];
        $userlist['user_name'] = $row['user_name'];
        $userlist['user_password'] = $row['user_password'];
        $userlist['user_phone'] = $row['user_phone'];
        $userlist['user_homeAddress'] = $row['user_homeAddress'];
        $userlist['role_id'] = $row['role_id'];
        $userlist['user_origin'] = $row['user_origin'];
        $userlist['user_datereg'] = $row['user_datereg'];
        array_push($users["users"], $userlist);
    }
    $response = array(
        'status' => 'success', 'pageno' => "$pageno", 'numofpage' => "$number_of_page", 'data' => $users);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'pageno' => "$pageno", 'numofpage' => "$number_of_page", 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
