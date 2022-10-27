class PricePreferParams {
  String idProviderSelected;
  String lineID;
  String idProvider;
  String point;
  String warranty;
  String deliveryTime;
  String paymentTerm;
  String quality;
  String price;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["IDProviderSeleted"] = idProviderSelected;
    params["LineID"] = lineID;
    params["IDProvider"] = idProvider;
    params["Point"] = point;
    params["Warranty"] = warranty;
    params["DeliveryTime"] = deliveryTime;
    params["PaymentTerm"] = paymentTerm;
    params["Quality"] = quality;
    params["Price"] = price;
    return params;
  }
}
