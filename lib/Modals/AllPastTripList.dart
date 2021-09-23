import 'Payment.dart';

class AllPastTripList{
  int id;
  String booking_id;
  int user_id;
  int provider_id;
  int current_provider_id;
  int service_type_id;
  String status;
  String cancelled_by;
  String cancel_reason;
  String payment_mode;
  int paid;
  String is_track;
  double distance;
  String travel_time;
  String s_address;
  double s_latitude;
  double s_longitude;
  String d_address;
  double d_latitude;
  int track_distance;
  double track_latitude;
  double track_longitude;
  double d_longitude;
  String assigned_at;
  String static_map;
  Payment payment;

  AllPastTripList(
      {
        this.id,
        this.booking_id,
        this.user_id,
        this.provider_id,
        this.current_provider_id,
        this.service_type_id,
        this.status,
        this.cancelled_by,
        this.cancel_reason,
        this.payment_mode,
        this.paid,
        this.is_track,
        this.distance,
        this.travel_time,
        this.s_address,
        this.s_latitude,
        this.s_longitude,
        this.d_address,
        this.d_latitude,
        this.track_distance,
        this.track_latitude,
        this.track_longitude,
        this.d_longitude,
        this.assigned_at,
        this.static_map,
        this.payment,

      });

  AllPastTripList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    booking_id = json['booking_id'];
    user_id = json['user_id'];
    provider_id = json['provider_id'];
    current_provider_id = json['current_provider_id'];
    service_type_id = json['service_type_id'];
    status = json['status'];
    cancelled_by = json['cancelled_by'];
    cancel_reason = json['cancel_reason'];
    payment_mode = json['payment_mode'];
    paid = json['paid'];
    is_track = json['is_track'];
    distance = double.parse(json['distance'].toString());
    travel_time = json['travel_time'];
    s_address = json['s_address'];
    s_latitude = json['s_latitude'];
    s_longitude = json['s_longitude'];
    d_address = json['d_address'];
    d_latitude = json['d_latitude'];
    track_distance = json['track_distance'];
    track_latitude = json['track_latitude'];
    track_longitude = json['track_longitude'];
    d_longitude = json['d_longitude'];
    assigned_at = json['assigned_at'];
    static_map = json['static_map'];
    payment = json['payment']!=null?Payment.fromJson(json['payment']):null;


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.booking_id;
    data['user_id'] = this.user_id;
    data['provider_id'] = this.provider_id;
    data['current_provider_id'] = this.current_provider_id;
    data['service_type_id'] = this.service_type_id;
    data['status'] = this.status;
    data['cancelled_by'] = this.cancelled_by;
    data['cancel_reason'] = this.cancel_reason;
    data['payment_mode'] = this.payment_mode;
    data['paid'] = this.paid;
    data['is_track'] = this.is_track;
    data['distance'] = this.distance;
    data['travel_time'] = this.travel_time;
    data['s_address'] = this.s_address;
    data['s_latitude'] = this.s_latitude;
    data['s_longitude'] = this.s_longitude;
    data['d_address'] = this.d_address;
    data['d_latitude'] = this.d_latitude;
    data['track_distance'] = this.track_distance;
    data['track_latitude'] = this.track_latitude;
    data['track_longitude'] = this.track_longitude;
    data['d_longitude'] = this.d_longitude;
    data['assigned_at'] = this.assigned_at;
    data['static_map'] = this.static_map;
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    return data;
  }
}