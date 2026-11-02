import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  
  // Batas timeout standar (5 detik)
  static const Duration _timeout = Duration(seconds: 5);

  Future<List<User>> getUsers() async {
    try {
      print('Request GET: $_baseUrl/users');

      final response = await http
          .get(Uri.parse('$_baseUrl/users'))
          .timeout(_timeout);

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data. Status: ${response.statusCode}');
      }
    } on TimeoutException {
      // Penanganan khusus jika terjadi timeout
      throw Exception(
        'Koneksi lambat / RTO (Request Timeout). Silakan coba beberapa saat lagi.',
      );
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<String> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      if (email.isNotEmpty && password.isNotEmpty) {
        final token = 'dummy_token_${DateTime.now().millisecondsSinceEpoch}';
        print('Login berhasil untuk email: $email');
        return token;
      } else {
        throw Exception('Email dan password tidak boleh kosong');
      }
    } catch (e) {
      throw Exception('Login gagal: $e');
    }
  }

  Future<User> createUser(String name, String username, String email) async {
    try {
      print('Request POST: $_baseUrl/users');
      final response = await http
          .post(
            Uri.parse('$_baseUrl/users'),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode({
              'name': name,
              'username': username,
              'email': email,
            }),
          )
          .timeout(_timeout);

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Gagal menambah data. Status: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception(
        'Gagal menambah data: Request Timeout. Silakan coba lagi.',
      );
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}