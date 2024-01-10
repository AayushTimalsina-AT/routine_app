import 'package:isar/isar.dart';
part 'category.g.dart';

@Collection()
class Category {
 Id categoryId = Isar.autoIncrement;
  @Index(unique: true)
  late String name;
}
