import 'package:auth_firebase/data/repositories/subscription_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';


class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository repo;

  SubscriptionBloc(this.repo) : super(SubscriptionInitial()) {
    on<LoadPlans>((event, emit) async {
      emit(SubscriptionLoading());
      try {
        final plans = await repo.getPlans();
        emit(SubscriptionLoaded(plans));
      } catch (e) {
        emit(SubscriptionError(e.toString()));
      }
    });

    on<AddPlan>((event, emit) async {
      try {
        await repo.createPlan(event.plan);
        final plans = await repo.getPlans();
        emit(SubscriptionLoaded(plans));
      } catch (e) {
        emit(SubscriptionError(e.toString()));
      }
    });

    on<UpdatePlan>((event, emit) async {
      try {
        await repo.updatePlan(event.id, event.updatedPlan);
        final plans = await repo.getPlans();
        emit(SubscriptionLoaded(plans));
      } catch (e) {
        emit(SubscriptionError(e.toString()));
      }
    });

    on<DeletePlan>((event, emit) async {
      try {
        await repo.deletePlan(event.id);
        final plans = await repo.getPlans();
        emit(SubscriptionLoaded(plans));
      } catch (e) {
        emit(SubscriptionError(e.toString()));
      }
    });
  }
}
