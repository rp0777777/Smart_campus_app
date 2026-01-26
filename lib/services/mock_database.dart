class MockDatabase {
  // Singleton Pattern
  static final MockDatabase _instance = MockDatabase._internal();
  factory MockDatabase() => _instance;
  MockDatabase._internal();

  // Data Stores
  final List<Map<String, dynamic>> _issues = [];
  final List<Map<String, dynamic>> _attendanceRecords = [];
  final List<Map<String, dynamic>> _hostelComplaints = [];
  final List<Map<String, dynamic>> _sosAlerts = [];
  final List<Map<String, dynamic>> _classroomBookings = [];
  
  // Real-time states
  final List<Map<String, dynamic>> _parkingSlots = [
    {"id": "A1", "location": "Main Gate", "isAvailable": true},
    {"id": "A2", "location": "Main Gate", "isAvailable": false},
    {"id": "B1", "location": "Software Block", "isAvailable": true},
    {"id": "B2", "location": "Software Block", "isAvailable": true},
  ];

  final List<Map<String, dynamic>> _events = [
    {"name": "Tech Fest 2026", "date": "Oct 15", "loc": "Amity Center", "color": 0xFF9C27B0},
    {"name": "Cultural Night", "date": "Nov 02", "loc": "Seminar Complex", "color": 0xFFE91E63},
    {"name": "Hackathon", "date": "Dec 10", "loc": "Seminar Hall", "color": 0xFF2196F3},
  ];

  // --- Issues ---
  void addIssue(Map<String, dynamic> issue) {
    _issues.insert(0, {
      ...issue,
      "time": DateTime.now().toIso8601String(),
      "status": "Pending",
    });
  }
  
  List<Map<String, dynamic>> getIssues() => List.unmodifiable(_issues);
  
  // --- Attendance ---
  void markAttendance(String studentId, String course, {String? selfiePath}) {
    _attendanceRecords.add({
      "studentId": studentId,
      "course": course,
      "selfiePath": selfiePath,
      "time": DateTime.now().toIso8601String(),
    });
  }

  List<Map<String, dynamic>> getAttendance() => List.unmodifiable(_attendanceRecords);

  // --- Parking (Admin Controlled) ---
  List<Map<String, dynamic>> getParkingSlots() => _parkingSlots;
  
  void toggleParkingSlot(String id) {
    final index = _parkingSlots.indexWhere((s) => s['id'] == id);
    if (index != -1) {
      _parkingSlots[index]['isAvailable'] = !_parkingSlots[index]['isAvailable'];
    }
  }

  // --- Safety SOS ---
  void triggerSOS(String userName, String location) {
    _sosAlerts.insert(0, {
      "user": userName,
      "location": location,
      "time": DateTime.now().toIso8601String(),
    });
  }

  List<Map<String, dynamic>> getSOSAlerts() => List.unmodifiable(_sosAlerts);

  // --- Classroom Booking ---
  void bookClassroom(String room, String user, String club) {
    _classroomBookings.insert(0, {
      "room": room,
      "user": user,
      "club": club,
      "time": DateTime.now().toIso8601String(),
    });
  }

  List<Map<String, dynamic>> getClassroomBookings() => List.unmodifiable(_classroomBookings);

  // --- Hostel ---
  void addHostelComplaint(Map<String, dynamic> complaint) {
    _hostelComplaints.add(complaint);
    _issues.insert(0, {
      ...complaint,
      "category": "Hostel",
      "location": complaint['room'],
      "description": "${complaint['hostel']} - ${complaint['issue']}",
      "status": "Pending",
      "time": DateTime.now().toIso8601String(),
      "id": "#H-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}"
    });
  }

  List<Map<String, dynamic>> getHostelComplaints() => List.unmodifiable(_hostelComplaints);

  // --- Canteen ---
  final List<Map<String, dynamic>> _canteenOrders = [];
  void placeOrder(String item, String price) {
    _canteenOrders.add({
      "item": item,
      "price": price,
      "status": "Paid",
      "time": DateTime.now().toIso8601String(),
    });
  }

  // --- Events ---
  final List<Map<String, dynamic>> _eventRegistrations = [];
  List<Map<String, dynamic>> getEvents() => List.unmodifiable(_events);
  
  void registerForEvent(String eventName, String studentName) {
    _eventRegistrations.add({
      "event": eventName,
      "student": studentName,
      "time": DateTime.now().toIso8601String(),
    });
  }

  List<Map<String, dynamic>> getEventRegistrations() => List.unmodifiable(_eventRegistrations);
}

