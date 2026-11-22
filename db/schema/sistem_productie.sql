DROP DATABASE IF EXISTS `sistem_productie`;
CREATE DATABASE IF NOT EXISTS `sistem_productie`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `sistem_productie`;

SET NAMES utf8mb4;

CREATE TABLE `roluri` (
  `ID_Rol` int(11) NOT NULL AUTO_INCREMENT,
  `Nume` varchar(50) NOT NULL,
  `Descriere` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID_Rol`),
  UNIQUE KEY `uq_roluri_nume` (`Nume`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `utilizatori` (
  `ID_Utilizator` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Rol` int(11) NOT NULL,
  `Nume` varchar(150) NOT NULL,
  `Email` varchar(191) NOT NULL,
  `Parola_Hash` varchar(255) NOT NULL,
  `Activ` tinyint(1) NOT NULL DEFAULT 1,
  `Data_Creare` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID_Utilizator`),
  UNIQUE KEY `uq_utilizatori_email` (`Email`),
  KEY `idx_utilizatori_rol` (`ID_Rol`),
  CONSTRAINT `chk_utilizatori_activ`
    CHECK (`Activ` IN (0, 1)),
  CONSTRAINT `fk_utilizatori_rol`
    FOREIGN KEY (`ID_Rol`)
    REFERENCES `roluri` (`ID_Rol`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `comenzi` (
  `ID_Comanda` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Manager` int(11) NOT NULL,
  `Client` varchar(255) NOT NULL,
  `Data_Inregistrare` date NOT NULL,
  `Termen_Limita` date NOT NULL,
  `Stare` varchar(30) NOT NULL DEFAULT 'Asteptare',
  PRIMARY KEY (`ID_Comanda`),
  KEY `idx_comenzi_manager` (`ID_Manager`),
  CONSTRAINT `chk_comenzi_stare`
    CHECK (`Stare` IN (
      'Asteptare',
      'Productie',
      'Finalizata',
      'Livrata',
      'Anulata'
    )),
  CONSTRAINT `chk_comenzi_date`
    CHECK (`Termen_Limita` >= `Data_Inregistrare`),
  CONSTRAINT `fk_comenzi_manager`
    FOREIGN KEY (`ID_Manager`)
    REFERENCES `utilizatori` (`ID_Utilizator`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `produse` (
  `ID_Produs` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Inginer` int(11) NOT NULL,
  `Cod_Produs` varchar(50) NOT NULL,
  `Nume` varchar(255) NOT NULL,
  `Activ` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`ID_Produs`),
  UNIQUE KEY `uq_produse_cod` (`Cod_Produs`),
  KEY `idx_produse_inginer` (`ID_Inginer`),
  CONSTRAINT `chk_produse_activ`
    CHECK (`Activ` IN (0, 1)),
  CONSTRAINT `fk_produse_inginer`
    FOREIGN KEY (`ID_Inginer`)
    REFERENCES `utilizatori` (`ID_Utilizator`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `materiale` (
  `ID_Material` int(11) NOT NULL AUTO_INCREMENT,
  `Cod_Material` varchar(50) NOT NULL,
  `Nume` varchar(255) NOT NULL,
  `Unitate_Masura` varchar(20) NOT NULL,
  `Prag_Minim` decimal(14,4) NOT NULL DEFAULT 0,
  `Activ` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`ID_Material`),
  UNIQUE KEY `uq_materiale_cod` (`Cod_Material`),
  CONSTRAINT `chk_materiale_prag`
    CHECK (`Prag_Minim` >= 0),
  CONSTRAINT `chk_materiale_activ`
    CHECK (`Activ` IN (0, 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `detalii_comanda` (
  `ID_Comanda` int(11) NOT NULL,
  `ID_Produs` int(11) NOT NULL,
  `Cantitate_Comandata` int(11) NOT NULL,
  `Pret_Unitate` decimal(14,4) NOT NULL,
  PRIMARY KEY (`ID_Comanda`, `ID_Produs`),
  KEY `idx_detalii_produs` (`ID_Produs`),
  CONSTRAINT `chk_detalii_cantitate`
    CHECK (`Cantitate_Comandata` > 0),
  CONSTRAINT `chk_detalii_pret`
    CHECK (`Pret_Unitate` >= 0),
  CONSTRAINT `fk_detalii_comanda`
    FOREIGN KEY (`ID_Comanda`)
    REFERENCES `comenzi` (`ID_Comanda`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_detalii_produs`
    FOREIGN KEY (`ID_Produs`)
    REFERENCES `produse` (`ID_Produs`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `retetar` (
  `ID_Produs` int(11) NOT NULL,
  `ID_Material` int(11) NOT NULL,
  `Cantitate_Standard` decimal(14,4) NOT NULL,
  PRIMARY KEY (`ID_Produs`, `ID_Material`),
  KEY `idx_retetar_material` (`ID_Material`),
  CONSTRAINT `chk_retetar_cantitate`
    CHECK (`Cantitate_Standard` > 0),
  CONSTRAINT `fk_retetar_produs`
    FOREIGN KEY (`ID_Produs`)
    REFERENCES `produse` (`ID_Produs`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_retetar_material`
    FOREIGN KEY (`ID_Material`)
    REFERENCES `materiale` (`ID_Material`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `pasi_prelucrare` (
  `ID_Pas` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Produs` int(11) NOT NULL,
  `Ordine_Executie` int(11) NOT NULL,
  `Nume_Proces` varchar(255) NOT NULL,
  `Timp_Standard` decimal(14,4) NOT NULL,
  `Pret_Ora_Standard` decimal(14,4) NOT NULL,
  `Masina` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID_Pas`),
  UNIQUE KEY `uq_pasi_produs_ordine` (`ID_Produs`, `Ordine_Executie`),
  UNIQUE KEY `uq_pasi_produs_pas` (`ID_Produs`, `ID_Pas`),
  CONSTRAINT `chk_pasi_ordine`
    CHECK (`Ordine_Executie` > 0),
  CONSTRAINT `chk_pasi_timp`
    CHECK (`Timp_Standard` >= 0),
  CONSTRAINT `chk_pasi_tarif`
    CHECK (`Pret_Ora_Standard` >= 0),
  CONSTRAINT `fk_pasi_produs`
    FOREIGN KEY (`ID_Produs`)
    REFERENCES `produse` (`ID_Produs`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `productie` (
  `ID_Productie` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Comanda` int(11) NOT NULL,
  `ID_Produs` int(11) NOT NULL,
  `ID_Pas_Curent` int(11) DEFAULT NULL,
  `Cantitate_Planificata` int(11) NOT NULL,
  `Stare` varchar(30) NOT NULL DEFAULT 'Planificata',
  `Data_Inceput` datetime DEFAULT NULL,
  `Data_Finalizare` datetime DEFAULT NULL,
  PRIMARY KEY (`ID_Productie`),
  UNIQUE KEY `uq_productie_id_produs` (`ID_Productie`, `ID_Produs`),
  UNIQUE KEY `uq_productie_context` (
    `ID_Productie`, `ID_Comanda`, `ID_Produs`
  ),
  KEY `idx_productie_detalii` (`ID_Comanda`, `ID_Produs`),
  KEY `idx_productie_pas` (`ID_Produs`, `ID_Pas_Curent`),
  CONSTRAINT `chk_productie_cantitate`
    CHECK (`Cantitate_Planificata` > 0),
  CONSTRAINT `chk_productie_stare`
    CHECK (`Stare` IN (
      'Planificata',
      'In_lucru',
      'Suspendata',
      'Finalizata',
      'Anulata'
    )),
  CONSTRAINT `chk_productie_date`
    CHECK (
      `Data_Finalizare` IS NULL
      OR (
        `Data_Inceput` IS NOT NULL
        AND `Data_Finalizare` >= `Data_Inceput`
      )
    ),
  CONSTRAINT `fk_productie_detalii`
    FOREIGN KEY (`ID_Comanda`, `ID_Produs`)
    REFERENCES `detalii_comanda` (`ID_Comanda`, `ID_Produs`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_productie_pas`
    FOREIGN KEY (`ID_Produs`, `ID_Pas_Curent`)
    REFERENCES `pasi_prelucrare` (`ID_Produs`, `ID_Pas`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `executii_operatii` (
  `ID_Executie` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Productie` int(11) NOT NULL,
  `ID_Produs` int(11) NOT NULL,
  `ID_Pas` int(11) NOT NULL,
  `ID_Operator` int(11) NOT NULL,
  `Data_Raportare` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Timp_Prelucrare` decimal(14,4) NOT NULL,
  `Tarif_Orar_Aplicat` decimal(14,4) NOT NULL,
  `Cantitate_Buna` int(11) NOT NULL DEFAULT 0,
  `Rebuturi` int(11) NOT NULL DEFAULT 0,
  `Observatii` text DEFAULT NULL,
  PRIMARY KEY (`ID_Executie`),
  KEY `idx_executii_productie` (`ID_Productie`, `ID_Produs`),
  KEY `idx_executii_pas` (`ID_Produs`, `ID_Pas`),
  KEY `idx_executii_operator` (`ID_Operator`),
  CONSTRAINT `chk_executii_timp`
    CHECK (`Timp_Prelucrare` >= 0),
  CONSTRAINT `chk_executii_tarif`
    CHECK (`Tarif_Orar_Aplicat` >= 0),
  CONSTRAINT `chk_executii_bune`
    CHECK (`Cantitate_Buna` >= 0),
  CONSTRAINT `chk_executii_rebuturi`
    CHECK (`Rebuturi` >= 0),
  CONSTRAINT `fk_executii_productie`
    FOREIGN KEY (`ID_Productie`, `ID_Produs`)
    REFERENCES `productie` (`ID_Productie`, `ID_Produs`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_executii_pas`
    FOREIGN KEY (`ID_Produs`, `ID_Pas`)
    REFERENCES `pasi_prelucrare` (`ID_Produs`, `ID_Pas`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_executii_operator`
    FOREIGN KEY (`ID_Operator`)
    REFERENCES `utilizatori` (`ID_Utilizator`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `intrari_materiale` (
  `ID_Intrare` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Material` int(11) NOT NULL,
  `ID_Utilizator` int(11) NOT NULL,
  `Data_Intrare` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Furnizor` varchar(255) DEFAULT NULL,
  `Document_Intrare` varchar(100) DEFAULT NULL,
  `Cantitate` decimal(14,4) NOT NULL,
  `Cost_Unitar` decimal(14,4) NOT NULL,
  PRIMARY KEY (`ID_Intrare`),
  KEY `idx_intrari_material` (`ID_Material`),
  KEY `idx_intrari_utilizator` (`ID_Utilizator`),
  CONSTRAINT `chk_intrari_cantitate`
    CHECK (`Cantitate` > 0),
  CONSTRAINT `chk_intrari_cost`
    CHECK (`Cost_Unitar` >= 0),
  CONSTRAINT `fk_intrari_material`
    FOREIGN KEY (`ID_Material`)
    REFERENCES `materiale` (`ID_Material`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_intrari_utilizator`
    FOREIGN KEY (`ID_Utilizator`)
    REFERENCES `utilizatori` (`ID_Utilizator`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `consum_materiale` (
  `ID_Consum` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Executie` int(11) NOT NULL,
  `ID_Intrare` int(11) NOT NULL,
  `Cantitate_Consumata` decimal(14,4) NOT NULL,
  `Cantitate_Rebut` decimal(14,4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID_Consum`),
  KEY `idx_consum_executie` (`ID_Executie`),
  KEY `idx_consum_intrare` (`ID_Intrare`),
  CONSTRAINT `chk_consum_cantitate`
    CHECK (`Cantitate_Consumata` > 0),
  CONSTRAINT `chk_consum_rebut`
    CHECK (
      `Cantitate_Rebut` >= 0
      AND `Cantitate_Rebut` <= `Cantitate_Consumata`
    ),
  CONSTRAINT `fk_consum_executie`
    FOREIGN KEY (`ID_Executie`)
    REFERENCES `executii_operatii` (`ID_Executie`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_consum_intrare`
    FOREIGN KEY (`ID_Intrare`)
    REFERENCES `intrari_materiale` (`ID_Intrare`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `receptie` (
  `ID_Receptie` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Productie` int(11) NOT NULL,
  `ID_Comanda` int(11) NOT NULL,
  `ID_Produs` int(11) NOT NULL,
  `ID_Utilizator` int(11) NOT NULL,
  `Data_Receptie` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Cantitate` int(11) NOT NULL,
  PRIMARY KEY (`ID_Receptie`),
  KEY `idx_receptie_productie` (
    `ID_Productie`, `ID_Comanda`, `ID_Produs`
  ),
  KEY `idx_receptie_utilizator` (`ID_Utilizator`),
  CONSTRAINT `chk_receptie_cantitate`
    CHECK (`Cantitate` > 0),
  CONSTRAINT `fk_receptie_productie`
    FOREIGN KEY (`ID_Productie`, `ID_Comanda`, `ID_Produs`)
    REFERENCES `productie` (
      `ID_Productie`, `ID_Comanda`, `ID_Produs`
    )
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_receptie_utilizator`
    FOREIGN KEY (`ID_Utilizator`)
    REFERENCES `utilizatori` (`ID_Utilizator`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `stoc` (
  `ID_Produs` int(11) NOT NULL,
  `Cantitate` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID_Produs`),
  CONSTRAINT `chk_stoc_cantitate`
    CHECK (`Cantitate` >= 0),
  CONSTRAINT `fk_stoc_produs`
    FOREIGN KEY (`ID_Produs`)
    REFERENCES `produse` (`ID_Produs`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `gestionare_iesiri` (
  `ID_Iesire` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Comanda` int(11) NOT NULL,
  `ID_Produs` int(11) NOT NULL,
  `ID_Utilizator` int(11) NOT NULL,
  `Data_Iesire` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Cantitate` int(11) NOT NULL,
  `Document_Iesire` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID_Iesire`),
  KEY `idx_iesiri_detalii` (`ID_Comanda`, `ID_Produs`),
  KEY `idx_iesiri_stoc` (`ID_Produs`),
  KEY `idx_iesiri_utilizator` (`ID_Utilizator`),
  CONSTRAINT `chk_iesiri_cantitate`
    CHECK (`Cantitate` > 0),
  CONSTRAINT `fk_iesiri_detalii`
    FOREIGN KEY (`ID_Comanda`, `ID_Produs`)
    REFERENCES `detalii_comanda` (`ID_Comanda`, `ID_Produs`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_iesiri_stoc`
    FOREIGN KEY (`ID_Produs`)
    REFERENCES `stoc` (`ID_Produs`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_iesiri_utilizator`
    FOREIGN KEY (`ID_Utilizator`)
    REFERENCES `utilizatori` (`ID_Utilizator`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `alerte_materiale` (
  `ID_Alerta` int(11) NOT NULL AUTO_INCREMENT,
  `ID_Material` int(11) NOT NULL,
  `ID_Comanda` int(11) DEFAULT NULL,
  `Data_Generare` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Cantitate_Necesara` decimal(14,4) NOT NULL,
  `Cantitate_Disponibila` decimal(14,4) NOT NULL,
  `Stare` varchar(20) NOT NULL DEFAULT 'Activa',
  `Mesaj` varchar(500) NOT NULL,
  `Data_Rezolvare` datetime DEFAULT NULL,
  `ID_Utilizator_Rezolvare` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID_Alerta`),
  KEY `idx_alerte_material_stare` (`ID_Material`, `Stare`),
  KEY `idx_alerte_comanda` (`ID_Comanda`),
  KEY `idx_alerte_utilizator` (`ID_Utilizator_Rezolvare`),
  CONSTRAINT `chk_alerte_necesar`
    CHECK (`Cantitate_Necesara` >= 0),
  CONSTRAINT `chk_alerte_disponibil`
    CHECK (`Cantitate_Disponibila` >= 0),
  CONSTRAINT `chk_alerte_stare`
    CHECK (`Stare` IN ('Activa', 'Rezolvata', 'Anulata')),
  CONSTRAINT `chk_alerte_data`
    CHECK (
      `Data_Rezolvare` IS NULL
      OR `Data_Rezolvare` >= `Data_Generare`
    ),
  CONSTRAINT `fk_alerte_material`
    FOREIGN KEY (`ID_Material`)
    REFERENCES `materiale` (`ID_Material`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_alerte_comanda`
    FOREIGN KEY (`ID_Comanda`)
    REFERENCES `comenzi` (`ID_Comanda`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_alerte_utilizator`
    FOREIGN KEY (`ID_Utilizator_Rezolvare`)
    REFERENCES `utilizatori` (`ID_Utilizator`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;