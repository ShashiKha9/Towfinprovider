class Payment{
  int id;
  int request_id;
  int promocode_id;
  int payment_id;
  String fixed;
  String distance;
  double commision;
  String discount;
  String tax;
  String wallet;
  String total;
  String payable;
  double provider_commission;
  double provider_pay;
  String payment_mode;
Payment(
{this.id,
this.request_id,
this.promocode_id,
this.payment_id,
this.fixed,
this.distance,
this.commision,
this.discount,
this.tax,
this.wallet,
this.total,
this.payable,
this.provider_commission,
this.provider_pay,
this.payment_mode,
});

Payment.fromJson(Map<String, dynamic> json) {
id = int.parse(json['id'].toString());
request_id = int.parse(json['request_id'].toString());
promocode_id = json['promocode_id']!=null?int.parse(json['promocode_id'].toString()):0;
payment_id = json['payment_id']!=null?int.parse(json['payment_id'].toString()):0;
payment_mode = json['payment_mode']!=null?json['payment_mode']:'';
fixed = json['fixed']!=null?(json['fixed']).toString():"0";
distance = json['distance'].toString();
commision = double.parse(json['commision'].toString());
discount = json['discount'].toString();
tax = json['tax'].toString();
wallet = json['wallet'].toString();
total = json['total']!=null?json['total'].toString():"0";
payable = json['payable'].toString();
provider_commission = double.parse(json['provider_commission'].toString());
provider_pay = double.parse(json['provider_pay'].toString());

}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['id'] = this.id;
data['request_id'] = this.request_id;
data['promocode_id'] = this.promocode_id;
data['payment_id'] = this.payment_id;
data['fixed'] = this.fixed;
data['distance'] = this.distance;
data['commision'] = this.commision;
data['discount'] = this.discount;
data['tax'] = this.tax;
data['wallet'] = this.wallet;
data['total'] = this.total;
data['payable'] = this.payable;
data['provider_commission'] = this.provider_commission;
data['provider_pay'] = this.provider_pay;
return data;
}
}
