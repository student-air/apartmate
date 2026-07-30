import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apartmate/data/models/society_model.dart';
import 'package:apartmate/domain/repositories/i_society_repository.dart';

class FirebaseSocietyRepository implements ISocietyRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get _uid {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('No signed-in user');
    return uid;
  }

  DocumentReference<Map<String, dynamic>> get _societyDoc =>
      _db.collection('societies').doc(_uid);

  CollectionReference<Map<String, dynamic>> get _buildingsCol =>
      _societyDoc.collection('buildings');

  // ── Society ──

  @override
  Future<SocietyModel> registerSociety(SocietyModel society) async {
    final data = _societyToMap(society);
    await _societyDoc.set(data);
    return society;
  }

  @override
  Future<SocietyModel?> getCurrentSociety() async {
    final snap = await _societyDoc.get();
    if (!snap.exists || snap.data() == null) return null;
    return _societyFromMap(snap.id, snap.data()!);
  }

  @override
  Future<SocietyModel> updateOwnerProfile({required String ownerName, String? ownerPhotoPath}) async {
    final updates = <String, dynamic>{'ownerName': ownerName};
    if (ownerPhotoPath != null) updates['ownerPhotoPath'] = ownerPhotoPath;
    await _societyDoc.update(updates);

    final current = await getCurrentSociety();
    if (current == null) throw StateError('No society registered yet');
    return current;
  }

  // ── Buildings ──

  @override
  Future<List<BuildingModel>> getBuildings() async {
    final snap = await _buildingsCol.get();
    return snap.docs.map((doc) => _buildingFromMap(doc.id, doc.data())).toList();
  }

  @override
  Future<BuildingModel> addBuilding(String name) async {
    final docRef = _buildingsCol.doc();
    final building = BuildingModel(id: docRef.id, name: name);
    await docRef.set(_buildingToMap(building));
    return building;
  }

  @override
  Future<BuildingModel> saveBuildingDetails(String buildingId, BuildingDetailsModel details) async {
    await _buildingsCol.doc(buildingId).update({'details': _buildingDetailsToMap(details)});
    final snap = await _buildingsCol.doc(buildingId).get();
    if (!snap.exists) throw StateError('Building not found: $buildingId');
    return _buildingFromMap(snap.id, snap.data()!);
  }

  @override
  Future<BuildingModel> renameBuilding(String buildingId, String newName) async {
    await _buildingsCol.doc(buildingId).update({'name': newName});
    final snap = await _buildingsCol.doc(buildingId).get();
    if (!snap.exists) throw StateError('Building not found: $buildingId');
    return _buildingFromMap(snap.id, snap.data()!);
  }

  @override
  Future<void> deleteBuilding(String buildingId) async {
    await _buildingsCol.doc(buildingId).delete();
  }

  // ── Mapping helpers ──

  Map<String, dynamic> _societyToMap(SocietyModel s) => {
        'name': s.name,
        'ownerName': s.ownerName,
        'address': s.address,
        'city': s.city,
        'country': s.country,
        'contactNumber': s.contactNumber,
        'description': s.description,
        'ownerPhotoPath': s.ownerPhotoPath,
        'registrationStatus': s.registrationStatus.name,
        'submittedAt': Timestamp.fromDate(s.submittedAt),
      };

  SocietyModel _societyFromMap(String id, Map<String, dynamic> map) {
    return SocietyModel(
      id: id,
      name: map['name'] ?? '',
      ownerName: map['ownerName'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      description: map['description'],
      ownerPhotoPath: map['ownerPhotoPath'],
      registrationStatus: SocietyRegistrationStatus.values.firstWhere(
        (e) => e.name == map['registrationStatus'],
        orElse: () => SocietyRegistrationStatus.pendingReview,
      ),
      submittedAt: (map['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> _buildingToMap(BuildingModel b) => {
        'name': b.name,
        'details': b.details != null ? _buildingDetailsToMap(b.details!) : null,
      };

  BuildingModel _buildingFromMap(String id, Map<String, dynamic> map) {
    final detailsMap = map['details'] as Map<String, dynamic>?;
    return BuildingModel(
      id: id,
      name: map['name'] ?? '',
      details: detailsMap != null ? _buildingDetailsFromMap(detailsMap) : null,
    );
  }

  Map<String, dynamic> _buildingDetailsToMap(BuildingDetailsModel d) => {
        'totalFloors': d.totalFloors,
        'flatsPerFloor': d.flatsPerFloor,
        'oneBedroomFlats': d.oneBedroomFlats,
        'twoBedroomFlats': d.twoBedroomFlats,
        'threeBedroomFlats': d.threeBedroomFlats,
        'hasParking': d.hasParking,
        'parkingSlots': d.parkingSlots,
        'hasLift': d.hasLift,
      };

  BuildingDetailsModel _buildingDetailsFromMap(Map<String, dynamic> map) {
    return BuildingDetailsModel(
      totalFloors: map['totalFloors'] ?? 0,
      flatsPerFloor: map['flatsPerFloor'] ?? 0,
      oneBedroomFlats: map['oneBedroomFlats'] ?? 0,
      twoBedroomFlats: map['twoBedroomFlats'] ?? 0,
      threeBedroomFlats: map['threeBedroomFlats'] ?? 0,
      hasParking: map['hasParking'] ?? false,
      parkingSlots: map['parkingSlots'] ?? 0,
      hasLift: map['hasLift'] ?? false,
    );
  }
}