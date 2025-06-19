import 'package:auth_firebase/data/models/plan.dart';



abstract class SubscriptionEvent {}

class LoadPlans extends SubscriptionEvent {}

class AddPlan extends SubscriptionEvent {
  final Plan plan;
  AddPlan(this.plan);
}

class UpdatePlan extends SubscriptionEvent {
  final String id;
  final Plan updatedPlan;
  UpdatePlan(this.id, this.updatedPlan);
}

class DeletePlan extends SubscriptionEvent {
  final String id;
  DeletePlan(this.id);
}
