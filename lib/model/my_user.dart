class MyUser {
  String? odataContext;
  List<dynamic>? businessPhones;
  String? displayName;
  String? givenName;
  String? jobTitle;
  // 製作 setter
  String? mail;
  String? mobilePhone;
  String? officeLocation;
  String? preferredLanguage;
  String? surname;
  String? userPrincipalName;
  String? id;

  MyUser({
    this.odataContext,
    this.businessPhones,
    this.displayName,
    this.givenName,
    this.jobTitle,
    this.mail,
    this.mobilePhone,
    this.officeLocation,
    this.preferredLanguage,
    this.surname,
    this.userPrincipalName,
    this.id,
  });

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      odataContext: json['@odata.context'],
      businessPhones: json['businessPhones'],
      displayName: json['displayName'],
      givenName: json['givenName'],
      jobTitle: json['jobTitle'],
      mail: json['mail'],
      mobilePhone: json['mobilePhone'],
      officeLocation: json['officeLocation'],
      preferredLanguage: json['preferredLanguage'],
      surname: json['surname'],
      userPrincipalName: json['userPrincipalName'],
      id: json['id'],
    );
  }
}
