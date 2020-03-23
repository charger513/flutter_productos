import 'package:flutter/material.dart';
import 'package:flutter_productos/src/bloc/provider.dart';
import 'package:flutter_productos/src/models/producto_model.dart';
import 'package:flutter_productos/src/providers/productos_provider.dart';

class HomePage extends StatelessWidget {
  // final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {

    // final bloc = Provider.of(context);
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home page')
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {

    return StreamBuilder(
      stream: productosBloc.productoStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
        if(snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (BuildContext context, int i) => _crearItem(context, productosBloc, productos[i])
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc, ProductoModel producto) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red
      ),
      onDismissed: (direction) => productosBloc.borrarProducto(producto.id),
      child: Card(
        child: Column(
          children: <Widget>[
            producto.fotoUrl == null
              ? Image(image: AssetImage('assets/img/no-image.png') )
              : FadeInImage(
                placeholder: AssetImage('assets/img/jar-loading.gif'),
                image: NetworkImage(producto.fotoUrl),
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text(producto.id),
                onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
              ),
          ],
        )
      )
      // ListTile(
      //   title: Text('${producto.titulo} - ${producto.valor}'),
      //   subtitle: Text(producto.id),
      //   onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
      // ),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto')
    );
  }
}