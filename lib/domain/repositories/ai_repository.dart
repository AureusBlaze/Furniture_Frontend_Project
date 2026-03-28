import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:mirage_by_aurues/core/error/failures.dart';
import 'package:mirage_by_aurues/domain/entities/product.dart';

abstract class AiRepository {
  /// Upload a room photo and get product suggestions.
  Future<Either<Failure, List<Product>>> getSuggestions(File image);
}
