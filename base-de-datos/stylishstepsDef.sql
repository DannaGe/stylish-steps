

--usar la Base de Datos stylishstepts

drop database stylishsteps;
create database stylishsteps;
use stylishsteps;

--Clientes aqui
create table clientes(
---------------------LLAVES--------------------------
	id_cliente integer identity(1,1) primary key,
-----------------------------------------------------
	nombre varchar(30) not null,
	apellidos varchar(50) not null,
	correo_electronico varchar(80) not null,
	telefono varchar(10) not null,
	pais varchar(30),
	fecha_registro date not null
);


--Comentarios
create table comentarios(
---------------------LLAVES--------------------------
	id_comentario integer identity(1,1) primary key,
	id_cliente integer not null foreign key(id_cliente) references clientes(id_cliente),
-----------------------------------------------------
	texto_comentario varchar(100) not null,
	fecha_comentario date not null
);



--Empleados
create table empleados(
---------------------LLAVES--------------------------
	id_empleado integer identity(1,1) primary key,
-----------------------------------------------------
	nombre varchar(30) not null,
	apellidos varchar(50) not null,
	telefono integer not null,
);

--Categorias
create table categorias(
---------------------LLAVES--------------------------
	id_categoria integer identity(1,1) primary key,
-----------------------------------------------------
	nombre_categoria varchar(30) not null,
	descripcion varchar(50) not null,
	--stock_categoria integer not null
);

--Productos aqui
create table productos( 
---------------------LLAVES--------------------------
	id_producto integer identity(1,1) primary key,
	id_categoria integer not null foreign key(id_categoria) references categorias(id_categoria),
-----------------------------------------------------
	nombre_producto varchar(50) not null,
	precio integer not null,
	stock_disponible integer not null,
	img_producto varbinary(max) not null,
	cantidad integer not null,
	descontinuados integer not null,
	reordenar_productos integer not null
);

--Favoritos
create table favoritos(
---------------------LLAVES--------------------------
	id_favorito integer identity(1,1) primary key,
	id_cliente integer not null foreign key(id_cliente) references clientes(id_cliente),
	id_producto integer not null foreign key(id_producto) references productos(id_producto),
-----------------------------------------------------
);
--Direcciones
create table direcciones(
---------------------LLAVES--------------------------
	id_direccion integer identity(1,1) primary key,
-----------------------------------------------------
	colonia varchar(50) not null,
	calle varchar(50) not null,
	cp integer not null,
	no_interior integer not null,
	no_exterior integer not null,
	descripcion varchar(100) not null,
	paqueteria varchar(50) ,
);

--Proveedores
create table proveedores(
---------------------LLAVES--------------------------
	id_proveedor integer identity(1,1) primary key,
-----------------------------------------------------
	nombre varchar(30) not null,
	apellidos varchar(50) not null,
	correo_electronico varchar(80) not null,
	telefono varchar(10) not null,
	nombre_compania varchar(50) not null,
);

--Carrito
create table carrito(
---------------------LLAVES--------------------------
	id_carrito integer identity(1,1) primary key,
	id_cliente integer not null foreign key(id_cliente) references clientes(id_cliente),
	id_producto integer not null foreign key(id_producto) references productos(id_producto),
-----------------------------------------------------
	nombre_producto varchar(50) not null,
	precio integer not null,
	--stock_disponible integer not null,
	img_producto varbinary(max) not null,
);



--Pedidos
create table pedidos( 
---------------------LLAVES--------------------------
	id_pedido integer identity(1,1) primary key,
	id_cliente integer not null foreign key(id_cliente) references clientes(id_cliente),
	id_direccion integer not null foreign key(id_direccion) references direcciones(id_direccion),
-----------------------------------------------------
	--descuento integer,
	cantidad integer not null,
	fecha_pedido date not null,
	estado_pedido varchar(20),
	total integer not null,
	--direccion_envio varchar(50)
);



--Detalles_Productos
create table detalles_productos(
---------------------LLAVES--------------------------
	id_detalle_producto integer identity(1,1) primary key,
	id_producto integer not null foreign key(id_producto) references productos(id_producto),
-----------------------------------------------------
	descripcion varchar(50) not null,
	talla integer not null,
	color varchar(20) not null,
	img_producto varbinary(max) not null
);


--Pagos_Pedidos
create table pagos_pedidos(
---------------------LLAVES--------------------------
	id_pago integer identity(1,1) primary key,
	id_pedido integer not null foreign key(id_pedido) references pedidos(id_pedido),
-----------------------------------------------------
	fecha_pago date not null,
	monto_pago integer not null,
	metodo_pago varchar(30) not null
);

