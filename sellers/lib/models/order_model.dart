import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sellers/models/product_model.dart';

class OrderModel {
  String? payment;
  String status;
  List<ProductModel> products;
  double? totalprice;
  String orderId;
  String? userId;
  String? address;
  double? latitude;
  double? longitude;
  DateTime? orderDate;
  String? deliveryId;
  String? deliveryName;
  String? deliveryPhone;

  OrderModel({
    this.totalprice,
    required this.orderId,
    this.payment,
    required this.products,
    required this.status,
    this.userId,
    this.address,
    this.latitude,
    this.longitude,
    this.orderDate,
    this.deliveryId,
    this.deliveryName,
    this.deliveryPhone,
  });
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? productMap = json['products'];
    return OrderModel(
      orderId: json['orderId'] ?? "",
      products:
          (productMap ?? []).map((e) => ProductModel.fromJson(e)).toList(),
      totalprice: (json['totalprice'] is String)
          ? double.tryParse(json['totalprice'] ?? "") ?? 0.0
          : (json['totalprice'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? "",
      payment: json['payment'] ?? "",
      userId: json['userId'] ?? "",
      address: json['address'] ?? "",
      latitude: (json['latitude'] is String)
          ? double.tryParse(json['latitude'] ?? "") ?? 0.0
          : (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] is String)
          ? double.tryParse(json['longitude'] ?? "") ?? 0.0
          : (json['longitude'] as num?)?.toDouble() ?? 0.0,
      orderDate: json['orderDate'] != null
          ? (json['orderDate'] as Timestamp).toDate()
          : DateTime.now(),
      deliveryId: json['deliveryId'] ?? "",
      deliveryName: json['deliveryName'] ?? "",
      deliveryPhone: json['deliveryPhone'] ?? "",
    );
  }
}
