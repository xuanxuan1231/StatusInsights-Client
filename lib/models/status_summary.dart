class StatusSummary {
  final String name;
  final PersonStatus person;
  final List<DeviceStatus> devices;

  StatusSummary({
    required this.name,
    required this.person,
    required this.devices,
  });

  factory StatusSummary.fromJson(Map<String, dynamic> json) {
    return StatusSummary(
      name: json['name'] as String? ?? 'Unknown',
      person: PersonStatus.fromJson(
        json['person'] as Map<String, dynamic>? ?? {},
      ),
      devices:
          (json['devices'] as List<dynamic>?)
              ?.map(
                (device) =>
                    DeviceStatus.fromJson(device as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'person': person.toJson(),
    'devices': devices.map((d) => d.toJson()).toList(),
  };
}

class PersonStatus {
  final String status;
  final String description;

  PersonStatus({required this.status, required this.description});

  factory PersonStatus.fromJson(Map<String, dynamic> json) {
    return PersonStatus(
      status: json['status'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? 'No description',
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'description': description,
  };
}

class DeviceStatus {
  final String deviceId;
  final String name;
  final String deviceType;
  final String description;
  final String status;

  DeviceStatus({
    required this.deviceId,
    required this.name,
    required this.deviceType,
    required this.description,
    required this.status,
  });

  factory DeviceStatus.fromJson(Map<String, dynamic> json) {
    return DeviceStatus(
      deviceId: json['device_id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Device',
      deviceType: json['device_type'] as String? ?? 'unknown',
      description: json['description'] as String? ?? 'No description',
      status: json['status'] as String? ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    'device_id': deviceId,
    'name': name,
    'device_type': deviceType,
    'description': description,
    'status': status,
  };
}
