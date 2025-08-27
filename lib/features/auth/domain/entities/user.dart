class User {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String role;
  final String? profileImage;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.profileImage,
  });
}
