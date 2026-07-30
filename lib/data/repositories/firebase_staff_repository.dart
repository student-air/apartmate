import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apartmate/data/models/staff_model.dart';
import 'package:apartmate/domain/repositories/i_staff_repository.dart';

class FirebaseStaffRepository implements IStaffRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get _uid {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('No signed-in user');
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _staffCol =>
      _db.collection('societies').doc(_uid).collection('staff');

  @override
  Future<List<StaffModel>> getStaff() async {
    final snap = await _staffCol.get();
    return snap.docs.map((doc) => _fromMap(doc.id, doc.data())).toList();
  }

  @override
  Future<StaffModel> addStaff(StaffModel staff) async {
    final docRef = _staffCol.doc();
    final withId = StaffModel(
      id: docRef.id,
      name: staff.name,
      phone: staff.phone,
      cnic: staff.cnic,
      role: staff.role,
      customRoleLabel: staff.customRoleLabel,
      photoPath: staff.photoPath,
    );
    await docRef.set(_toMap(withId));
    return withId;
  }

  @override
  Future<StaffModel> updateStaff(StaffModel staff) async {
    await _staffCol.doc(staff.id).update(_toMap(staff));
    return staff;
  }

  @override
  Future<void> deleteStaff(String staffId) async {
    await _staffCol.doc(staffId).delete();
  }

  Map<String, dynamic> _toMap(StaffModel s) => {
        'name': s.name,
        'phone': s.phone,
        'cnic': s.cnic,
        'role': s.role.name,
        'customRoleLabel': s.customRoleLabel,
        'photoPath': s.photoPath,
      };

  StaffModel _fromMap(String id, Map<String, dynamic> map) {
    return StaffModel(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      cnic: map['cnic'] ?? '',
      role: StaffRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => StaffRole.other,
      ),
      customRoleLabel: map['customRoleLabel'],
      photoPath: map['photoPath'],
    );
  }
}