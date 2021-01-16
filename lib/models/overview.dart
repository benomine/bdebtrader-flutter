class OverView {
  final String assetType;
  final String name;
  final String description;
  final String exchange;
  final String currency;
  final String country;
  final String sector;
  final String industry;
  final String address;
  final double marketCapitalization;

  OverView(
      {this.assetType,
      this.name,
      this.description,
      this.exchange,
      this.currency,
      this.country,
      this.sector,
      this.industry,
      this.address,
      this.marketCapitalization});

  factory OverView.fromJson(Map<String, dynamic> json) {
    return OverView(
        assetType: json['AssetType'],
        name: json['Name'],
        description: json['Description'],
        exchange: json['Exchange'],
        currency: json['Currency'],
        country: json['Country'],
        sector: json['Sector'],
        industry: json['Industry'],
        address: json['Address'],
        marketCapitalization: double.parse(json['MarketCapitalization']));
  }
}
