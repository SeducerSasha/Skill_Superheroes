class Biography {
  final String fullname;

  Biography(this.fullname);

  factory Biography.fromJson(final Map<String, dynamic> json) =>
      Biography(json['full-name']);

  Map<String, dynamic> toJson() => {'full-name': fullname};
}
