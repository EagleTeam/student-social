enum EventType { pop, loading, alertMessage, alertUpdateSchedule }

class Events {
  const Events([this.type, this.data]);

  final EventType type;
  final dynamic data;
}
