class ProviderService{
int id;
int provider_id;
int service_type_id;
String status;
String service_number;
String service_model;

ProviderService(
{this.id,
this.provider_id,
this.service_type_id,
this.status,
this.service_number,
this.service_model
});

ProviderService.fromJson(Map<String, dynamic> json) {
id = json['id'];
provider_id = json['provider_id'];
service_type_id = json['service_type_id'];
status = json['status'];
service_number = json['service_number'];
service_model = json['service_model'];

}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['id'] = this.id;
data['provider_id'] = this.provider_id;
data['service_type_id'] = this.service_type_id;
data['status'] = this.status;
data['service_number'] = this.service_number;
data['service_model'] = this.service_model;
return data;
}
}
