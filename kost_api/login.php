<?php
ob_start();

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json");

include 'config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => false, 'message' => 'Metode request tidak diizinkan.']);
    ob_end_flush();
    exit;
}

$data = json_decode(file_get_contents("php://input"), true);
$email    = $data['email'] ?? '';
$password = $data['password'] ?? '';

if (empty($email) || empty($password)) {
    echo json_encode(['status' => false, 'message' => 'Email dan password tidak boleh kosong.']);
    ob_end_flush();
    exit;
}

$sql = "SELECT * FROM users WHERE email = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

if ($user && password_verify($password, $user['password'])) {
    unset($user['password']);
    echo json_encode(['status' => true, 'message' => 'Login berhasil.', 'data' => $user]);
} else {
    echo json_encode(['status' => false, 'message' => 'Login gagal. Email atau password salah.']);
}

$stmt->close();
$conn->close();
ob_end_flush(); // KIRIM OUTPUT, jangan hapus!
?>
