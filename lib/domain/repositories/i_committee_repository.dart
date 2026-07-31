import 'package:apartmate/data/models/committee_model.dart';

abstract class ICommitteeRepository {
  Future<List<CommitteeMemberModel>> getMembers();
  Future<CommitteeMemberModel> addMember(CommitteeMemberModel member);
  Future<void> removeMember(String id);
}