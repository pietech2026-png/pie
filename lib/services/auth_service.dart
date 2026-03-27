class AuthService {
  static String? phoneNumber;

  static void login(String phone) {
    phoneNumber = phone;
  }

  static void logout() {
    phoneNumber = null;
  }
}
