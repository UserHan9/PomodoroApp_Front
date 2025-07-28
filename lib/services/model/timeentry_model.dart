class TimeEntry {
  final Duration duration;
  final String relativeCreatedAt;

  TimeEntry({
    required this.duration,
    required this.relativeCreatedAt,
  });

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      duration: Duration(seconds: json['duration']),
      relativeCreatedAt: json['relative_created_at'],
    );
  }
}

// Fungsi untuk memformat durasi
String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '${hours}h ${minutes}m ${seconds}s';
  } else if (minutes > 0) {
    return '${minutes}m ${seconds}s';
  } else {
    return '${seconds}s';
  }
}
