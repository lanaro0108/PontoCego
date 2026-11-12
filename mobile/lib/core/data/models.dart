import 'dart:convert';
import 'dart:typed_data';

const demoOrganizationId = 'senai-demo';
const demoOrganizationName = 'SENAI · Unidade demonstrativa';
const demoEmail = 'comunidade@pontocego.demo';
const demoPassword = 'PontoCego123!';

class AppFailure implements Exception {
  const AppFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

enum ReportStatus {
  open('Aberta'),
  review('Em análise'),
  progress('Em andamento'),
  resolved('Resolvida');

  const ReportStatus(this.label);
  final String label;
}

enum Category {
  mobility('Mobilidade'),
  signage('Sinalização'),
  access('Acesso'),
  communication('Comunicação'),
  other('Outros');

  const Category(this.label);
  final String label;
}

class CommunityUser {
  const CommunityUser({
    required this.id,
    required this.name,
    required this.email,
    required this.organizationId,
  });
  final String id, name, email, organizationId;
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'organizationId': organizationId,
  };
  factory CommunityUser.fromJson(Map<String, dynamic> json) => CommunityUser(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    organizationId: json['organizationId'] as String,
  );
}

class Location {
  const Location(
    this.id,
    this.block,
    this.room, {
    this.organizationId = demoOrganizationId,
  });
  final String id, block, room, organizationId;
  String get label => '$block · $room';
}

const demoLocations = [
  Location('a-entry', 'Bloco A', 'Entrada principal'),
  Location('a-hall', 'Bloco A', 'Corredor térreo'),
  Location('a-library', 'Bloco A', 'Biblioteca'),
  Location('b-lab', 'Bloco B', 'Laboratório'),
  Location('b-class', 'Bloco B', 'Salas de aula'),
  Location('common', 'Área comum', 'Pátio'),
  Location('canteen', 'Área comum', 'Cantina'),
];

class ReportUpdate {
  const ReportUpdate({
    required this.status,
    required this.note,
    required this.at,
  });
  final ReportStatus status;
  final String note;
  final DateTime at;
  Map<String, dynamic> toJson() => {
    'status': status.name,
    'note': note,
    'at': at.toUtc().toIso8601String(),
  };
  factory ReportUpdate.fromJson(Map<String, dynamic> j) => ReportUpdate(
    status: ReportStatus.values.byName(j['status'] as String),
    note: j['note'] as String,
    at: DateTime.parse(j['at'] as String),
  );
}

class BarrierReport {
  const BarrierReport({
    required this.id,
    required this.organizationId,
    required this.authorId,
    required this.locationId,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.updates,
    this.photoBase64,
  });
  final String id, organizationId, authorId, locationId, title, description;
  final Category category;
  final ReportStatus status;
  final DateTime createdAt;
  final List<ReportUpdate> updates;
  final String? photoBase64;
  Location get location => demoLocations.firstWhere(
    (l) => l.id == locationId && l.organizationId == organizationId,
  );
  Uint8List? get photoBytes =>
      photoBase64 == null ? null : base64Decode(photoBase64!);
  Map<String, dynamic> toJson() => {
    'id': id,
    'organizationId': organizationId,
    'authorId': authorId,
    'locationId': locationId,
    'title': title,
    'description': description,
    'category': category.name,
    'status': status.name,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updates': updates.map((u) => u.toJson()).toList(),
    'photoBase64': photoBase64,
  };
  factory BarrierReport.fromJson(Map<String, dynamic> j) => BarrierReport(
    id: j['id'] as String,
    organizationId: j['organizationId'] as String,
    authorId: j['authorId'] as String,
    locationId: j['locationId'] as String,
    title: j['title'] as String,
    description: j['description'] as String,
    category: Category.values.byName(j['category'] as String),
    status: ReportStatus.values.byName(j['status'] as String),
    createdAt: DateTime.parse(j['createdAt'] as String),
    updates: (j['updates'] as List)
        .map((u) => ReportUpdate.fromJson(Map<String, dynamic>.from(u as Map)))
        .toList(),
    photoBase64: j['photoBase64'] as String?,
  );
}

class NewReport {
  const NewReport({
    required this.title,
    required this.description,
    required this.category,
    required this.locationId,
    this.photoBase64,
  });
  final String title, description, locationId;
  final Category category;
  final String? photoBase64;
}

class AccessibilityPreferences {
  const AccessibilityPreferences({
    this.highContrast = false,
    this.reduceMotion = false,
  });
  final bool highContrast, reduceMotion;
  Map<String, dynamic> toJson() => {
    'highContrast': highContrast,
    'reduceMotion': reduceMotion,
  };
  factory AccessibilityPreferences.fromJson(Map<String, dynamic> j) =>
      AccessibilityPreferences(
        highContrast: j['highContrast'] == true,
        reduceMotion: j['reduceMotion'] == true,
      );
}

class ReportFilter {
  const ReportFilter({
    this.query = '',
    this.status,
    this.category,
    this.locationId,
    this.authorId,
  });
  final String query;
  final ReportStatus? status;
  final Category? category;
  final String? locationId, authorId;
  List<BarrierReport> apply(Iterable<BarrierReport> reports) {
    final needle = normalize(query.trim());
    return reports
        .where(
          (r) =>
              (status == null || r.status == status) &&
              (category == null || r.category == category) &&
              (locationId == null || r.locationId == locationId) &&
              (authorId == null || r.authorId == authorId) &&
              (needle.isEmpty ||
                  normalize('${r.title} ${r.location.label}').contains(needle)),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}

String normalize(String value) {
  const from = 'áàâãäéèêëíìîïóòôõöúùûüç';
  const to = 'aaaaaeeeeiiiiooooouuuuc';
  var text = value.toLowerCase();
  for (var i = 0; i < from.length; i++) {
    text = text.replaceAll(from[i], to[i]);
  }
  return text;
}

String? requiredText(String? value, {int min = 1, int max = 500}) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return 'Preencha este campo.';
  if (text.length < min) return 'Use pelo menos $min caracteres.';
  if (text.length > max) return 'Use no máximo $max caracteres.';
  return null;
}

String? validateEmail(String? value) =>
    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value?.trim() ?? '')
    ? null
    : 'Informe um e-mail válido.';
String? validatePassword(String? value) {
  if ((value ?? '').length < 8 ||
      !RegExp(r'[0-9]').hasMatch(value!) ||
      !RegExp(r'[a-zA-Z]').hasMatch(value)) {
    return 'Use 8 caracteres ou mais, com letras e números.';
  }
  return null;
}
