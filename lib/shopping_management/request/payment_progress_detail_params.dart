class AddNewProviderParams {
  int idProvider;
  String code;
  String name;
  int region;
  String address;
  String personContact;
  String phoneContact;
  String taxCode;
  String iDCategorys;
  int iDNation;
  String abbreviation;
  String email;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["Code"] = code;
    params["Name"] = name;
    params["Region"] = region;
    params["Address"] = address;
    params["PersonContact"] = personContact;
    params["PhoneContact"] = phoneContact;
    params["TaxCode"] = taxCode;
    params["IDCategorys"] = iDCategorys;
    params["IDNation"] = iDNation;
    params["Abbreviation"] = abbreviation;
    params["Email"] = email;
    if (idProvider != null) params["ID"] = idProvider;
    return params;
  }
}
