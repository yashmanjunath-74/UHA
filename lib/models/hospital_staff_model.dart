class HospitalStaffModel {
  final String id;
  final String hospitalId;
  final String name;
  final String role;
  final String department;
  final String status;
  final String phone;
  final String email;
  final String? avatarUrl;
  final bool isDoctor;

  HospitalStaffModel({
    required this.id,
    required this.hospitalId,
    required this.name,
    required this.role,
    required this.department,
    required this.status,
    required this.phone,
    required this.email,
    this.avatarUrl,
    required this.isDoctor,
  });

  factory HospitalStaffModel.fromMap(Map<String, dynamic> map) {
    return HospitalStaffModel(
      id: map['id']?.toString() ?? '',
      hospitalId: map['hospital_id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      role: map['role']?.toString() ?? '',
      department: map['department']?.toString() ?? '',
      status: map['status']?.toString() ?? 'Active',
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      avatarUrl: map['avatar_url']?.toString(),
      isDoctor: map['is_doctor'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id.isNotEmpty) 'id': id,
      'hospital_id': hospitalId,
      'name': name,
      'role': role,
      'department': department,
      'status': status,
      'phone': phone,
      'email': email,
      'avatar_url': avatarUrl,
      'is_doctor': isDoctor,
    };
  }
}
