import 'package:apartmate/data/models/committee_model.dart';
import 'package:apartmate/domain/repositories/i_committee_repository.dart';

class LocalCommitteeRepository implements ICommitteeRepository {
  final List<CommitteeMemberModel> _members = [];

  @override
  Future<List<CommitteeMemberModel>> getMembers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_members);
  }

  @override
  Future<CommitteeMemberModel> addMember(CommitteeMemberModel member) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _members.add(member);
    return member;
  }

  @override
  Future<void> removeMember(String id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _members.removeWhere((m) => m.id == id);
  }
}