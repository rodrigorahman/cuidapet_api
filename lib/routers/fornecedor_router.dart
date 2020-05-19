import 'package:cuidapet_api/config/jwt_authentication_middleware.dart';
import 'package:cuidapet_api/controllers/fornecedores/fornecedor_controller.dart';
import 'package:cuidapet_api/core/i_routers_config.dart';
import '../cuidapet_api.dart';

class FornecedorRouters implements IRoutersConfig {
  @override
  void configure(Router router) {
    router.route("/fornecedores")
      .link(() => JwtAuthenticationMiddleware())
      .link(() => FornecedorController());
    
    router.route("/fornecedores/:id")
      .link(() => JwtAuthenticationMiddleware())
      .link(() => FornecedorController());

    router.route("/fornecedores/servicos/:fornecedorId")
      .link(() => JwtAuthenticationMiddleware())
      .link(() => FornecedorController());
    
  }
}
