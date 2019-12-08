import 'package:decimal/decimal.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'user_expense_entity.g.dart';

@HiveType()
class UserExpense {
  @HiveField(0)
  final List<int> receiversIds;
  
  @HiveField(1)
  final int userId;
  
  @HiveField(2)
  final Decimal amount;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String currency;

  UserExpense(
      {@required this.receiversIds,
      @required this.userId,
      @required this.amount,
      @required this.description,
      @required this.currency});
}
