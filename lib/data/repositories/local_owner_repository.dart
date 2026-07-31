import 'package:apartmate/data/models/owner_model.dart';
import 'package:apartmate/domain/repositories/i_owner_repository.dart';

class LocalOwnerRepository implements IOwnerRepository {
  final List<OwnerModel> _owners = [];

  @override
  Future<List<OwnerModel>> getOwners() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_owners);
  }

  @override
  Future<OwnerModel> addOwner(OwnerModel owner) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _owners.add(owner);
    return owner;
  }

  @override
  Future<void> removeOwner(String id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _owners.removeWhere((o) => o.id == id);
  }
}