-- Création de la base de données
CREATE DATABASE IF NOT EXISTS caisse CHARSET utf8mb4;
USE caisse;

-- Création des tables
CREATE TABLE IF NOT EXISTS categorie(
id_categorie INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nom_categorie VARCHAR(50) UNIQUE NOT NULL
)Engine=InnoDB;

CREATE TABLE IF NOT EXISTS vendeur(
id_vendeur INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nom_vendeur VARCHAR(50) NOT NULL,
prenom_vendeur VARCHAR(50) NOT NULL
)Engine=InnoDB;

CREATE TABLE IF NOT EXISTS ticket(
id_ticket INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
date_creation DATETIME NOT NULL,
id_vendeur INT NOT NULL
)Engine=InnoDB;

CREATE TABLE IF NOT EXISTS produit(
id_produit INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nom_produit VARCHAR(50) NOT NULL,
`description` VARCHAR(255) NOT NULL,
tarif DECIMAL(3,2) NOT NULL,
id_categorie INT NOT NULL
)Engine=InnoDB;

-- Création de la table association
CREATE TABLE IF NOT EXISTS produit_ticket(
id_ticket INT,
id_produit INT,
quantite INT NOT NULL,
PRIMARY KEY(id_ticket, id_produit)
)Engine=InnoDB;

-- Ajouter les contraintes foreign key
ALTER TABLE produit
ADD CONSTRAINT fk_lier_categorie
FOREIGN KEY(id_categorie)
REFERENCES categorie(id_categorie)
ON DELETE CASCADE;

ALTER TABLE ticket
ADD CONSTRAINT fk_vendre_vendeur
FOREIGN KEY(id_vendeur)
REFERENCES vendeur(id_vendeur)
ON DELETE CASCADE;

ALTER TABLE produit_ticket
ADD CONSTRAINT fk_ajouter_produit
FOREIGN KEY(id_produit)
REFERENCES produit(id_produit);

ALTER TABLE produit_ticket
ADD CONSTRAINT fk_ajouter_ticket
FOREIGN KEY(id_ticket)
REFERENCES ticket(id_ticket);


-- 1. Afficher la liste des produits qui n'ont jamais été dans un ticket de caisse :
SELECT p.id_produit, p.nom_produit, p.description, p.tarif
FROM produit p
LEFT JOIN produit_ticket pt ON p.id_produit = pt.id_produit
WHERE pt.id_produit IS NULL;


-- 2. Afficher la liste des vendeurs qui n'ont jamais vendu un produit :
SELECT v.id_vendeur, v.nom_vendeur, v.prenom_vendeur
FROM vendeur v
LEFT JOIN ticket t ON v.id_vendeur = t.id_vendeur
LEFT JOIN produit_ticket pt ON t.id_ticket = pt.id_ticket
WHERE pt.id_ticket IS NULL;

-- 3. Afficher les 3 produits qui sont le plus vendus :
SELECT p.id_produit, p.nom_produit, SUM(pt.quantite) AS total_quantite
FROM produit p
JOIN produit_ticket pt ON p.id_produit = pt.id_produit
GROUP BY p.id_produit, p.nom_produit
ORDER BY total_quantite DESC
LIMIT 3;


-- Exercice agrégation  :
--Réaliser les requêtes suivantes :

-- 1) Afficher le chiffre d'affaire global (tous les tickets) avec le montant TTC

-- On additionne le chiffre d'affaires de tous les produits vendus (quantité × tarif × 1.2).
--- ROUND(..., 2) permet d’arrondir le résultat à 2 décimales, pour obtenir un format classique
SELECT ROUND(SUM(pt.quantite * p.tarif * 1.2), 2) AS chiffre_affaire_ttc_global
FROM produit_ticket pt
JOIN produit p ON pt.id_produit = p.id_produit;

-- 2) Afficher tous les tickets avec : date_creation, le montant TTC du ticket,
SELECT t.id_ticket, t.date_creation,
ROUND(SUM(pt.quantite * p.tarif * 1.2), 2) AS montant_ttc_ticket
FROM ticket t 
JOIN produit_ticket pt ON t.id_ticket = pt.id_ticket
JOIN produit p ON pt.id_produit = p.id_produit
GROUP BY T.id_ticket, t.date_creation;

--3) Afficher le ticket 1 avec le nom_produit, quantite, sous-total (quantitetarif*),
SELECT p.nom_produit, pt.quantite,
ROUND(pt.quantite * p.tarif, 2) AS sous_total
FROM produit_ticket pt
JOIN produit p ON pt.id_produit = p.id_produit
WHERE pt.id_ticket = 1;


-- 4) Afficher le chiffre d'affaire par année en affichant : année, montant du chiffre affaire,
SELECT YEAR(t.date_creation) AS annee,
ROUND(SUM(pt.quantite * p.tarif * 1.2), 2) AS chiffre_affaire_annuel 
FROM ticket t 
JOIN produit p ON t.id_produit = pt.id_ticket
JOIN produit p ON pt.id_produit = p.id_produit
GROUP BY  YEAR(t.date_creation)
ORDER BY annee;

-- 5) Afficher le vendeur qui à réalisé le chiffre d'affaire le plus important avec : nom_vendeur, prenom_vendeur, chiffre affaire,
SELECT v.nom_vendeur, v.prenom_vendeur,
ROUND(SUM(pt.quentite * p.tarif *1.2), 2) AS chiffre_affaire
FROM vendeur v
JOIN ticket t ON v.id_vendeur = t.id_vendeur
JOIN produit_ticket pt ON t.id_ticket = pt.id_ticket
JOIN produit p ON pt.id_produit = p.id_produit
GROUP BY v.id_vendeur, v.nom_vendeur, v.prenom_vendeur
ORDER BY chiffre_affaire DESC
LIMIT 1;

--6) Afficher les 3 produits qui sont le plus vendus avec nom_produit, nom_categorie, le chiffre d'affaire du produit,
SELECT p.nom_produit, c.nom_categorie,
ROUND(SUM(pt.quantite * p.tarif * 1.2), 2) AS chiffre_affaire_produit
FROM produit p 
IN produit_ticlet pt ON p.id_produit = pt.id_produit
IN categorie c ON p.id_categorie = c.id.categorie
GROUP BY P.id_produit, p.nom_produit, c.nom_categorie
ORDER BY chiffre_affaire_produit DESC
LIMIT 3;

--- 7) Afficher par catégorie le chiffre d'affaire avec : nom_categorie, le montant TTC du chiffre d'affaire de la catégorie.
SELECT c.nom_categorie, 
ROUND(SUM(pt.quantite * p.tarif * 1.2), 2) AS chiffre_affaire_categorie
FROM categorie c
JOIN produit p ON c.ID_categorie = p.id_categorie
Join produit_ticket pt ON p.id_produit = pt.id_produit
GROUP BY c.id_categorie, c.nom_categorie;





