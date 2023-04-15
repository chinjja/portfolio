import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

final uuidProvider = Provider((ref) => const Uuid());
