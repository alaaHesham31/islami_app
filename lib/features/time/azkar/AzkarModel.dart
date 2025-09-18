class AzkarModel {
  String? category;
  String? count;
  String? content;
  String? reference;
  String? description;

  AzkarModel({
    this.category,
    this.content,
    this.count,
    this.description,
    this.reference,
  });

  factory AzkarModel.fromJson(Map<String, dynamic> json) {
    return AzkarModel(
      category: json['category'],
      count: json['count'],
      content: json['content'],
      description: json['description'],
      reference: json['reference'],
    );
  }
}
