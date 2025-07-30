<?php
header("Content-Type: application/json");
include 'config.php';

$nama   = $_POST['nama_kost'] ?? '';
$alamat = $_POST['alamat'] ?? '';
$harga  = $_POST['harga'] ?? '';
$gambar = "";

// Validasi data kosong
if (empty($nama) || empty($alamat) || empty($harga)) {
    echo json_encode(["status" => false, "message" => "Data tidak lengkap."]);
    exit;
}

// Proses upload gambar
if (isset($_FILES['gambar']) && $_FILES['gambar']['error'] == 0) {
    $ext = pathinfo($_FILES['gambar']['name'], PATHINFO_EXTENSION);
    $filename = uniqid() . '.' . $ext;
    $uploadPath = 'uploads/' . $filename;

    if (move_uploaded_file($_FILES['gambar']['tmp_name'], $uploadPath)) {
        $gambar = $filename;
    } else {
        echo json_encode(["status" => false, "message" => "Upload gambar gagal."]);
        exit;
    }
}

$query = "INSERT INTO tb_kost (nama_kost, alamat, harga, gambar) VALUES (?, ?, ?, ?)";
$stmt = $conn->prepare($query);
$stmt->bind_param("ssss", $nama, $alamat, $harga, $gambar);

if ($stmt->execute()) {
    echo json_encode(["status" => true, "message" => "Data berhasil disimpan."]);
} else {
    echo json_encode(["status" => false, "message" => "Gagal menyimpan data. Error: " . $conn->error]);
}

$stmt->close();
$conn->close();
?>