--Devoluciones
create table devoluciones(
---------------------LLAVES--------------------------
	id_devolucion integer identity(1,1) primary key,
	id_pedido integer not null foreign key(id_pedido) references pedidos(id_pedido),
-----------------------------------------------------
	fecha_devolucion date not null,
	razon_devolucion varchar(100) not null,
	estado_devolucion varchar(30) not null
);

--Empleados_Pedidos
create table empleados_pedidos(
---------------------LLAVES--------------------------
	id_empleados_pedidos integer identity(1,1) primary key,
	id_empleado integer not null foreign key(id_empleado) references empleados(id_empleado),
	id_pedido integer not null foreign key(id_pedido) references pedidos(id_pedido),
-----------------------------------------------------
	fecha_asignacion date not null,
	rol_pedido varchar(100) not null,
);

--Detalles_Pedidos
create table detalles_pedidos(
---------------------LLAVES--------------------------
	id_detalle_pedido integer identity(1,1) primary key,
	id_pedido integer not null foreign key(id_pedido) references pedidos(id_pedido),
	id_direccion integer not null foreign key(id_direccion) references direcciones(id_direccion),
-----------------------------------------------------
	cantidad integer not null,
	precio_unitario integer not null,
	descuento integer
);

--Materiales
create table materiales(
---------------------LLAVES--------------------------
	id_material integer identity(1,1) primary key,
	id_proveedor integer not null foreign key(id_proveedor) references proveedores(id_proveedor),
-----------------------------------------------------
	nombre_material varchar(40) not null,
	cantidad_disponible integer not null,
);

--Productos_Materiales
create table productos_materiales(
---------------------LLAVES--------------------------
	id_producto_materiales integer identity(1,1) primary key,
	id_producto integer not null foreign key(id_producto) references productos(id_producto),
	id_material integer not null foreign key(id_material) references materiales(id_material),
-----------------------------------------------------
	cantidad_usada integer not null,
	costo_material integer not null,
	unidad_medida varchar(50),
);



-----------------------------------------------------------------------------------------------------
---------------------------------------RESTRICCIONES-------------------------------------------------
-----------------------------------------------------------------------------------------------------

exec sp_helpconstraint clientes;

-- Restricciones para la tabla Clientes
alter table clientes add 
	constraint uq_clientes_correo_electronico unique(correo_electronico),
    constraint chk_clientes_telefono CHECK (telefono like '[0-9]%'),
	constraint df_clientes_fecha_registro DEFAULT SYSDATETIME() for fecha_registro;

-- Restricciones para la tabla Comentarios
alter table comentarios add
    constraint fk_comentarios_id_cliente foreign key(id_cliente) references clientes(id_cliente),
	constraint df_comentarios_fecha_comentario DEFAULT SYSDATETIME() for fecha_comentario;

-- Restricciones para la tabla Empleados
alter table empleados add
    constraint chk_empleados_telefono CHECK (telefono like '[0-9]%');

-- Restricciones para la tabla Categorias
alter table categorias add
    constraint uq_categorias_nombre_categoria unique(nombre_categoria);

-- Restricciones para la tabla Productos
alter table productos add
    constraint fk_productos_id_categoria foreign key(id_categoria) references categorias(id_categoria),
    constraint chk_productos_precio CHECK (precio > 0),
    constraint chk_productos_stock_disponible CHECK (stock_disponible >= 0);

-- Restricciones para la tabla Favoritos
alter table favoritos add
    constraint fk_favoritos_id_cliente foreign key(id_cliente) references clientes(id_cliente),
    constraint fk_favoritos_id_producto foreign key(id_producto) references productos(id_producto);

-- Restricciones para la tabla Direcciones
alter table direcciones add
    constraint chk_direcciones_cp CHECK (cp like '[0-9]%'),
    constraint chk_direcciones_no_interior CHECK (no_interior > 0),
	constraint chk_direcciones_no_exterior CHECK (no_exterior > 0);

-- Restricciones para la tabla Proveedores
alter table proveedores add
    constraint uq_proveedores_correo_electronico unique(correo_electronico),
    constraint chk_proveedores_telefono CHECK (telefono like '[0-9]%');

-- Restricciones para la tabla Carrito
alter table carrito add
    constraint fk_carrito_id_cliente foreign key(id_cliente) references clientes(id_cliente),
    constraint fk_carrito_id_producto foreign key(id_producto) references productos(id_producto),
    constraint chk_carrito_precio CHECK (precio > 0);
    --constraint chk_carrito_stock_disponible CHECK (stock_disponible >= 0);


