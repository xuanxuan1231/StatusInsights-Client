class StatusReport {
  final String guid;
  final String? windowTitle;
  final String? personStatus;
  final DateTime timestamp;

  StatusReport({
    required this.guid,
    this.windowTitle,
    this.personStatus,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'guid': guid,
        if (windowTitle != null && windowTitle!.isNotEmpty) 'status': windowTitle,
        if (personStatus != null && personStatus!.isNotEmpty)
          'person_status': personStatus,
        'timestamp': timestamp.toIso8601String(),
      };
}
