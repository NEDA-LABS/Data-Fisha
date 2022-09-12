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
    required this.applicationId,
    required this.businessName,
    required this.category,
    required this.country,
    required this.ecommerce,
    required this.masterKey,
    required this.projectId,
    required this.region,
    required this.settings,
    required this.street,
  });

  ShopModel.fromMap(Map<String, dynamic> map)
      : street = map['street'],
        businessName = map['businessName'],
        applicationId = map['applicationId'],
        projectId = map['projectId'],
        masterKey = map['masterKey'],
        category = map['category'],
        settings = ShopSettingsModel.fromMap(map['settings']),
        ecommerce = ShopEcommerceModel.fromMap(map['ecommerce']),
        country = map['country'],
        region = map['region'];
}

class ShopSettingsModel {
  final bool? saleWithoutPrinter;
  final String? printerFooter;
  final String? printerHeader;
  final String? currency;

  ShopSettingsModel({
    required this.currency,
    required this.printerFooter,
    required this.printerHeader,
    required this.saleWithoutPrinter,
  });

  ShopSettingsModel.fromMap(Map<String, dynamic> map)
      : saleWithoutPrinter = map['saleWithoutPrinter'],
        printerHeader = map['printerHeader'],
        currency = map['currency'],
        printerFooter = map['printerFooter'];
}

class ShopEcommerceModel {
  final String? logo;
  final String? cover;
  final String? about;
  final Social social;

  ShopEcommerceModel(
      {required this.about,
      required this.cover,
      required this.logo,
      required this.social});

  ShopEcommerceModel.fromMap(Map<String, dynamic> map)
      : logo = map['logo'],
        about = map['about'],
        cover = map['cover'],
        social = Social.fromMap(map['social'] as Map<String, dynamic>);
}

class Social {
  final String? instagram;
  final String? facebook;
  final String? twitter;
  final String? whatsapp;

  Social(
      {required this.facebook,
      required this.instagram,
      required this.twitter,
      required this.whatsapp});

  Social.fromMap(Map<String, dynamic> map)
      : facebook = map['facebook'],
        instagram = map['instagram'],
        whatsapp = map['whatsapp'],
        twitter = map['twitter'];
}
