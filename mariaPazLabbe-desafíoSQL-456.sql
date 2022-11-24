
- Primero ingresare a postgres
psql -U postgres
- Creamos la base de datos:
CREATE DATABASE examen_mariapaz_labbe_007;

- conectamos la base de dato:

\c examen_mariapaz_labbe_007;

Comencemos con el desafío:

1. Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las
claves primarias, foráneas y tipos de datos. 

- Donde se nos presenta una tabla de mucho a mucho, donde debemos crear una tabla intermedia que llamaremos peliculas_tags. La cual va a contener las llaves priamrias de cada una de ellas y poder cruzar los datos.
 
--. Tabla Peliculas
CREATE TABLE peliculas (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(255),
  anno INTEGER
);


-- Tabla Tags
CREATE TABLE tags (id SERIAL PRIMARY KEY, tag VARCHAR(32));



--Tabla Intermedia necesaria porque la relacion entre la tabla Peliculas y TAGS es N:N
CREATE TABLE pelicula_tags (
  pelicula_id BIGINT,
  tag_id BIGINT,
  FOREIGN KEY (pelicula_id) REFERENCES peliculas (id),
  FOREIGN KEY (tag_id) REFERENCES tags (id)
);


- La cual tiene como llave foranea las llaves primarias de las otras tablas.


2. Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la
segunda película debe tener dos tags asociados. 


--Peliculas
INSERT INTO peliculas (nombre, anno) VALUES('Hobbit', 2012);
INSERT INTO peliculas (nombre, anno) VALUES('Interestelar', 2014);
INSERT INTO peliculas (nombre, anno) VALUES('Aquaman', 2018);
INSERT INTO peliculas (nombre, anno) VALUES('Avatar', 2009);
INSERT INTO peliculas (nombre, anno) VALUES('Sinsajo', 2015);

--Tags
INSERT INTO tags (tag) VALUES ('Aventuras');
INSERT INTO tags (tag) VALUES ('Ciencia Ficción');
INSERT INTO tags (tag) VALUES ('Terror');
INSERT INTO tags (tag) VALUES ('Fantasía');
INSERT INTO tags (tag) VALUES ('Drama');

--Tabla Intemedia Peliculas_tags
INSERT INTO pelicula_tags (pelicula_id, tag_id) VALUES (1,1);
INSERT INTO pelicula_tags (pelicula_id, tag_id) VALUES (1,2);
INSERT INTO pelicula_tags (pelicula_id, tag_id) VALUES (1,4);
INSERT INTO pelicula_tags (pelicula_id, tag_id) VALUES (2,1);
INSERT INTO pelicula_tags (pelicula_id, tag_id) VALUES (2,2);


3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
mostrar 0. 

select
  peliculas.nombre,
  count(pelicula_tags.tag_id)
From
  peliculas
  LEFT JOIN pelicula_tags on peliculas.id = pelicula_tags.pelicula_id
GROUP by
  peliculas.nombre;

  -Para esto trabajamos con un left join y nos trae todas las peliculas.

  - Para las siguientes preguntas debemos pasar a las siguientes tablas que nos piden:

4. Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de
datos. 

-- Tabla Preguntas
CREATE TABLE preguntas (
  id SERIAL PRIMARY KEY,
  pregunta VARCHAR(255),
  respuesta_correcta VARCHAR
);


--Tabla Usuarios
CREATE TABLE usuarios(
  id SERIAL PRIMARY key,
  nombre VARCHAR(255),
  edad INTEGER
);

--Tabla Respuestas
CREATE TABLE respuestas (
  id SERIAL PRIMARY KEY,
  respuesta VARCHAR(255),
  usuario_id BIGINT,
  pregunta_id BIGINT,
  FOREIGN KEy (usuario_id) REFERENCES usuarios (id),
  FOREIGN KEy (pregunta_id) REFERENCES preguntas (id)
);

- La tabla de respuesta es la tabla intermdia, almacenando como llave foranea las llaves priamrias de usuario y preguntas.

5. Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada
dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada
correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.

--ploblamiento tabla Usuarios
INSERT INTO usuarios (nombre, edad) VALUES ('Miguel',34);
INSERT INTO usuarios (nombre, edad) VALUES ('José',33);
INSERT INTO usuarios (nombre, edad) VALUES ('Consuelo',31);
INSERT INTO usuarios (nombre, edad) VALUES ('Raquel',28);
INSERT INTO usuarios (nombre, edad) VALUES ('Rosario',30);

--ploblamiento tabla Preguntas
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('¿Cuántos minutos tiene una hora?', '60 minutos' );
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('¿Cuántas patas tiene una araña?', 'Tiene 8 patas' );
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('¿Cuál es el río más caudaloso del mundo?', 'El río Amazonas' );
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('¿Cada cuántos años tenemos un año bisiesto?', 'Cada 4 años' );
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('¿Qué planeta es el más cercano al Sol?', 'Mercurio' );

--ploblamiento tabla respuestas
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id ) VALUES('60 minutos',3,1);
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id ) VALUES('60 minutos',4,1);
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id ) VALUES('Tiene 8 patas',1,2);
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id ) VALUES('error',2,2);
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id ) VALUES('nada',5,2);


6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
pregunta).

select
  usuarios.nombre,
  count(preguntas.respuesta_correcta) as Respuestas_correctas
from
  preguntas
  RIGHT JOIN respuestas on respuestas.respuesta = preguntas.respuesta_correcta
  JOIN usuarios on usuarios.id = respuestas.usuario_id
GROUP by
  usuario_id,
  usuarios.nombre;

7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la
respuesta correcta.

select
  preguntas.pregunta,
  COUNT(respuestas.usuario_id) as Respuesta_correctas
from
  respuestas
  RIGHT JOIN preguntas on respuestas.pregunta_id = preguntas.id
group BY
  preguntas.pregunta;

8. Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el
primer usuario para probar la implementación. 

--8.1 Implementacion 
ALTER TABLE respuestas DROP CONSTRAINT respuestas_usuario_id_fkey, ADD FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE;

--8.2 Eliminacion Usuario 
DELETE FROM usuarios WHERE id = 1;


9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de
datos

ALTER TABLE usuarios ADD CHECK (edad > 18); 

10. Altera la tabla existente de usuarios agregando el campo email con la restricción de
único.

ALTER TABLE usuarios ADD email VARCHAR(50) UNIQUE;

-podemos ver : 
SELECT * FROM usuarios;

 - Para ver restricciones lo hacemo:
 \d usuarios

