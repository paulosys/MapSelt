import 'package:location/location.dart';

class LocalizacaoGPS {
  
  final Location _locationObjt = Location();
  late final bool _servicoAtivado;
  late final PermissionStatus _permissaoGarantida;
  late LocationData _localizacaoUsuario;

  dynamic get localizacaoUsuario async {
    _servicoAtivado = await _locationObjt.serviceEnabled();
    if (!_servicoAtivado) {
      _servicoAtivado = await _locationObjt.requestService();
      if (!_servicoAtivado) {
        return;
      }
    }

    _permissaoGarantida = await _locationObjt.hasPermission();
    if (_permissaoGarantida == PermissionStatus.denied) {
      _permissaoGarantida = await _locationObjt.requestPermission();
      if (_permissaoGarantida != PermissionStatus.granted) {
        return;
      }
    }

    _localizacaoUsuario = await _locationObjt.getLocation();

    return _localizacaoUsuario;
  }
  
}
