
class UsuarioModel {
  int? idusuario;
  int idcategoria = 1;
  int? idendereco;
  String? nome;
  String? cpf;
  String? email;
  String? senha;
  String? fotoPerfil;
  bool? status = true;

  UsuarioModel({
    this.idusuario,
    this.idcategoria = 1,
    this.idendereco,
    this.nome,
    this.cpf,
    this.email,
    this.senha,
    this.fotoPerfil,
    this.status = true
  });

}