-- Restricciones para la tabla Pedidos
alter table pedidos add
    constraint fk_pedidos_id_cliente foreign key(id_cliente) references clientes(id_cliente),
    constraint fk_pedidos_id_direccion foreign key(id_direccion) references direcciones(id_direccion),
    constraint chk_pedidos_cantidad CHECK (cantidad > 0),
    constraint chk_pedidos_total CHECK (total > 0),
	constraint chk_pedidos_estado_pedido CHECK (estado_pedido='PROCESANDO' OR estado_pedido='ENTREGADO' OR estado_pedido='DEVOLVIENDO' OR estado_pedido='DEVUELTO' OR estado_pedido='RETRASADO' OR estado_pedido='CANCELADO'),
    constraint df_pedidos_fecha_pedido DEFAULT SYSDATETIME() for fecha_pedido;



-- Restricciones para la tabla Detalles_Productos
alter table detalles_productos add
    constraint fk_detalles_productos_id_producto foreign key(id_producto) references productos(id_producto),
    constraint chk_detalles_productos_talla CHECK (talla > 0);

-- Restricciones para la tabla Pagos_Pedidos
alter table pagos_pedidos add
    constraint fk_pagos_pedidos_id_pedido foreign key(id_pedido) references pedidos(id_pedido),
    constraint chk_pagos_pedidos_monto_pago CHECK (monto_pago > 0),
	 constraint chk_pagos_pedidos_metodo_pago CHECK (metodo_pago='EFECTIVO' OR metodo_pago='CREDITO' OR metodo_pago='DEBITO'),
	constraint df_pagos_pedidos_fecha_pago DEFAULT SYSDATETIME() for fecha_pago;

-- Restricciones para la tabla Devoluciones
alter table devoluciones add
    constraint fk_devoluciones_id_pedido foreign key(id_pedido) references pedidos(id_pedido),
	constraint chk_pedidos_estado_devolucion CHECK (estado_devolucion='PROCESANDO' OR estado_devolucion='DEVOLVIENDO' OR estado_devolucion='DEVUELTO' OR estado_devolucion='DEVOLUCION DENEGADA'),
	constraint df_devoluciones_fecha_devolucion DEFAULT SYSDATETIME() for fecha_devolucion;

-- Restricciones para la tabla Empleados_Pedidos
alter table empleados_pedidos add
    constraint fk_empleados_pedidos_id_empleado foreign key(id_empleado) references empleados(id_empleado),
    constraint fk_empleados_pedidos_id_pedido foreign key(id_pedido) references pedidos(id_pedido),
    --constraint df_empleados_pedidos_fecha_devolucion DEFAULT SYSDATETIME() for fecha_devolucion,
	constraint df_empleados_pedidos_fecha_asignacion DEFAULT SYSDATETIME() for fecha_asignacion;

-- Restricciones para la tabla Detalles_Pedidos
alter table detalles_pedidos add
    constraint fk_detalles_pedidos_id_pedido foreign key(id_pedido) references pedidos(id_pedido),
    constraint fk_detalles_pedidos_id_direccion foreign key(id_direccion) references direcciones(id_direccion),
    constraint chk_detalles_pedidos_cantidad CHECK (cantidad > 0),
    constraint chk_detalles_pedidos_precio_unitario CHECK (precio_unitario > 0);

-- Restricciones para la tabla Materiales
alter table materiales add
    constraint fk_materiales_id_proveedor foreign key(id_proveedor) references proveedores(id_proveedor),
    constraint chk_materiales_cantidad_disponible CHECK (cantidad_disponible > 0);

-- Restricciones para la tabla Productos_Materiales
alter table productos_materiales add
    constraint fk_productos_materiales_id_producto foreign key(id_producto) references productos(id_producto),
    constraint fk_productos_materiales_id_material foreign key(id_material) references materiales(id_material),
    constraint chk_productos_materiales_cantidad_usada CHECK (cantidad_usada > 0),
    constraint chk_productos_materiales_costo_material CHECK (costo_material > 0);





-----------------------------------------------------------------------------------------------------
---------------------------------------REGISTROS-----------------------------------------------------
-----------------------------------------------------------------------------------------------------

