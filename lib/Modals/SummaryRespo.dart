class SummaryRespo {
  int rides;
  double revenue;
  int cancelRides;
  int scheduledRides;

  SummaryRespo(
      {this.rides, this.revenue, this.cancelRides, this.scheduledRides});

  SummaryRespo.fromJson(Map<String, dynamic> json) {
    rides = json['rides'];
    revenue = json['revenue'];
    cancelRides = json['cancel_rides'];
    scheduledRides = json['scheduled_rides'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rides'] = this.rides;
    data['revenue'] = this.revenue;
    data['cancel_rides'] = this.cancelRides;
    data['scheduled_rides'] = this.scheduledRides;
    return data;
  }


}