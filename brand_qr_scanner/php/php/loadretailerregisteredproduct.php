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
$userid = $_POST['userid'];
$page_first_result = ($pageno - 1) * $results_per_page;
$sqlloadproduct = "SELECT * FROM `tbl_product` WHERE `product_name` LIKE '%$search%' AND `retailer_id` = '$userid' ORDER BY retailer_regdate DESC";
$result = $conn->query($sqlloadproduct);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadproduct = $sqlloadproduct . " LIMIT $page_first_result, $results_per_page";
$result = $conn->query($sqlloadproduct);

if ($result->num_rows > 0) {
    $products["products"] = array();
    while ($row = $result->fetch_assoc()) {
        $productlist = array();
        $productlist['product_id'] = $row['product_id'];
        $productlist['product_name'] = $row['product_name'];
        $productlist['product_description'] = $row['product_description'];
        $productlist['product_type'] = $row['product_type'];
        $productlist['product_barcode'] = $row['product_barcode'];
        $productlist['product_date'] = $row['product_date'];
        $productlist['product_warranty'] = $row['product_warranty'];
        $productlist['product_origin'] = $row['product_origin'];
        $productlist['product_encryptedcode'] = $row['product_encryptedcode'];
        $productlist['retailer_regdate'] = $row['retailer_regdate'];
        array_push($products["products"], $productlist);
    }
    $response = array(
        'status' => 'success', 'pageno' => "$pageno", 'numofpage' => "$number_of_page", 'data' => $products);
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
