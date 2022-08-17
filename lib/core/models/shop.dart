import 'package:flutter/material.dart';

class ShopModel {
  final String businessName;
  final String applicationId;
  final String projectId;
  final String masterKey;
  final String category;
  final ShopSettingsModel settings;
  final ShopEcommerceModel ecommerce;
  final String country;
  final String region;
  final String street;

  ShopModel({
    @required this.applicationId,
    @required this.businessName,
    @required this.category,
    @required this.country,
    @required this.ecommerce,
    @required this.masterKey,
    @required this.projectId,
    @required this.region,
    @required this.settings,
    @required this.street,
  });

  ShopModel.fromMap(Map<String, dynamic> map)
      : this.street = map['street'],
        this.businessName = map['businessName'],
        this.applicationId = map['applicationId'],
        this.projectId = map['projectId'],
        this.masterKey = map['masterKey'],
        this.category = map['category'],
        this.settings = ShopSettingsModel.fromMap(map['settings']),
        this.ecommerce = ShopEcommerceModel.fromMap(map['ecommerce']),
        this.country = map['country'],
        this.region = map['region'];
}

class ShopSettingsModel {
  final bool saleWithoutPrinter;
  final String printerFooter;
  final String printerHeader;
  final String currency;

  ShopSettingsModel({
    @required this.currency,
    @required this.printerFooter,
    @required this.printerHeader,
    @required this.saleWithoutPrinter,
  });

  ShopSettingsModel.fromMap(Map<String, dynamic> map)
      : saleWithoutPrinter = map['saleWithoutPrinter'],
        printerHeader = map['printerHeader'],
        currency = map['currency'],
        printerFooter = map['printerFooter'];
}

class ShopEcommerceModel {
  final String logo;
  final String cover;
  final String about;
  final Social social;

  ShopEcommerceModel(
      {@required this.about,
      @required this.cover,
      @required this.logo,
      @required this.social});

  ShopEcommerceModel.fromMap(Map<String, dynamic> map)
      : this.logo = map['logo'],
        this.about = map['about'],
        this.cover = map['cover'],
        this.social = Social.fromMap(map['social'] as Map<String, dynamic>);
}

class Social {
  final String instagram;
  final String facebook;
  final String twitter;
  final String whatsapp;

  Social(
      {@required this.facebook,
      @required this.instagram,
      @required this.twitter,
      @required this.whatsapp});

  Social.fromMap(Map<String, dynamic> map)
      : this.facebook = map['facebook'],
        this.instagram = map['instagram'],
        this.whatsapp = map['whatsapp'],
        this.twitter = map['twitter'];
}
