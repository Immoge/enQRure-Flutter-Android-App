<?php
	if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}

	include_once("dbconnect.php");
	$userid = $_POST['userid'];
	$useremail = $_POST['useremail'];
    $username= ucwords(addslashes($_POST['username']));
    $userphone = $_POST['userphone'];
	$useraddress= ucfirst(addslashes($_POST['useraddress']));
	$userorigin = $_POST['userorigin'];
	$sqlupdate = "UPDATE `tbl_user` SET `user_email`='$useremail',`user_name`='$username',`user_phone`='$userphone',`user_homeAddress`='$useraddress', `user_origin`='$userorigin' WHERE `user_id` = '$userid'";
	
  try {
		if ($conn->query($sqlupdate) === TRUE) {
			$response = array('status' => 'success', 'data' => null);
			sendJsonResponse($response);
		}
		else{
			$response = array('status' => 'failed', 'data' => null);
			sendJsonResponse($response);
		}
	}
	catch(Exception $e) {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}
	$conn->close();
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type= application/json');
    echo json_encode($sentArray);
	}
?>