-- Clientes 
INSERT INTO clientes (nombre, apellidos, correo_electronico, telefono, pais)
VALUES
	('Juan', 'Perez', 'juan.perez@example.com', '5551234567', 'Mexico'),
	('Ana', 'Garcia', 'ana.garcia@example.com', '5552345678', 'USA'),
	('Luis', 'Mendoza', 'luis.mendoza@example.com', '5553456789', 'Mexico'),
	('Sof a', 'Martinez', 'sofia.martinez@example.com', '5554567890', 'Francia'),
	('Carlos', 'Fernandez', 'carlos.fernandez@example.com', '5555678901', 'Mexico'),
	('Laura', 'Gomez', 'laura.gomez@example.com', '5556789012', 'Mexico'),
	('Pedro', 'Hernandez', 'pedro.hernandez@example.com', '5557890123', 'USA'),
	('Carmen', 'Lopez', 'carmen.lopez@example.com', '5558901234', 'Mexico'),
	('Ra l', 'Ramirez', 'raul.ramirez@example.com', '5559012345', 'USA'),
	('Marta', 'Diaz', 'marta.diaz@example.com', '5550123456', 'Mexico'),
	('Alejandro', 'Ruiz', 'alejandro.ruiz@example.com', '5551231234', 'USA'),
	('Paola', 'Sanchez', 'paola.sanchez@example.com', '5552342345', 'Mexico'),
	('Javier', 'Flores', 'javier.flores@example.com', '5553453456', 'USA'),
	('Maria', 'Ortiz', 'maria.ortiz@example.com', '5554564567', 'Mexico'),
	('Roberto', 'Cruz', 'roberto.cruz@example.com', '5555675678', 'USA'),
	('Claudia', 'Nunez', 'claudia.nunez@example.com', '5556786789', 'Mexico'),
	('Ricardo', 'Castillo', 'ricardo.castillo@example.com', '5557897890', 'Mexico'),
	('Gabriela', 'Reyes', 'gabriela.reyes@example.com', '5558908901', 'Mexico'),
	('Jose', 'Ibarra', 'jose.ibarra@example.com', '5559019012', 'Francia'),
	('Adriana', 'Silva', 'adriana.silva@example.com', '5550120123', 'Francia');

	SELECT*FROM clientes;

-- Comentarios 
INSERT INTO comentarios (id_cliente, texto_comentario)
VALUES
	(1,'Muy comodos, excelente calidad.'),
	(2,'Me encantaron, perfectos para el verano.'),
	(3,'La suela es resistente, los recomiendo.'),
	(4,'Lindos, pero el tamano no me quedo  muy bien.'),
	(5,'Perfectos para usar en el dia a dia.'),
	(6,'El diseno artesanal es  unico.'),
	(7,'Excelente servicio, el envio fue rapido.'),
	(8,'Un poco caros, pero valen la pena.'),
	(9,'Son muy duraderos, los usar  por mucho tiempo.'),
	(10,'El color no era como esperaba, pero son comodos.'),
	(11,'Me gusta que sean hechos a mano.'),
	(12,'Muy ligeros, ideales para el calor.'),
	(13,'Me llego un par con defecto, pero lo solucionaron rapido.'),
	(14,'Tienen gran variedad de modelos, elegi  los bordados.'),
	(15,'Lindos, pero me hubiera gustado una suela mas comoda.'),
	(16,'Perfectos para combinar con cualquier atuendo.'),
	(17,'Muy bonitos, los volver a comprar.'),
	(18,'El diseno es tal como en la foto.'),
	(19,'Un clasico que nunca pasa de moda.'),
	(20,'Muy satisfecho con la compra.');

	SELECT*FROM comentarios;

---Empleados
INSERT INTO empleados (nombre, apellidos, telefono)
VALUES
	('Pedro', 'Lopez', 555123456),
	('Laura', 'Sanchez', 555234567),
	('Raul', 'Hernandez', 555345678),
	('Paola', 'Gomez', 555456789),
	('Javier', 'Ortega', 555567890),
	('Sandra', 'Morales', 555678901),
	('Oscar', 'Mendoza', 555789012),
	('Claudia', 'Ruiz', 555890123),
	('Jose', 'Vargas', 555901234),
	('Rosa', 'N unez', 555012345),
	('Hector', 'Cabrera', 555123456),
	('Ana', 'Castillo', 555234567),
	('Luis', 'Molina', 555345678),
	('Beatriz', 'Iglesias', 555456789),
	('Andr s', 'Pineda', 555567890),
	('Esteban', 'Ramos', 555678901),
	('Carla', 'Salinas', 555789012),
	('Diego', 'Meza', 555890123),
	('Silvia', 'Reyes', 555901234),
	('Daniel', 'Romero', 555012345);

	SELECT*FROM empleados;

