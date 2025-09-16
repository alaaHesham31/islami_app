import '../../domain/entities/hadeath.dart';

class HadeathModel extends Hadeath {
  const HadeathModel({
    required super.title,
    required super.content,
  });

  factory HadeathModel.fromFileContent(String fileContent) {
    final lines = fileContent.split('\n');
    final title = lines.first;
    lines.removeAt(0);
    return HadeathModel(title: title, content: lines);
  }
}
