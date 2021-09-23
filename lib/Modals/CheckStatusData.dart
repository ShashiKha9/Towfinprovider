import 'Payment.dart';
import 'Provider.dart';
import 'ProviderService.dart';
import 'Rating.dart';
import 'ServiceType.dart';
import 'User.dart';

class CheckStatusData{
  int id;
  String booking_id;
  int userId;
  int providerId;
  int currentProviderId;
  int serviceTypeId;
  String status;
  String cancelledBy;
  String cancelReason;
  String payment_mode;
  int paid;
  String isTrack;
  double distance;
  String travelTime;
  String sAddress;
  double sLatitude;
  double sLongitude;
  String dAddress;
  double dLatitude;
  int trackDistance;
  double trackLatitude;
  double trackLongitude;
  double dLongitude;
  String assignedAt;
  String scheduleAt;
  String startedAt;
  String finishedAt;
  int userRated;
  int providerRated;
  int useWallet;
  int surge;
  String routeKey;
  String options;
  String deletedAt;
  String createdAt;
  String updatedAt;
  User user;
  Provider provider;
  ServiceType service_type;
  ProviderService provider_service;
  Rating rating;
  Payment payment;
  CheckStatusData(
      {this.id,
        this.booking_id,
        this.userId,
        this.providerId,
        this.currentProviderId,
        this.serviceTypeId,
        this.status,
        this.cancelledBy,
        this.cancelReason,
        this.payment_mode,
        this.paid,
        this.isTrack,
        this.distance,
        this.travelTime,
        this.sAddress,
        this.sLatitude,
        this.sLongitude,
        this.dAddress,
        this.dLatitude,
        this.trackDistance,
        this.trackLatitude,
        this.trackLongitude,
        this.dLongitude,
        this.assignedAt,
        this.scheduleAt,
        this.startedAt,
        this.finishedAt,
        this.userRated,
        this.providerRated,
        this.useWallet,
        this.surge,
        this.routeKey,
        this.options,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.provider,
        this.service_type,
        this.provider_service,
        this.rating,
        this.payment});

  CheckStatusData.fromJson(Map<String, dynamic> json) {


    id = json['id'];
    booking_id = json['booking_id'];
    userId = json['userId'];
    providerId = json['providerId'];
    currentProviderId = json['currentProviderId'];
    serviceTypeId = json['serviceTypeId'];
    status = json['status'];
    cancelledBy = json['cancelledBy'];
    cancelReason = json['cancelReason'];
    payment_mode = json['payment_mode'];
    paid = json['paid'];
    isTrack = json['isTrack'];
    distance = json['distance'].toDouble();
    travelTime = json['travelTime'];
    sAddress = json['sAddress'];
    sLatitude = json['sLatitude'];
    sLongitude = json['sLongitude'];
    dAddress = json['dAddress'];
    dLatitude = json['dLatitude'];
    trackDistance = json['trackDistance'];
    trackLatitude = json['trackLatitude'];
    trackLongitude = json['trackLongitude'];
    dLongitude = json['dLongitude'];
    assignedAt = json['assignedAt'];
    scheduleAt = json['scheduleAt'];
    startedAt = json['startedAt'];
    finishedAt = json['finishedAt'];
    userRated = json['userRated'];
    providerRated = json['providerRated'];
    useWallet = json['useWallet'];
    surge = json['surge'];
    routeKey = json['routeKey'];
    options = json['options'];
    deletedAt = json['deletedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = User.fromJson(json['user']);
    provider = json['provider']!=null?Provider.fromJson(json['provider']):null;
    service_type = ServiceType.fromJson(json['service_type']);
    provider_service = json['provider_service']!=null?ProviderService.fromJson(json['provider_service']):null;
    rating = json['rating']!=null?Rating.fromJson(json['rating']):null;
    payment = json['payment']!=null?Payment.fromJson(json['payment']):null;


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.booking_id;
    data['user_id'] = this.userId;
    data['provider_id'] = this.providerId;
    data['current_provider_id'] = this.currentProviderId;
    data['service_type_id'] = this.serviceTypeId;
    data['status'] = this.status;
    data['cancelled_by'] = this.cancelledBy;
    data['cancel_reason'] = this.cancelReason;
    data['payment_mode'] = this.payment_mode;
    data['paid'] = this.paid;
    data['is_track'] = this.isTrack;
    data['distance'] = this.distance;
    data['travel_time'] = this.travelTime;
    data['s_address'] = this.sAddress;
    data['s_latitude'] = this.sLatitude;
    data['s_longitude'] = this.sLongitude;
    data['d_address'] = this.dAddress;
    data['d_latitude'] = this.dLatitude;
    data['track_distance'] = this.trackDistance;
    data['track_latitude'] = this.trackLatitude;
    data['track_longitude'] = this.trackLongitude;
    data['d_longitude'] = this.dLongitude;
    data['assigned_at'] = this.assignedAt;
    data['schedule_at'] = this.scheduleAt;
    data['started_at'] = this.startedAt;
    data['finished_at'] = this.finishedAt;
    data['user_rated'] = this.userRated;
    data['provider_rated'] = this.providerRated;
    data['use_wallet'] = this.useWallet;
    data['surge'] = this.surge;
    data['route_key'] = this.routeKey;
    data['options'] = this.options;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if(this.service_type!=null){
      data['service_type'] = this.service_type.toJson();
    }
 if (this.provider != null) {
      data['provider'] = this.provider.toJson();
    }

    if (this.provider_service != null) {
      data['provider_service'] = this.provider_service.toJson();
    }
    if (this.rating != null) {
      data['rating'] = this.rating.toJson();
    }

    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    return data;
  }
}