-- Categor as(DAMA,CABALLERO,NI O) YA ESTA BIEN
INSERT INTO categorias (nombre_categoria, descripcion)
VALUES
    ('Dama', 'Huaraches elegantes y c modos para mujer'),
    ('Caballero', 'Huaraches resistentes y cl sicos para hombre'),
    ('Nino', 'Huaraches coloridos y ligeros para ni os');

	SELECT*FROM categorias;

-- Productos 
insert into productos (id_categoria, nombre_producto, precio, stock_disponible, img_producto, cantidad, descontinuados, reordenar_productos) 
values
	(1, 'Huarache Bordado', 1200, 50, 0X, 34, 0, 15),
	(2, 'Huarache Troquelado', 600, 100, 0X, 23, 1, 32),
	(3, 'Huarache L ser', 1500, 30, 0X, 56, 0, 3),
	(1, 'Huarache Alpargata', 1800, 20, 0X, 89, 0, 2),
	(2, 'Huarache Tal n Pulsera', 900, 80, 0X, 98, 0, 45),
	(3, 'Huarache Tradicional', 1300, 40, 0X, 87, 0, 23),
	(1, 'Huarache de Tac n', 1600, 25, 0X, 22, 0, 25),
	(2, 'Huarache Chancla', 300, 300, 0X, 78, 0, 32);

	select*from productos;


-- Favoritos 
insert into favoritos (id_cliente, id_producto) 
values
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 5),
	(6, 6),
	(7, 7),
	(8, 8),
	(9, 1),
	(10, 2),
	(11, 3),
	(12, 4),
	(13,5),
	(14, 6),
	(15, 7),
	(16, 8),
	(17, 1),
	(18, 2),
	(19, 3),
	(20, 4);

	Select*from favoritos;

---direcciones
insert into direcciones (colonia, calle, cp, no_interior, no_exterior, descripcion, paqueteria) 
values
	('Centro', 'Av. Insurgentes 123', 12345, 1, 101, 'Departamento', 'FedEx'),
	('Roma', 'Calle Reforma 456', 67890, 2, 202, 'Apto', 'DHL'),
	('Condesa', 'Av. Ju rez 789', 23456, 3, 303, 'Oficina', 'Estafeta'),
	('Polanco', 'Calle Madero 321', 34567, 4, 404, 'Local', 'UPS'),
	('Santa Fe', 'Av. de los Insurgentes 654', 45678, 5, 505, 'Sucursal', 'FedEx'),
	('N poles', 'Calle 5 de Febrero 987', 56789, 6, 606, 'Oficina', 'DHL'),
	('Lomas', 'Av. de la Reforma 123', 67890, 7, 707, 'Apto', 'Estafeta'),
	(' lvaro Obreg n', 'Calle 16 de Septiembre 345', 78901, 8, 808, 'Sucursal', 'UPS'),
	('Tacubaya', 'Av. Chapultepec 678', 89012, 9, 909, 'Departamento', 'FedEx'),
	('Coyoac n', 'Calle Libertad 890', 90123, 10, 1010, 'Oficina', 'DHL'),
	('Iztapalapa', 'Av. Insurgentes 124', 12346, 11, 111, 'Apto', 'Estafeta'),
	('Gustavo A. Madero', 'Calle Reforma 457', 67891, 12, 222, 'Sucursal', 'UPS'),
	('Azcapotzalco', 'Av. Ju rez 790', 23457, 13, 333, 'Local', 'FedEx'),
	('Miguel Hidalgo', 'Calle Madero 322', 34568, 14, 444, 'Departamento', 'DHL'),
	('Benito Ju rez', 'Av. de los Insurgentes 655', 45679, 15, 555, 'Oficina', 'Estafeta'),
	('Tlalpan', 'Calle 5 de Febrero 988', 56790, 16, 666, 'Sucursal', 'UPS'),
	('Xochimilco', 'Av. de la Reforma 124', 67891, 17, 777, 'Apto', 'FedEx'),
	('Cuauht moc', 'Calle 16 de Septiembre 346', 78902, 18, 888, 'Local', 'DHL'),
	('Coyoac n', 'Av. Chapultepec 679', 89013, 19, 999, 'Departamento', 'Estafeta'),
	('Iztacalco', 'Calle Libertad 891', 90124, 20, 1011, 'Oficina', 'UPS');

	SELECT*FROM direcciones;

