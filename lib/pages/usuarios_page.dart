import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:secret_chat_mobile/models/usuario.dart';
import 'package:secret_chat_mobile/services/auth_service.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  Usuario usuario;

  RefreshController _refreshController = new RefreshController();

  final usuarios = [
    Usuario(id: '1', nombre: 'Maria', email: 'marial@test.com', online: true),
    Usuario(id: '2', nombre: 'Marcia', email: 'marial@test.com', online: true),
    Usuario(id: '3', nombre: 'Andres', email: 'marial@test.com', online: false),
    Usuario(id: '4', nombre: 'Pepe', email: 'marial@test.com', online: true),
  ];
  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    this.usuario = authService.usuario;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${usuario.username}',
          style: TextStyle(color: Colors.black54),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.redAccent,),
          onPressed: () {
            // TODO: Desconectarnos del socket server
            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.check_circle,
              color: Colors.blue[400],
            ),
            // child: Icon(
            //   Icons.offline_bolt,
            //   color: Colors.red,
            // ),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: this._refreshController,
        child: _buildUsersListView(),
        enablePullDown: true,
        onRefresh: this._cargarUsuarios,
      ),
    );
  }

  ListView _buildUsersListView() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _buildUserListTile(usuarios[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: this.usuarios.length,
    );
  }

  ListTile _buildUserListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.nombre),
      leading: CircleAvatar(
        child: Text(
          usuario.nombre.substring(0, 2),
        ),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  _cargarUsuarios() async {
    await Future.delayed(
      Duration(milliseconds: 1000),
    );
    this.usuarios.add(
          Usuario(
              id: '4', nombre: 'Pepe', email: 'marial@test.com', online: true),
        );
    setState(() {});
    _refreshController.refreshCompleted();
  }
}
