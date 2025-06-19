import 'package:auth_firebase/data/models/plan.dart';



abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<Plan> plans;
  SubscriptionLoaded(this.plans);
}

class SubscriptionError extends SubscriptionState {
  final String message;
  SubscriptionError(this.message);
}