-- Proveedores
insert into proveedores (nombre, apellidos, correo_electronico, telefono,nombre_compania)
values
	('Proveedor A', 'Garcia', 'proveedorA@ejemplo.com', '5551234567', 'COMEX'),
	('Proveedor B', 'Martinez', 'proveedorB@ejemplo.com', '5552345678', 'COMEX'),
	('Proveedor C', 'Hernandez', 'proveedorC@ejemplo.com', '5553456789', 'COMEX'),
	('Proveedor D', 'Lopez', 'proveedorD@ejemplo.com', '5554567890', 'COMEX'),
	('Proveedor E', 'Perez', 'proveedorE@ejemplo.com', '5555678901', 'COPESI'),
	('Proveedor F', 'Ramirez', 'proveedorF@ejemplo.com', '5556789012', 'COPESI'),
	('Proveedor G', 'Sanchez', 'proveedorG@ejemplo.com', '5557890123', 'COPESI'),
	('Proveedor H', 'Torres', 'proveedorH@ejemplo.com', '5558901234', 'COPESI'),
	('Proveedor I', 'Vazquez', 'proveedorI@ejemplo.com', '5559012345', 'COPESI'),
	('Proveedor J', 'Morales', 'proveedorJ@ejemplo.com', '5550123456', 'COPESI'),
	('Proveedor K', 'Garcia', 'proveedorK@ejemplo.com', '5551234568', 'COPESI'),
	('Proveedor L', 'Martinez', 'proveedorL@ejemplo.com', '5552345679', 'COPESI'),
	('Proveedor M', 'Hernandez', 'proveedorM@ejemplo.com', '5553456790', 'COPESI'),
	('Proveedor N', 'Lopez', 'proveedorN@ejemplo.com', '5554567901', 'RESISTOR'),
	('Proveedor O', 'Perez', 'proveedorO@ejemplo.com', '5555679012', 'RESISTOR'),
	('Proveedor P', 'Ramirez', 'proveedorP@ejemplo.com', '5556789123', 'RESISTOR'),
	('Proveedor Q', 'Sanchez', 'proveedorQ@ejemplo.com', '5557891234', 'RESISTOR'),
	('Proveedor R', 'Torres', 'proveedorR@ejemplo.com', '5558902345', 'RESISTOR'),
	('Proveedor S', 'Vazquez', 'proveedorS@ejemplo.com', '5559013456', 'RESISTOR'),
	('Proveedor T', 'Morales', 'proveedorT@ejemplo.com', '5550124567', 'RESISTOR');

	SELECT*FROM proveedores;

-- Carrito 
insert into carrito (id_cliente, id_producto, nombre_producto, precio, img_producto) 
values
	(1, 1, 'Huarache Bordado', 1200, 0X),
	(2, 2, 'Huarache Troquelado', 600, 0X),
	(3, 3, 'Huarache L ser', 1500, 0X),
	(4, 4, 'Huarache Alpargata', 1800, 0X),
	(5, 5, 'Huarache Tal n Pulsera', 900, 0X),
	(6, 6, 'Huarache Tradicional', 1300, 0X),
	(7, 7, 'Huarache de Tac n', 1600, 0X),
	(8, 8, 'Huarache Chancla', 300, 0X),
	(9, 1, 'Huarache Bordado', 1200, 0X),
	(10, 2, 'Huarache Troquelado', 600, 0X),
	(11, 3, 'Huarache L ser', 1500, 0X),
	(12, 4, 'Huarache Alpargata', 1800, 0X),
	(13, 5, 'Huarache Tal n Pulsera', 900, 0X),
	(14, 6, 'Huarache Tradicional', 1300, 0X);

	SELECT*FROM carrito;

-- Pedidos 
insert into pedidos (id_cliente, id_direccion, cantidad, estado_pedido, total) 
values
	(1, 1, 2, 'PROCESANDO', 1600),
	(2, 2, 1,  'ENTREGADO', 500),
	(3, 3, 3,  'DEVUELTO', 3600),
	(4, 4, 1,  'CANCELADO', 1500),
	(5, 5, 4,  'RETRASADO', 4000),
	(6, 6, 2,  'PROCESANDO', 1200),
	(7, 7, 1,  'ENTREGADO', 1800),
	(8, 8, 5,  'DEVOLVIENDO', 7000),
	(9, 9, 3,  'RETRASADO', 2100),
	(10, 10, 2,  'CANCELADO', 600),
	(11, 1, 1,  'PROCESANDO', 800),
	(12, 2, 2, 'ENTREGADO', 1000),
	(13, 3, 1,  'DEVUELTO', 1200),
	(14, 4, 4, 'RETRASADO', 6000),
	(15, 5, 2,  'PROCESANDO', 2000),
	(16, 6, 3,  'DEVOLVIENDO', 2400),
	(17, 7, 1, 'ENTREGADO', 800),
	(18, 8, 2,  'DEVUELTO', 1400),
	(19, 9, 5,  'RETRASADO', 3500),
	(20, 10, 3,  'CANCELADO', 900);

	SELECT*FROM pedidos;


