<?php
// Include file koneksi
include 'config.php';

// Header untuk REST API
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json");

// Ambil data dari body JSON
$data = json_decode(file_get_contents("php://input"), true);

// Inisialisasi respons
$response = ['status' => false, 'message' => ''];

// Ambil data input dan sanitasi
$nama     = isset($data['nama']) ? trim($data['nama']) : '';
$email    = isset($data['email']) ? trim($data['email']) : '';
$password = isset($data['password']) ? trim($data['password']) : '';

// Validasi input kosong
if ($nama === '' || $email === '' || $password === '') {
    $response['message'] = "Semua field wajib diisi!";
    echo json_encode($response);
    exit;
}

// Validasi format email
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    $response['message'] = "Format email tidak valid!";
    echo json_encode($response);
    exit;
}

// Cek apakah email sudah terdaftar
$cek = $conn->prepare("SELECT id FROM users WHERE email = ?");
$cek->bind_param("s", $email);
$cek->execute();
$cek->store_result();

if ($cek->num_rows > 0) {
    $response['message'] = "Email sudah digunakan!";
    echo json_encode($response);
    exit;
}

// Hash password
$hashedPassword = password_hash($password, PASSWORD_BCRYPT);

// Simpan ke database
$stmt = $conn->prepare("INSERT INTO users (nama, email, password) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $nama, $email, $hashedPassword);

if ($stmt->execute()) {
    $response['status'] = true;
    $response['message'] = "Registrasi berhasil!";
} else {
    $response['message'] = "Gagal menyimpan data: " . $stmt->error;
}

// Output JSON
echo json_encode($response);

// Tutup koneksi
$stmt->close();
$cek->close();
$conn->close();
?>
