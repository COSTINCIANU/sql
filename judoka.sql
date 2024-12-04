-- Création de la base de données judoka
CREATE DATABASE IF NOT EXISTS judoka CHARSET utf8mb4; 
USE judoka; 


-- Création de la table "niveau"
CREATE TABLE niveau(
    id_niveau INT PRIMARY KEY AUTO_INCREMENT,
    couleur_ceinture VARCHAR(50) NOT NULL
)ENGINE=InnoDB;



-- Création de la table "judoka"
CREATE TABLE judoka (
    id_judoka INT PRIMARY KEY AUTO_INCREMENT,
    nom_judoka VARCHAR(50) NOT NULL,
    prenom_judoka VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    sexe VARCHAR(5) NOT NULL,
    id_niveau INT NOT NULL,
    FOREIGN KEY (id_niveau) REFERENCES niveau(id_niveau)
    ON DELETE CASCADE
) ENGINE=InnoDB;


-- Création de la table "competition"
CREATE TABLE competition (
    id_cpt INT PRIMARY KEY AUTO_INCREMENT,
    nom_cpt VARCHAR(50) NOT NULL,
    date_deb DATE NOT NULL,
    date_fin DATE NOT NULL
) ENGINE=InnoDB;

-- Création de la table d'association "judoka_competition"
CREATE TABLE judoka_competition (
    id_judoka INT NOT NULL,
    id_cpt INT NOT NULL,
    PRIMARY KEY (id_judoka, id_cpt),
    FOREIGN KEY (id_judoka) REFERENCES judoka(id_judoka)
    ON DELETE CASCADE,
    FOREIGN KEY (id_cpt) REFERENCES competition(id_cpt)
    ON DELETE CASCADE
) ENGINE=InnoDB;


-- Insertion dans la table "niveau"
INSERT INTO niveau (id_niveau, couleur_ceinture) VALUES
(1, 'blanche'),
(2, 'jaune'),
(3, 'orange'),
(4, 'verte'),
(5, 'bleu'),
(6, 'marron'),
(7, 'noire');

-- Insertion des données dans la table "judoka"
INSERT INTO judoka (id_judoka, nom_judoka, prenom_judoka, age, sexe, id_niveau) VALUES
(1, 'Lachance', 'Dominique', 16, 'F', 2),
(2, 'Porter', 'Gilbert', 18, 'H', 3),
(3, 'Lemaître', 'Anne', 15, 'F', 4),
(4, 'Robert', 'Juliette', 12, 'F', 1),
(5, 'Montiny', 'Pierre', 17, 'H', 5),
(6, 'Charrette', 'Pascal', 21, 'H', 6),
(7, 'Guay', 'Émilie', 19, 'F', 6),
(8, 'Maheu', 'Louise', 14, 'F', 4),
(9, 'Poulin', 'Raymond', 26, 'H', 7),
(10, 'Dupret', 'Alain', 20, 'H', 6);

-- Insertion des données dans la table "competition"
INSERT INTO competition (id_cpt, nom_cpt, date_deb, date_fin) VALUES
(1, 'judo31', '2021-02-06', '2021-02-07'),
(2, 'Judo11', '2021-02-27', '2021-02-28'),
(3, 'Judo81', '2021-03-20', '2021-03-21'),
(4, 'Judo82', '2021-04-17', '2021-04-18');


INSERT INTO judoka_competition (id_judoka, id_cpt) VALUES
(1, 1),
(3, 1),
(4, 1),
(2, 2),
(5, 2),
(6, 2),
(9, 2),
(10, 3),
(9, 3),
(1, 4),
(3, 4),
(8, 4),
(4, 4);


UPDATE judoka
SET id_niveau = id_niveau + 1
WHERE id_judoka BETWEEN 1 AND 5;


-- Ajout de nouveaux judokas
INSERT INTO judoka (id_judoka, nom_judoka, prenom_judoka, age, sexe, id_niveau) VALUES
(11, 'Nouveau1', 'Judoka1', 22, 'H', 3),
(12, 'Nouveau2', 'Judoka2', 25, 'F', 5);

-- Suppression des nouveaux judokas
DELETE FROM judoka
WHERE id_judoka IN (11, 12);


SELECT nom_judoka, prenom_judoka
FROM judoka
JOIN niveau ON judoka.id_niveau = niveau.id_niveau
WHERE couleur_ceinture = 'verte';

SELECT COUNT(*) AS nombre_participants
FROM judoka_competition
JOIN competition ON judoka_competition.id_cpt = competition.id_cpt
WHERE nom_cpt = 'judo31';

SELECT nom_judoka, prenom_judoka, age, sexe
FROM judoka
JOIN judoka_competition ON judoka.id_judoka = judoka_competition.id_judoka
JOIN competition ON judoka_competition.id_cpt = competition.id_cpt
WHERE nom_cpt = 'Judo81';


SELECT nom_judoka, prenom_judoka, age
FROM judoka
JOIN niveau ON judoka.id_niveau = niveau.id_niveau
WHERE couleur_ceinture = 'marron' AND age > 19;

SELECT nom_judoka, prenom_judoka, couleur_ceinture
FROM judoka
JOIN niveau ON judoka.id_niveau = niveau.id_niveau
ORDER BY nom_judoka;
