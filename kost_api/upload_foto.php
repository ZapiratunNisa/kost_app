<?php
include 'config.php';

$target_dir = "uploads/";
$target_file = $target_dir . basename($_FILES["foto"]["name"]);
$imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

if (move_uploaded_file($_FILES["foto"]["tmp_name"], $target_file)) {
    $nama_kost = $_POST['nama_kost'];
    $alamat    = $_POST['alamat'];
    $harga     = $_POST['harga'];
    $foto      = basename($_FILES["foto"]["name"]);

    $sql = "INSERT INTO kost (nama_kost, alamat, harga, foto) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssis", $nama_kost, $alamat, $harga, $foto);

    if ($stmt->execute()) {
        echo json_encode(['status' => true, 'message' => 'Data kost berhasil diunggah']);
    } else {
        echo json_encode(['status' => false, 'message' => 'Gagal menyimpan ke DB']);
    }
    $stmt->close();
} else {
    echo json_encode(['status' => false, 'message' => 'Upload foto gagal']);
}

$conn->close();
?>
