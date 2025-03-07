create table alumnos
(
    id     int auto_increment
        primary key,
    nombre text not null
);

create table docente
(
    id     int auto_increment
        primary key,
    nombre text not null
);

create table materias
(
    id     int auto_increment
        primary key,
    nombre text not null
)
    comment 'Aqui se van a representar las materias que engloba la NEM ';

create table periodo
(
    id int auto_increment
        primary key
);

create table temas
(
    id         int auto_increment
        primary key,
    nombre     text not null,
    materia_id int  not null,
    constraint temas_materias_id_fk
        foreign key (materia_id) references materias (id)
)
    comment 'son los temas que se relacionan con la materia';

create table contenido
(
    id      int auto_increment
        primary key,
    nombre  text not null,
    tema_id int  not null,
    constraint contenido_temas_id_fk
        foreign key (tema_id) references temas (id)
)
    comment 'Se enlistan los contenidos dependiendo del tema de la materia';

create table usuarios
(
    id             int auto_increment
        primary key,
    nombre         text     not null,
    correo         text     not null,
    contrasena     text     not null comment 'esta columna debe de estra incriptada para la seguridad del programa y del usuario mismo',
    rol            text     not null comment 'comentar que tipo de dato es mas conveniente',
    fecha_registro datetime not null,
    foto_perfil    text     null,
    biografia      text     null
)
    comment 'almacena la informacion basica del nuevo usuario, el rol diferencia a cada usuario';

create table historialAccesos
(
    id           int auto_increment
        primary key,
    fecha_acceso datetime not null,
    ipAcceso     text     not null,
    usuario_id   int      not null,
    constraint historialAccesos_usuarios_id_fk
        foreign key (usuario_id) references usuarios (id)
)
    comment 'registra cada acceso de los usuarios a la plataforma, lo que ayuda a monitorear la actividad y asegurar la seguridad del sistema ';

create table recursosAprendizaje
(
    id            int auto_increment
        primary key,
    usuario_id    int      not null,
    tipo_recurso  text     not null,
    titulo        text     not null,
    descripcion   text     not null,
    enlace        text     null,
    fecha_recurso datetime not null,
    constraint recursosAprendizaje_usuarios_id_fk
        foreign key (usuario_id) references usuarios (id)
)
    comment 'Almacena los recursos educativos subidos por los profesores o administradores para apoyar el aprendizaje de los estudiantes (enlaces, material adicional, etc)';

create table resultados
(
    id         int auto_increment
        primary key,
    materia    text     not null,
    nota       decimal  not null,
    fecha_nota datetime not null,
    archivo    text     null,
    comentario text     null,
    usuario_id int      not null,
    constraint resultados_usuarios_id_fk
        foreign key (usuario_id) references usuarios (id)
);

create table comentarios
(
    id               int auto_increment
        primary key,
    contenido        text     not null,
    fecha_comentario datetime not null,
    resultado_id     int      not null,
    usuario_id       int      not null,
    constraint comentarios_resultados_id_fk
        foreign key (resultado_id) references resultados (id),
    constraint comentarios_usuarios_id_fk
        foreign key (usuario_id) references usuarios (id)
)
    comment 'Son los comentarios de los administradores o profesores sobre los resultados academiscos.Permite interectuar con los estudiantes directamente';

