import 'package:apartmate/data/models/owner_model.dart';

abstract class IOwnerRepository {
  Future<List<OwnerModel>> getOwners();
  Future<OwnerModel> addOwner(OwnerModel owner);
  Future<void> removeOwner(String id);
}