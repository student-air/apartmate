import 'package:apartmate/data/models/complaint_model.dart';
import 'package:apartmate/domain/repositories/i_complaint_repository.dart';

class LocalComplaintRepository implements IComplaintRepository {
  final List<ComplaintModel> _complaints = [
    ComplaintModel(
      id: 'complaint-demo-1',
      category: 'Noise Complaint',
      title: 'Loud music from Flat 302',
      description:
          'Resident in Flat 302 has been playing loud music past midnight for the last three nights. Multiple neighbors have complained.',
      postedAt: DateTime.now().subtract(const Duration(hours: 5)),
      status: ComplaintStatus.pending,
    ),
    ComplaintModel(
      id: 'complaint-demo-2',
      category: 'Maintenance',
      title: 'Broken elevator in Building A',
      description:
          'The elevator in Building A has been out of service since yesterday morning. Residents on higher floors are having difficulty accessing their flats.',
      postedAt: DateTime.now().subtract(const Duration(hours: 12)),
      status: ComplaintStatus.underReview,
    ),
  ];

  final List<ComplaintModel> _resolved = [];

  @override
  Future<List<ComplaintModel>> getComplaints() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<ComplaintModel>.from(_complaints);
  }

  @override
  Future<List<ComplaintModel>> getResolved() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<ComplaintModel>.from(_resolved);
  }

  @override
  Future<void> addComplaint(ComplaintModel complaint) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _complaints.insert(0, complaint);
  }

  @override
  Future<void> updateComplaintStatus(String id, ComplaintStatus status) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _complaints.indexWhere((e) => e.id == id);
    if (index == -1) return;
    _complaints[index] = _complaints[index].copyWith(status: status);
  }

  @override
  Future<void> resolveComplaint(String id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _complaints.indexWhere((e) => e.id == id);
    if (index == -1) return;
    final item = _complaints.removeAt(index);
    _resolved.insert(0, item.copyWith(status: ComplaintStatus.resolved));
  }

  @override
  Future<void> deleteComplaint(String id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _complaints.removeWhere((e) => e.id == id);
  }

  @override
  Future<void> deleteResolved(String id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _resolved.removeWhere((e) => e.id == id);
  }

  @override
  Future<void> clearAll() async {
    await Future.delayed(const Duration(milliseconds: 250));
    _complaints.clear();
  }

  @override
  Future<void> clearResolved() async {
    await Future.delayed(const Duration(milliseconds: 250));
    _resolved.clear();
  }
}