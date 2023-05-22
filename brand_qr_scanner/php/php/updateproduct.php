<?php
	if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}

	include_once("dbconnect.php");
	$productid = $_POST['productid'];
	$productname = addslashes($_POST['productname']);
    $productdescription= ucwords(addslashes($_POST['productdescription']));
    $producttype = addslashes($_POST['producttype']);
	$productbarcode = $_POST['productbarcode'];
	$productdate= date('Y-m-d', strtotime($_POST['productdate']));
	$productwarranty = $_POST['productwarranty'];
	$productorigin = $_POST['productorigin'];
	$sqlupdate = "UPDATE `tbl_product` SET `product_name`='$productname',`product_description`='$productdescription',`product_type`='$producttype',`product_barcode`='$productbarcode', `product_date`='$productdate' , `product_warranty`='$productwarranty' , `product_origin`='$productorigin'WHERE `product_id` = '$productid'";
	
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