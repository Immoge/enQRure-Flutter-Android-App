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
$sqlloadcounterfeitproduct = "SELECT * FROM `tbl_counterfeitproduct` WHERE `cproduct_name` LIKE '%$search%' ORDER BY cproduct_submitdate DESC";

$result = $conn->query($sqlloadcounterfeitproduct);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadcounterfeitproduct = $sqlloadcounterfeitproduct . " LIMIT $page_first_result, $results_per_page";
$result = $conn->query($sqlloadcounterfeitproduct);

if ($result->num_rows > 0) {
    $counterfeitproducts["counterfeitproducts"] = array();
    while ($row = $result->fetch_assoc()) {
        $counterfeitproductlist = array();
        $counterfeitproductlist['cproduct_id'] = $row['cproduct_id'];
        $counterfeitproductlist['cproduct_name'] = $row['cproduct_name'];
        $counterfeitproductlist['cproduct_description'] = $row['cproduct_description'];
        $counterfeitproductlist['cproduct_platform'] = $row['cproduct_platform'];
        $counterfeitproductlist['cproduct_origin'] = $row['cproduct_origin'];
        $counterfeitproductlist['cproduct_location'] = $row['cproduct_location'];
        $counterfeitproductlist['cproduct_sellername'] = $row['cproduct_sellername'];
        $counterfeitproductlist['cproduct_purchasedate'] = $row['cproduct_purchasedate'];
        $counterfeitproductlist['cproduct_encryptedcode'] = $row['cproduct_encryptedcode'];
        $counterfeitproductlist['cproduct_buyerid'] = $row['cproduct_buyerid'];
        $counterfeitproductlist['cproduct_submitdate'] = $row['cproduct_submitdate'];
        array_push($counterfeitproducts["counterfeitproducts"], $counterfeitproductlist);
    }
    $response = array(
        'status' => 'success', 'pageno' => "$pageno", 'numofpage' => "$number_of_page", 'data' => $counterfeitproducts);
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