import 'package:apartmate/data/models/complaint_model.dart';

abstract class IComplaintRepository {
  Future<List<ComplaintModel>> getComplaints();
  Future<List<ComplaintModel>> getResolved();
  Future<void> addComplaint(ComplaintModel complaint);
  Future<void> updateComplaintStatus(String id, ComplaintStatus status);
  Future<void> resolveComplaint(String id);
  Future<void> deleteComplaint(String id);
  Future<void> deleteResolved(String id);
  Future<void> clearAll();
  Future<void> clearResolved();
}