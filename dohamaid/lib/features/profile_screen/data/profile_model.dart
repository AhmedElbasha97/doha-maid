class ProfileModel {
  final int id;
  final String name;
  final String? mobile;
  final String email;
  final String createdAt;
  final String credit;


  ProfileModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.createdAt,
    required this.credit,
  });


  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
      email: json['email'],
      createdAt: json['created_at'], credit: "${json["balance"]}",
    );
  }
}