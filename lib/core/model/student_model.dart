import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:kudosware/core/enums.dart';
import 'package:kudosware/core/exception/exception.dart';

final class StudentEntry extends Equatable {
  const StudentEntry({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;

  final String userId;

  final String firstName;

  final String lastName;

  final GenderEnum gender;

  final DateTime dateOfBirth;

  final DateTime createdAt;

  final DateTime updatedAt;

  factory StudentEntry.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    if (data
        case {
          'id': String id,
          'user_id': String userId,
          'first_name': String firstName,
          'last_name': String lastName,
          'gender': String gender,
          'date_of_birth': Timestamp dateOfBirth,
          'created_at': Timestamp createdAt,
          'updated_at': Timestamp updatedAt,
        }) {
      return StudentEntry(
        id: id,
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        gender: GenderEnum.fromString(gender),
        dateOfBirth: dateOfBirth.toDate(),
        createdAt: createdAt.toDate(),
        updatedAt: updatedAt.toDate(),
      );
    } else {
      throw MalformedDocumentException(data: data);
    }
  }

  Map<String, dynamic> toFirestore() => {
        'id': id,
        'user_id': userId,
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender.name,
        'date_of_birth': Timestamp.fromDate(dateOfBirth),
        'created_at': Timestamp.fromDate(createdAt),
        'updated_at': Timestamp.fromDate(updatedAt),
      };

  StudentEntry copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? lastName,
    GenderEnum? gender,
    DateTime? dateOfBirth,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudentEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static StudentEntry empty() {
    final dummyDate = DateTime.now();

    return StudentEntry(
      id: '',
      userId: '',
      firstName: '',
      lastName: '',
      gender: GenderEnum.other,
      dateOfBirth: dummyDate,
      createdAt: dummyDate,
      updatedAt: dummyDate,
    );
  }

  String get fullName => "$firstName $lastName";
  String get dobString =>
      "${dateOfBirth.day.toString().padLeft(2, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.year}";

  @override
  List<Object> get props => [
        id,
        userId,
        firstName,
        lastName,
        gender,
        dateOfBirth,
        createdAt,
        updatedAt,
      ];
}