-- Detalles Productos
INSERT INTO detalles_productos (id_producto, descripcion, talla, color, img_producto) 
VALUES
    (1, 'Huarache bordado colorido', 42, 'Negro', 0x),
    (2, 'Huarache troquelado moderno', 40, 'Azul', 0x),
    (3, 'Huarache l ser colorido', 43, 'Tang', 0x),
    (4, 'Huarache alpargata elegante', 38, 'Beige', 0x),
    (5, 'Huarache tal n pulsera fresco', 41, 'Rosa', 0x),
    (6, 'Huarache tradicional y cl sico', 39, 'Verde', 0x),
    (7, 'Huarache de tac n grueso', 44, 'Negro', 0x),
    (8, 'Huarache chancla tipo playero', 37, 'Rojo', 0x);


	SELECT*FROM detalles_productos;

-- Pagos Pedidos
insert into pagos_pedidos (id_pedido, monto_pago, metodo_pago) values
	(1, 1500, 'EFECTIVO'),
	(2,  2000, 'CREDITO'),
	(3,  2500, 'DEBITO'),
	(4,  1800, 'EFECTIVO'),
	(5,  2200, 'CREDITO'),
	(6,  1700, 'DEBITO'),
	(7,  1600, 'EFECTIVO'),
	(8,  2100, 'CREDITO'),
	(9,  2300, 'DEBITO'),
	(10, 1900, 'EFECTIVO'),
	(11, 2500, 'CREDITO'),
	(12, 2400, 'DEBITO'),
	(13, 2000, 'EFECTIVO'),
	(14, 2200, 'CREDITO'),
	(15, 2100, 'DEBITO'),
	(16, 1700, 'EFECTIVO'),
	(17, 2300, 'CREDITO'),
	(18, 1900, 'DEBITO'),
	(19, 1800, 'EFECTIVO'),
	(20, 2000, 'CREDITO');

	SELECT*FROM pagos_pedidos;

-- Devoluciones 
insert into devoluciones (id_pedido, razon_devolucion, estado_devolucion) 
values
	(1,'Producto defectuoso', 'PROCESANDO'),
	(2,'No era el tama o correcto', 'DEVUELTO'),
	(3,'Cambio de opini n',  'DEVUELTO'),
	(4,'Huarache lleg  da ado',  'DEVOLVIENDO'),
	(5,'Recib  el producto incorrecto',  'DEVOLVIENDO'),
	(6,'Desistimiento de compra',  'DEVUELTO'),
	(7,'Problemas con el color',  'PROCESANDO'),
	(8,'Error en el pedido',  'DEVUELTO'),
	(9,'Tama o incorrecto', 'PROCESANDO'),
	(10,'Producto no es lo que esperaba', 'DEVUELTO'),
	(11,'Huarache lleg  da ado','DEVOLVIENDO'),
	(12,'Cambio de opini n', 'DEVUELTO'),
	(13,'Recib  el producto incorrecto', 'DEVUELTO'),
	(14,'Producto defectuoso', 'DEVOLVIENDO'),
	(15,'No era el tama o correcto', 'DEVUELTO'),
	(16,'Desistimiento de compra', 'DEVUELTO'),
	(17,'Problemas con el color', 'PROCESANDO'),
	(18,'Error en el pedido',  'DEVUELTO'),
	(19,'Tama o incorrecto',  'PROCESANDO'),
	(20,'Producto no es lo que esperaba',  'DEVUELTO');

	SELECT*FROM devoluciones;

-- Empleados Pedidos
insert into empleados_pedidos (id_empleado, id_pedido, rol_pedido) 
values
    (1, 1, 'Suajeador'),
    (3, 2, 'Forjador'),
    (4, 3, 'Empacador'),
    (5, 4, 'Asentador'),
    (6, 5, 'Arreglador'),
    (7, 6, 'Encorrellador'),
    (8, 7, 'Suajeador'),
    (9, 8, 'Forjador'),
    (10,9, 'Empacador'),
    (11,10, 'Asentador'),
    (12,11, 'Arreglador'),
    (13,12, 'Cortador'),
    (14,13, 'Remachador'),
    (15,14, 'Pulidor'),
    (16,15, 'Pespuntador'),
    (17,16, 'Encorrellador'),
    (18,17, 'Montador'),
    (19,18, 'Lustrador'),
    (20,19, 'Arreglador'),
	(2,20, 'Encorrellador');

	--select*from empleados_pedidos;

