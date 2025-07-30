<?php
header("Content-Type: application/json");

$host = "localhost";
$user = "root";
$pass = "";
$db   = "kost_db";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode([
        'status' => false,
        'message' => 'Koneksi database gagal: ' . $conn->connect_error
    ]);
    exit;
}
?>
