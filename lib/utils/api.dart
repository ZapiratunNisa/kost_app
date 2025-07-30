class Api {
  // Ganti IP ini sesuai dengan alamat server kamu
  static const String baseUrl = 'http://localhost/kost_api';

  static const String login = '$baseUrl/login.php';
  static const String register = '$baseUrl/register.php';
  static const String addKost = '$baseUrl/add_kost.php';
  static const String getKost = '$baseUrl/get_kost.php';
}
