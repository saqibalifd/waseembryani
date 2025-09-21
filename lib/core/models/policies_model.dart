class PoliciesModel {
  final String termsConditions;
  final String privacyPolicy;
  final String helpCenter;
  final String aboutUs;

  PoliciesModel({
    required this.termsConditions,
    required this.privacyPolicy,
    required this.helpCenter,
    required this.aboutUs,
  });

  factory PoliciesModel.fromJson(Map<String, dynamic> json) {
    return PoliciesModel(
      termsConditions: json['terms_conditions'] ?? '',
      privacyPolicy: json['privacy_policy'] ?? '',
      helpCenter: json['help_center'] ?? '',
      aboutUs: json['about_us'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'terms_conditions': termsConditions,
    'privacy_policy': privacyPolicy,
    'help_center': helpCenter,
    'about_us': aboutUs,
  };
}
