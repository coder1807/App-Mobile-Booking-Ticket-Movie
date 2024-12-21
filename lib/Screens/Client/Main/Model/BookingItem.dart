class BookingItem {
  final int userID;
  final int scheduleID;
  final List<String> seatSymbols;
  int foodID;
  final String methodPayment;
  double totalPrice;

  BookingItem(
    this.userID,
    this.scheduleID,
    this.seatSymbols,
    this.foodID,
    this.methodPayment,
    this.totalPrice,
  );

  BookingItem.fromJson(Map<String, dynamic> json)
      : userID = json['userID'],
        scheduleID = json['scheduleID'],
        seatSymbols = (json['seatSymbols'] as List)
            .map((seat) => seat as String)
            .toList(),
        foodID = json['foodID'],
        methodPayment = json['methodPayment'],
        totalPrice = json['totalPrice'];

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'scheduleID': scheduleID,
      'seatSymbols': seatSymbols,
      'foodID': foodID,
      'methodPayment': methodPayment,
      'totalPrice': totalPrice,
    };
  }
}
