<?php
include 'koneksi.php';

$query = mysqli_query($conn, "SELECT * FROM tb_kost ORDER BY id DESC");
$data = [];

while ($row = mysqli_fetch_assoc($query)) {
    $row['foto'] = $row['gambar'] ? "http://192.168.77.163/kost_app/uploads/" . $row['gambar'] : "";
    $data[] = $row;
}

echo json_encode([
    "status" => true,
    "data" => $data
]);
?>
