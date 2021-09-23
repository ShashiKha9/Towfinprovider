import 'package:cbx_driver/Modals/Payment.dart';

class CheckStatusModel {
  String accountStatus;
  String serviceStatus;
  List<Requests> requests;

  CheckStatusModel({this.accountStatus, this.serviceStatus, this.requests});

  CheckStatusModel.fromJson(Map<String, dynamic> json) {
    accountStatus = json['account_status']!=null?json['account_status']:'';
    serviceStatus = json['service_status']!=null?json['service_status']:'';
    if (json['requests'] != null) {
      requests = new List<Requests>();
      json['requests'].forEach((v) {
        requests.add(new Requests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_status'] = this.accountStatus;
    data['service_status'] = this.serviceStatus;
    if (this.requests != null) {
      data['requests'] = this.requests.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Requests {
  int id;
  String requestId;
  String providerId;
  String status;
  int timeLeftToRespond;
  Request request;

  Requests(
      {this.id,
        this.requestId,
        this.providerId,
        this.status,
        this.timeLeftToRespond,
        this.request});

  Requests.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    requestId = json['request_id'].toString();
    providerId = json['provider_id']!=null?json['provider_id'].toString():'';
    status = json['status']!=null?json['status'].toString():'';
    timeLeftToRespond = int.parse(json['time_left_to_respond'].toString());
    request =
    json['request'] != null ? new Request.fromJson(json['request']) : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['request_id'] = this.requestId;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    data['time_left_to_respond'] = this.timeLeftToRespond;
    if (this.request != null) {
      data['request'] = this.request.toJson();
    }
    return data;
  }
}

class Request {
  int id;
  String bookingId;
  String userId;
  String providerId;
  String currentProviderId;
  String serviceTypeId;
  String status;
  String request_id;
  String cancelledBy;
  String cancelReason;
  String paymentMode;
  String paid;
  String isTrack;
  String distance;
  String travelTime;
  String sAddress;
  String sLatitude;
  String sLongitude;
  String dAddress;
  String dLatitude;
  String trackDistance;
  String trackLatitude;
  String trackLongitude;
  String dLongitude;
  String assignedAt;
  String scheduleAt;
  String startedAt;
  String finishedAt;
  String userRated;
  String providerRated;
  String useWallet;
  String surge;
  String routeKey;
  String options;

  String deletedAt;
  String createdAt;
  String updatedAt;
  User user;
  Payment payment;

  Request(
      {this.id,
        this.bookingId,
        this.userId,
        this.providerId,
        this.currentProviderId,
        this.serviceTypeId,
        this.status,
        this.request_id,
        this.cancelledBy,
        this.cancelReason,
        this.paymentMode,
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
        this.payment});

  Request.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    bookingId = json['booking_id'];
    userId = json['user_id'].toString();
    providerId = json['provider_id'].toString();
    currentProviderId = json['current_provider_id'].toString();
    serviceTypeId = json['service_type_id'].toString();
    status = json['status'];
    request_id = json['request_id'];
    cancelledBy = json['cancelled_by'];
    cancelReason = json['cancel_reason']!=null?json['cancel_reason']:'';
    paymentMode = json['payment_mode'];
    paid = json['paid'].toString();
    isTrack = json['is_track'];
    distance = json['distance'].toString();
    travelTime = json['travel_time']!=null?json['travel_time']:'';
    sAddress = json['s_address'];
    sLatitude = json['s_latitude'].toString();
    sLongitude = json['s_longitude'].toString();
    dAddress = json['d_address'];
    dLatitude = json['d_latitude'].toString();
    trackDistance = json['track_distance'].toString();
    trackLatitude = json['track_latitude'].toString();
    trackLongitude = json['track_longitude'].toString();
    dLongitude = json['d_longitude'].toString();
    assignedAt = json['assigned_at'].toString();
    scheduleAt = json['schedule_at']!=null?json['schedule_at']:'';
    startedAt = json['started_at'];
    finishedAt = json['finished_at']!=null?json['finished_at']:'';
    userRated = json['user_rated'].toString();
    providerRated = json['provider_rated'].toString();
    useWallet = json['use_wallet'].toString();
    surge = json['surge'].toString();
    routeKey = json['route_key'].toString();
    options = json['options']!=null?json['options']:'';
    deletedAt = json['deleted_at']!=null?json['deleted_at']:'';
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    payment = json['payment']!=null? new Payment.fromJson(json['payment']):null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['user_id'] = this.userId;
    data['provider_id'] = this.providerId;
    data['current_provider_id'] = this.currentProviderId;
    data['service_type_id'] = this.serviceTypeId;
    data['status'] = this.status;
    data['request_id'] = this.request_id;
    data['cancelled_by'] = this.cancelledBy;
    data['cancel_reason'] = this.cancelReason;
    data['payment_mode'] = this.paymentMode;
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
    data['payment'] = this.payment;
    return data;
  }
}

class User {
  int id;
  String firstName;
  String lastName;
  String paymentMode;
  String email;
  String gender;
  String mobile;
  String picture;
  String deviceToken;
  String deviceId;
  String deviceType;
  String loginBy;
  String socialUniqueId;
  String latitude;
  String longitude;
  String stripeCustId;
  String walletBalance;
  String rating;
  String otp;
  String updatedAt;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.paymentMode,
        this.email,
        this.gender,
        this.mobile,
        this.picture,
        this.deviceToken,
        this.deviceId,
        this.deviceType,
        this.loginBy,
        this.socialUniqueId,
        this.latitude,
        this.longitude,
        this.stripeCustId,
        this.walletBalance,
        this.rating,
        this.otp,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    firstName = json['first_name'];
    lastName = json['last_name'];
    paymentMode = json['payment_mode'];
    email = json['email'];
    gender = json['gender'];
    mobile = json['mobile'];
    picture = json['picture'];
    deviceToken = json['device_token'];
    deviceId = json['device_id'];
    deviceType = json['device_type'];
    loginBy = json['login_by'];
    socialUniqueId = json['social_unique_id'];
    latitude = json['latitude']!=null?json['latitude'].toString():"";
    longitude = json['longitude'].toString();
    stripeCustId = json['stripe_cust_id'].toString();
    walletBalance = json['wallet_balance'].toString();
    rating = json['rating'].toString();
    otp = json['otp'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['payment_mode'] = this.paymentMode;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['mobile'] = this.mobile;
    data['picture'] = this.picture;
    data['device_token'] = this.deviceToken;
    data['device_id'] = this.deviceId;
    data['device_type'] = this.deviceType;
    data['login_by'] = this.loginBy;
    data['social_unique_id'] = this.socialUniqueId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['stripe_cust_id'] = this.stripeCustId;
    data['wallet_balance'] = this.walletBalance;
    data['rating'] = this.rating;
    data['otp'] = this.otp;
    data['updated_at'] = this.updatedAt;
    return data;
  }





}
class OptionsData {
  List<CarDataContentList> carDataContentList;
  String color;
  String locationType;
  String make;
  String modal;
  String modalYear;
  String serviceTypeId;
  String subServiceName;
  int subServiceId;
  String vechileNo;
  String vinNumber;

  OptionsData(
      {this.carDataContentList,
        this.color,
        this.locationType,
        this.make,
        this.modal,
        this.modalYear,
        this.serviceTypeId,
        this.subServiceName,
        this.subServiceId,
        this.vechileNo,
        this.vinNumber});

  OptionsData.fromJson(Map<String, dynamic> json) {
    if (json['carDataContentList'] != null) {
      carDataContentList = new List<CarDataContentList>();
      json['carDataContentList'].forEach((v) {
        carDataContentList.add(new CarDataContentList.fromJson(v));
      });
    }
    color = json['color'];
    locationType = json['location_type'];
    make = json['make'];
    modal = json['modal'];
    modalYear = json['modal_year'];
    serviceTypeId = json['service_type_id'];
    subServiceName = json['subServiceName'];
    subServiceId = int.parse(json['subService_id'].toString());
    vechileNo = json['vechile_no'];
    vinNumber = json['vin_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.carDataContentList != null) {
      data['carDataContentList'] =
          this.carDataContentList.map((v) => v.toJson()).toList();
    }
    data['color'] = this.color;
    data['location_type'] = this.locationType;
    data['make'] = this.make;
    data['modal'] = this.modal;
    data['modal_year'] = this.modalYear;
    data['service_type_id'] = this.serviceTypeId;
    data['subServiceName'] = this.subServiceName;
    data['subService_id'] = this.subServiceId;
    data['vechile_no'] = this.vechileNo;
    data['vin_number'] = this.vinNumber;
    return data;
  }
}

class CarDataContentList {
  String spairParts;
  bool tyreFourSelected;
  bool tyreOneSelected;
  bool tyreThreeSelected;
  bool tyreTwoSelected;

  CarDataContentList(
      {this.spairParts,
        this.tyreFourSelected,
        this.tyreOneSelected,
        this.tyreThreeSelected,
        this.tyreTwoSelected});

  CarDataContentList.fromJson(Map<String, dynamic> json) {
    spairParts = json['spair_parts'];
    tyreFourSelected = json['tyre_four_selected'];
    tyreOneSelected = json['tyre_one_selected'];
    tyreThreeSelected = json['tyre_three_selected'];
    tyreTwoSelected = json['tyre_two_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['spair_parts'] = this.spairParts;
    data['tyre_four_selected'] = this.tyreFourSelected;
    data['tyre_one_selected'] = this.tyreOneSelected;
    data['tyre_three_selected'] = this.tyreThreeSelected;
    data['tyre_two_selected'] = this.tyreTwoSelected;
    return data;
  }
}