CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS anime (
   animeid uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
   name text,
   description text,
   type text,
   year int,
   imageurl text);

CREATE TABLE author (
   authorid uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
   name text,
   imageurl text);

CREATE TABLE genre (
   genreid uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
   label text,
   imageurl text);

CREATE TABLE anime_author (
    animeid uuid REFERENCES anime(animeid) ON DELETE CASCADE,
    authorid uuid REFERENCES author(authorid) ON DELETE CASCADE,
    PRIMARY KEY (animeid, authorid)
    );

CREATE TABLE anime_genre (
    animeid uuid REFERENCES anime(animeid) ON DELETE CASCADE,
    genreid uuid REFERENCES genre(genreid) ON DELETE CASCADE,
    PRIMARY KEY (animeid, genreid)
    );
CREATE TABLE usser (
    userid uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    username varchar(24) NOT NULL UNIQUE,
    password varchar(255) NOT NULL,
    role varchar(10),
    enabled boolean DEFAULT true
  );

CREATE TABLE favorites (
    animeid uuid REFERENCES anime(animeid) ON DELETE CASCADE,
    userid uuid REFERENCES usser(userid) ON DELETE CASCADE,
    PRIMARY KEY (animeid, userid));

CREATE TABLE follow (
    userid uuid REFERENCES usser(userid) ON DELETE CASCADE,
    useridfollowed uuid REFERENCES usser(userid) ON DELETE CASCADE,
    PRIMARY KEY (userid, useridfollowed));

CREATE TABLE file (
    fileid UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    contenttype TEXT,
    data bytea);

CREATE TABLE grup (
    grupid uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    grupname text NOT NULL);

CREATE TABLE user_grup(
    grupid uuid REFERENCES grup(grupid) ON DELETE CASCADE,
    userid uuid REFERENCES usser(userid) ON DELETE CASCADE,
    PRIMARY KEY(grupid, userid));

CREATE TABLE img_group(
    imgid uuid PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    imgtext text);

CREATE TABLE img_amine(
    animeid uuid REFERENCES anime(animeid) ON DELETE CASCADE,
    imgid uuid REFERENCES img_group(imgid) ON DELETE CASCADE,
    PRIMARY KEY (animeid, imgid));

-- INSERTS _____________________________________________________________________________________________________________

-- afegim un usuari de prova
INSERT INTO usser (username, password) VALUES
('user1', crypt('pass', gen_salt('bf'))),
('user2', crypt('pass', gen_salt('bf'))),
('user3', crypt('pass', gen_salt('bf')));

INSERT INTO anime(name, description, type, year, imageurl) VALUES
  ('One Piece','Pirates infinity series', 'TV dairy',1998, 'movie1.jpg'),
  ('Konosuba','Sex, Gags, Iseakai','TV', 2010, 'anime2.jpg'),
  ('Mushishi','Folklore japanesse','TV', 2020, 'anime3.jpg'),
  ('Dororo','Mutilated Sacred Tradition', 'TV', 2000, 'movie4.jpg');

INSERT INTO author(name, imageurl) VALUES
('Akira Toriyama', 'autor.jpg'),
('Hayao Miyazaki', 'autor2.jpg'),
('Naoko Takemuchi', 'autor3.jpg'),
('Yoshihiro Tagashi', 'autor3.jpg');

INSERT INTO genre(label, imageurl) VALUES
('ecchi', 'img.jpg'),
('shonnen', 'img1.jpg'),
('isekai', 'img2.jpg');

INSERT INTO anime_author VALUES
((SELECT animeid FROM anime WHERE name ='One Piece'),(SELECT authorid FROM author WHERE name ='Akira Toriyama' )),
((SELECT animeid FROM anime WHERE name ='Konosuba'),(SELECT authorid FROM author WHERE name ='Hayao Miyazaki' )),
((SELECT animeid FROM anime WHERE name ='Mushishi'),(SELECT authorid FROM author WHERE name ='Naoko Takemuchi' )),
((SELECT animeid FROM anime WHERE name ='Dororo'),(SELECT authorid FROM author WHERE name ='Yoshihiro Tagashi' ));

INSERT INTO anime_genre VALUES
((SELECT animeid FROM anime WHERE name ='Dororo'),(SELECT genreid FROM genre WHERE label ='ecchi' )),
((SELECT animeid FROM anime WHERE name ='Mushishi'),(SELECT genreid FROM genre WHERE label ='shonnen' )),
((SELECT animeid FROM anime WHERE name ='Konosuba'),(SELECT genreid FROM genre WHERE label ='isekai' )),
((SELECT animeid FROM anime WHERE name ='One Piece'),(SELECT genreid FROM genre WHERE label ='ecchi' ));

INSERT INTO favorites VALUES
((SELECT animeid FROM anime WHERE name ='Dororo'),(SELECT userid FROM usser WHERE username='user1' ));

INSERT INTO follow VALUES
((SELECT userid FROM usser WHERE username='user1'), (SELECT userid FROM usser WHERE username= 'user2')),
((SELECT userid FROM usser WHERE username='user2'), (SELECT userid FROM usser WHERE username= 'user3'));

INSERT INTO grup(grupname) VALUES
('g1'),('g2');

INSERT INTO user_grup VALUES
((SELECT grupid FROM grup WHERE grupname='g1'), (SELECT userid FROM usser WHERE username= 'user1')),
((SELECT grupid FROM grup WHERE grupname='g1'), (SELECT userid FROM usser WHERE username= 'user2')),
((SELECT grupid FROM grup WHERE grupname='g2'), (SELECT userid FROM usser WHERE username= 'user3'));

--IMAGES---------------------------------------------------------------------------------------------------------------

INSERT INTO img_group(imgtext) VALUES
('image1.jpg'),('image2.jpg');

INSERT INTO img_amine VALUES
((SELECT animeid FROM anime WHERE name = 'One Piece'), (SELECT imgid FROM img_group WHERE imgtext = 'image1.jpg')),
((SELECT animeid FROM anime WHERE name = 'Mushishi'), (SELECT imgid FROM img_group WHERE imgtext = 'image2.jpg'));