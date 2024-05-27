import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kudosware/core/enums.dart';
import 'package:kudosware/core/exception/exception.dart';

class Student {
  const Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;

  final String firstName;

  final String lastName;

  final GenderEnum gender;

  final DateTime dateOfBirth;

  final DateTime createdAt;

  final DateTime updatedAt;

  factory Student.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    if (data
        case {
          'id': String id,
          'first_name': String firstName,
          'last_name': String lastName,
          'gender': GenderEnum gender,
          'date_of_birth': Timestamp dateOfBirth,
          'created_at': Timestamp createdAt,
          'updated_at': Timestamp updatedAt,
        }) {
      return Student(
        id: id,
        firstName: firstName,
        lastName: lastName,
        gender: gender,
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
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender.name,
        'date_of_birth': Timestamp.fromDate(dateOfBirth),
        'created_at': Timestamp.fromDate(createdAt),
        'updated_at': Timestamp.fromDate(updatedAt),
      };

  Student copyWith({
    String? id,
    String? firstName,
    String? lastName,
    GenderEnum? gender,
    DateTime? dateOfBirth,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Student empty() {
    final dummyDate = DateTime.now();

    return Student(
      id: '',
      firstName: '',
      lastName: '',
      gender: GenderEnum.other,
      dateOfBirth: dummyDate,
      createdAt: dummyDate,
      updatedAt: dummyDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Student &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.gender == gender &&
        other.dateOfBirth == dateOfBirth &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        firstName,
        lastName,
        gender.name,
        dateOfBirth,
        createdAt,
        updatedAt,
      ]);
}
