class ApproximatePriceRespo {
 double estimatedFare;
 int distance;
 String time;
 int surge;
 String surgeValue;
 double taxPrice;
 int basePrice;
 int walletBalance;
 ApproximatePriceRespo( {this.estimatedFare,
  this.distance,
  this.time,
  this.surge,
  this.surgeValue,
  this.taxPrice,
  this.basePrice,
  this.walletBalance});

 ApproximatePriceRespo.fromJson(Map<String, dynamic> json)
     : estimatedFare = json['estimated_fare'],
 distance = json['distance'],
 time = json['time'],
 surge = json['surge'],
 surgeValue = json['surge_value'],
 taxPrice = json['tax_price'],
 basePrice = json['base_price'],
 walletBalance = json['wallet_balance'];

 ApproximatePriceRespo.withError(String errorValue)
     : estimatedFare = 0,
      distance = 0,
      time = errorValue,
      surge = 0,
      surgeValue = errorValue,
      taxPrice = 0,
      basePrice = 0,
      walletBalance = 0;
}