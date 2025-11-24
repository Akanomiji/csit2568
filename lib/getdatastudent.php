<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json; charset=UTF-8');
include("conn.php");

// ดึงข้อมูลทั้งหมดจาก tb_user
$sql = "SELECT * FROM tb_user ORDER BY firstname ASC";
$result = mysqli_query($conn, $sql);

$data = array();
while($row = mysqli_fetch_assoc($result)){
    $data[] = $row;
}

echo json_encode($data);
?>