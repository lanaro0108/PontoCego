import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/data/models.dart';

class PhotoService {
  final ImagePicker _picker = ImagePicker();
  Future<String?> choose(ImageSource source) async {
    try {
      final photo = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 70,
      );
      return photo == null ? null : await _read(photo);
    } on PlatformException {
      throw const AppFailure(
        'Não foi possível acessar a foto. Confira as permissões ou escolha uma imagem da galeria.',
      );
    } catch (e) {
      if (e is AppFailure) rethrow;
      throw const AppFailure(
        'Não foi possível abrir a foto. Tente outra imagem.',
      );
    }
  }

  Future<String?> recover() async {
    try {
      final result = await _picker.retrieveLostData();
      return result.files?.isNotEmpty == true
          ? await _read(result.files!.first)
          : null;
    } catch (_) {
      return null;
    }
  }

  Future<String> _read(XFile photo) async {
    final bytes = await photo.readAsBytes();
    if (bytes.length > 1024 * 1024) {
      throw const AppFailure('Escolha uma imagem de até 1 MB.');
    }
    if (bytes.isEmpty) {
      throw const AppFailure('Essa imagem está vazia. Escolha outra foto.');
    }
    return base64Encode(bytes);
  }
}
