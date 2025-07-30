include 'config.php';

$user_id = $_POST['user_id'];
$kost_id = $_POST['kost_id'];
$durasi = $_POST['durasi']; // 'sebulan' atau 'setahun'

// Ambil harga dari database kost
$sql = "SELECT harga FROM kost WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $kost_id);
$stmt->execute();
$stmt->bind_result($harga);
$stmt->fetch();
$stmt->close();

// Hitung total harga
$total_harga = ($durasi == 'setahun') ? $harga * 12 : $harga;

// Simpan ke tabel pesanan
$sql2 = "INSERT INTO pesanan (user_id, kost_id, tanggal_pesan, durasi, total_harga) VALUES (?, ?, CURDATE(), ?, ?)";
$stmt2 = $conn->prepare($sql2);
$stmt2->bind_param("iisi", $user_id, $kost_id, $durasi, $total_harga);

if ($stmt2->execute()) {
    echo json_encode(['status' => true, 'message' => 'Pesanan berhasil dibuat']);
} else {
    echo json_encode(['status' => false, 'message' => 'Gagal membuat pesanan']);
}
$stmt2->close();
$conn->close();
