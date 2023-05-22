    <?php
    if (!isset($_POST)) {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
        die();
    }

    include_once("dbconnect.php");
    $encryptedcode = $_POST['encryptedcode'];
    $sqlloadregisterproduct = "SELECT tbl_product.*,
    GROUP_CONCAT(DISTINCT manufacturer.user_name) AS manufacturer_name,
    GROUP_CONCAT(DISTINCT retailer.user_name) AS retailer_name,
    GROUP_CONCAT(DISTINCT buyer.user_name) AS buyer_name
    FROM tbl_product
    LEFT JOIN tbl_user AS manufacturer ON tbl_product.manufacturer_id = manufacturer.user_id
    LEFT JOIN tbl_user AS retailer ON tbl_product.retailer_id = retailer.user_id
    LEFT JOIN tbl_user AS buyer ON tbl_product.buyer_id = buyer.user_id
    WHERE product_encryptedcode = '$encryptedcode'
    GROUP BY tbl_product.product_id;";

    $result = $conn->query($sqlloadregisterproduct);
    $numrow = $result->num_rows;

    if ($numrow > 0) {
        while ($row = $result->fetch_assoc()) {
            $product['product_id'] = $row['product_id'];
            $product['product_name'] = $row['product_name'];
            $product['product_description'] = $row['product_description'];
            $product['product_type'] = $row['product_type'];
            $product['product_barcode'] = $row['product_barcode'];
            $product['product_date'] = $row['product_date'];
            $product['product_warranty'] = $row['product_warranty'];
            $product['product_origin'] = $row['product_origin'];
            $product['product_encryptedcode'] = $row['product_encryptedcode'];
            $product['product_insertdate'] = $row['product_insertdate'];
            $product['manufacturer_id'] = $row['manufacturer_id'];
            $product['manufacturer_regid'] = $row['manufacturer_regid'];
            $product['manufacturer_regdate'] = $row['manufacturer_regdate'];
            $product['manufacturer_name'] = $row['manufacturer_name'];
            $product['retailer_id'] = $row['retailer_id'];
            $product['retailer_regdate'] = $row['retailer_regdate'];
            $product['retailer_name'] = $row['retailer_name'];
            $product['buyer_id'] = $row['buyer_id'];
            $product['buyer_regdate'] = $row['buyer_regdate'];
            $product['buyer_name'] = $row['buyer_name'];
        }
        $response = array('status' => 'success', 'data' => $product);
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
