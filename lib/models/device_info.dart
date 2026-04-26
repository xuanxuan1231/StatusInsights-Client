class DeviceInfo {
  final String guid;
  final String name;
  final String deviceType;

  const DeviceInfo({
    required this.guid,
    required this.name,
    required this.deviceType,
  });

  Map<String, dynamic> toJson() => {
        'guid': guid,
        'name': name,
        'device_type': deviceType,
      };

  @override
  String toString() => 'DeviceInfo(guid: $guid, name: $name, type: $deviceType)';
}
