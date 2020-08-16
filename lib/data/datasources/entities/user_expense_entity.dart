import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'user_expense_entity.g.dart';

@HiveType(typeId: 3)
class UserExpenseEntity extends Equatable {
  @HiveField(0)
  final List<int> receiversIds;

  @HiveField(1)
  final int userId;

  @HiveField(2)
  final String amount;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String currency;

  @HiveField(5)
  final int projectId;

  @HiveField(6)
  final String dateTime;

  const UserExpenseEntity(
      {@required this.receiversIds,
      @required this.userId,
      @required this.amount,
      @required this.description,
      @required this.currency,
      @required this.projectId,
      @required this.dateTime});

  @override
  List<Object> get props => [
        receiversIds,
        userId,
        amount,
        description,
        currency,
        projectId,
        dateTime
      ];
}
