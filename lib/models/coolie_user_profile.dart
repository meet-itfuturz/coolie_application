class CoolieUserProfile {
  final String id;
  final String name;
  final String mobileNo;
  final String emailId;
  final String gender;
  final String age;
  final String buckleNumber;
  final String address;
  final bool isApproved;
  final bool isActive;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  final ImageData? image;
  final RateCard? rateCard;

  CoolieUserProfile({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.emailId,
    required this.gender,
    required this.age,
    required this.buckleNumber,
    required this.address,
    required this.isApproved,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.image,
    this.rateCard,
  });

  factory CoolieUserProfile.fromJson(Map<String, dynamic> json) {
    return CoolieUserProfile(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      emailId: json['emailId'] ?? '',
      gender: json['gender'] ?? '',
      age: json['age'] ?? '',
      buckleNumber: json['buckleNumber'] ?? '',
      address: json['address'] ?? '',
      isApproved: json['isApproved'] ?? false,
      isActive: json['isActive'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      image: json['image'] != null ? ImageData.fromJson(json['image']) : null,
      rateCard: json['rateCard'] != null ? RateCard.fromJson(json['rateCard']) : null,
    );
  }
}

class ImageData {
  final String url;
  final String s3Key;

  ImageData({required this.url, required this.s3Key});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      url: json['url'] ?? '',
      s3Key: json['s3Key'] ?? '',
    );
  }
}

class RateCard {
  final String baseRate;
  final String baseTime;
  final String waitingRate;

  RateCard({
    required this.baseRate,
    required this.baseTime,
    required this.waitingRate,
  });

  factory RateCard.fromJson(Map<String, dynamic> json) {
    return RateCard(
      baseRate: json['baseRate'] ?? '',
      baseTime: json['baseTime'] ?? '',
      waitingRate: json['waitingRate'] ?? '',
    );
  }
}