-- Detalles Pedidos 
insert into detalles_pedidos (id_pedido, id_direccion, cantidad, precio_unitario, descuento) 
values
	(1, 1, 2, 800, 0),
	(2, 2, 1, 500, 0),
	(3, 3, 3, 1200, 0),
	(4, 4, 1, 1500, 0),
	(5, 5, 4, 1000, 0),
	(6, 6, 2, 600, 0),
	(7, 7, 1, 1800, 0),
	(8, 8, 5, 1400, 0),
	(9, 9, 3, 700, 0),
	(10, 10, 2, 300, 0),
	(11, 1, 1, 800, 0),
	(12, 2, 2, 500, 0),
	(13, 3, 1, 1200, 0),
	(14, 4, 4, 1500, 0),
	(15, 5, 2, 1000, 0),
	(16, 6, 3, 600, 0),
	(17, 7, 1, 1800, 0),
	(18, 8, 2, 1400, 0),
	(19, 9, 5, 700, 0),
	(20, 10, 3, 300, 0);

	SELECT*FROM detalles_pedidos;

-- Materiales(Pegamento/blanco/rojo,tachuelas,hormas,suela,vaqueta,laca,brochas,suajes,martillo.bolsas,cajas,periodico,boston-liquido,celtec,forro)
insert into materiales (id_proveedor, nombre_material, cantidad_disponible) 
values
	(1, 'Pegamento blanco', 200),
	(2, 'Pegamento rojo', 300),
	(3, 'Tachuelas', 150),
	(4, 'Hormas', 100),
	(5, 'Suela de goma', 50),
	(6, 'Vaqueta', 250),
	(7, 'Laca', 180),
	(8, 'Brochas', 75),
	(9, 'Suajes', 120),
	(10, 'Martillo', 200),
	(11, 'Bolsas', 220),
	(12, 'Cajas de cart n', 310),
	(13, 'Peri dico', 160),
	(14, 'Boston l quido', 110),
	(15, 'Celtec', 60),
	(16, 'Forro de tela', 270),
	(17, 'Tiras de cuero', 190),
	(18, 'Plantillas de refuerzo', 80),
	(19, 'Material anti-deslizante', 130),
	(20, 'Cordones de nylon', 210);

	SELECT*FROM materiales;
	SELECT*FROM proveedores;

-- Productos Materiales(dm,ltr,gr)
insert into productos_materiales (id_producto, id_material, cantidad_usada, costo_material, unidad_medida) 
values
	(1, 4, 500, 200, 'ml'),     -- Pegamento blanco, 500ml
	(2, 5, 2, 400, 'ml'),       -- Pegamento rojo, 2ml
	(3, 4, 300, 300, 'ml'),     -- Pegamento blanco, 300ml
	(4, 5, 500, 700, 'ml'),     -- Pegamento rojo, 500ml
	(5, 6, 450, 450, 'ml'),     -- Pegamento rojo, 450ml
	(6, 7, 550, 550, 'ml'),     -- Pegamento rojo, 550ml
	(7, 7, 2, 120, 'uds'),      -- Martillos, 2 unidades
	(8, 8, 3, 150, 'uds'),      -- Brochas, 3 unidades
	(1, 9, 50, 200, 'uds'),     -- Suajes, 50 unidades
	(2, 10, 200, 80, 'uds'),   -- Bolsas de papel, 200 unidades
	(3, 20, 400, 200, 'ml'),    -- Pegamento blanco, 400ml
	(4, 13, 150, 150, 'mts'),   -- Tela para forro, 150 metros
	(5, 14, 50, 70, 'uds'),     -- Hebillas met lic6, 5, 100, 120, 'uds'),   -- Puntas de refuerzo, 100 unidades
	(6, 16, 1, 90, 'litros'),   -- Laca, 1 litro
	(7, 17, 200, 110, 'mts'),   -- Cordones de cuero, 200 metros
	(8, 18, 150, 130, 'uds'),   -- Placas de refuerzo, 150 unidades
	(1, 13, 750, 800, 'ml'),    -- Pegamento rojo, 750ml
	(2, 17, 450, 450, 'ml'),    -- Pegamento rojo, 450ml
	(3, 19, 500, 400, 'ml');    -- Pegamento rojo, 500ml

	SELECT*FROM productos_materiales;




























