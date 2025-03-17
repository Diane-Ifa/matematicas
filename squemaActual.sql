create table docente
(
    id                 int auto_increment
        primary key,
    nombre             text not null,
    apellidos          text not null,
    correo_electronico text null
);

create table gradoAcademico
(
    id    int auto_increment
        primary key,
    tipo  enum ('Primaria', 'Secundaria', 'Telesecundaria') not null,
    nivel int                                               not null
)
    comment 'Esta tabla contara con los diferentes grados escolares ';

create table alumnos
(
    id                 int  not null
        primary key,
    nombre             text not null,
    apellidos          text not null,
    correo_electronico text not null,
    grado_id           int  not null,
    constraint alumnos_gradoAcademico_id_fk
        foreign key (grado_id) references gradoAcademico (id)
);

create table materias
(
    id     int auto_increment
        primary key,
    nombre text not null
)
    comment 'Aqui se van a representar las materias que engloba la NEM ';

create table docente_materia
(
    docente_id int not null,
    materia_id int not null,
    id         int auto_increment
        primary key,
    constraint docente_materia_docente_id_fk
        foreign key (docente_id) references docente (id),
    constraint docente_materia_materias_id_fk
        foreign key (materia_id) references materias (id)
)
    comment 'Esta tabla sirve para representar la relacion entre docente y lateria, ya que uno o muchos docentes puede impartir la misma materia o impartir varias materias';

create table periodo
(
    id          int auto_increment
        primary key,
    descripcion text     not null comment 'se especificara al periodo (semestre o año) correspondiente al que el alumno esta tomando la materia',
    fechaInicio datetime not null,
    fechaFin    datetime not null
);

create table cursos
(
    id         int auto_increment
        primary key,
    nombre     int null,
    materia_id int not null,
    periodo_id int not null,
    constraint cursos_materias_id_fk
        foreign key (materia_id) references materias (id),
    constraint cursos_periodo_id_fk
        foreign key (periodo_id) references periodo (id)
);

create table docente_curso
(
    id         int auto_increment
        primary key,
    docente_id int not null,
    curso_id   int null,
    constraint docente_curso_cursos_id_fk
        foreign key (curso_id) references cursos (id),
    constraint docente_curso_docente_id_fk
        foreign key (docente_id) references docente (id)
)
    comment 'Esta tabla sirve para la relacion entre docente y curso, lo cual indica que un curso puede tener varios docente y que un docente puede impartir varios cursos';

create table inscripcion
(
    id                int auto_increment
        primary key,
    fecha_inscripcion datetime not null,
    curso_id          int      not null,
    alumno_id         int      not null,
    constraint inscripcion_alumnos_id_fk
        foreign key (alumno_id) references alumnos (id),
    constraint inscripcion_cursos_id_fk
        foreign key (curso_id) references cursos (id)
)
    comment 'esta tabla ayuda a coprender mejor la relacion entre el alumno a un curso';

create table roles
(
    id     int auto_increment
        primary key,
    nombre varchar(10) not null
)
    comment 'Contiene los tipos de roles que pueden tener los usuarios (alumno, docente y administrador)';

create table temas
(
    id         int auto_increment
        primary key,
    nombre     text not null,
    materia_id int  not null,
    grado_id   int  not null,
    constraint temas_gradoAcademico_id_fk
        foreign key (grado_id) references gradoAcademico (id),
    constraint temas_materias_id_fk
        foreign key (materia_id) references materias (id)
)
    comment 'son los temas que se relacionan con la materia';

create table contenido
(
    id      int auto_increment
        primary key,
    titulo  text not null,
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
    rol_id         int      not null,
    fecha_registro datetime not null,
    foto_perfil    text     null,
    biografia      text     null,
    constraint usuarios_roles_id_fk
        foreign key (rol_id) references roles (id)
)
    comment 'almacena la informacion basica de acceso de cada usuario, con ayuda de una llave forenea que hace referencia al tipo de rol asignado';

create table administrador
(
    usuario_id         int         not null,
    nombre             varchar(20) not null,
    apellidos          varchar(30) not null,
    correo_electronico int         not null,
    constraint administrador_usuarios_id_fk
        foreign key (usuario_id) references usuarios (id)
);

create table historialAccesos
(
    id           int auto_increment
        primary key,
    fecha_acceso datetime not null,
    ipAcceso     text     not null,
    usuario_id   int      not null,
    contenido_id int      not null,
    constraint historialAccesos_contenido_id_fk
        foreign key (contenido_id) references contenido (id),
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

