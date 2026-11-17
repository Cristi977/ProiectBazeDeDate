-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Gazdă: 127.0.0.1
-- Timp de generare: nov. 17, 2026 la 03:03 PM
-- Versiune server: 10.4.32-MariaDB
-- Versiune PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Bază de date: `sistem_productie`
--

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `comenzi`
--

CREATE TABLE `comenzi` (
  `ID_Comanda` int(11) NOT NULL,
  `Client` varchar(255) NOT NULL,
  `Data_Inregistrare` date NOT NULL,
  `Termen_Limita` date NOT NULL,
  `Stare` varchar(50) NOT NULL DEFAULT 'Asteptare' CHECK (`Stare` in ('Asteptare','Productie','Livrata'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `detalii_comanda`
--

CREATE TABLE `detalii_comanda` (
  `ID_Comanda` int(11) NOT NULL,
  `ID_Produs` int(11) NOT NULL,
  `Cantitate_Comandata` int(11) NOT NULL,
  `Pret_Unitate` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `pasi_prelucrare`
--

CREATE TABLE `pasi_prelucrare` (
  `ID_Pas` int(11) NOT NULL,
  `ID_Produs` int(11) NOT NULL,
  `Ordine_Executie` int(11) NOT NULL,
  `Nume_Proces` varchar(255) NOT NULL,
  `Timp_Standard` decimal(10,2) DEFAULT NULL,
  `Pret_Ora_Standard` decimal(10,2) DEFAULT NULL,
  `Masina` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `productie`
--

CREATE TABLE `productie` (
  `ID_Productie` int(11) NOT NULL,
  `ID_Comanda` int(11) NOT NULL,
  `ID_Produs` int(11) NOT NULL,
  `ID_Pas_Curent` int(11) NOT NULL,
  `Rebuturi` int(11) DEFAULT 0,
  `Timp_Prelucrare` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `produse`
--

CREATE TABLE `produse` (
  `ID_Produs` int(11) NOT NULL,
  `Nume` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `receptie`
--

CREATE TABLE `receptie` (
  `ID_Receptie` int(11) NOT NULL,
  `ID_Comanda` int(11) NOT NULL,
  `ID_Produs` int(11) NOT NULL,
  `Cantitate` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structură tabel pentru tabel `stoc`
--

CREATE TABLE `stoc` (
  `ID_Produs` int(11) NOT NULL,
  `Cantitate` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexuri pentru tabele eliminate
--

--
-- Indexuri pentru tabele `comenzi`
--
ALTER TABLE `comenzi`
  ADD PRIMARY KEY (`ID_Comanda`);

--
-- Indexuri pentru tabele `detalii_comanda`
--
ALTER TABLE `detalii_comanda`
  ADD PRIMARY KEY (`ID_Comanda`,`ID_Produs`),
  ADD KEY `ID_Produs` (`ID_Produs`);

--
-- Indexuri pentru tabele `pasi_prelucrare`
--
ALTER TABLE `pasi_prelucrare`
  ADD PRIMARY KEY (`ID_Pas`),
  ADD KEY `ID_Produs` (`ID_Produs`);

--
-- Indexuri pentru tabele `productie`
--
ALTER TABLE `productie`
  ADD PRIMARY KEY (`ID_Productie`),
  ADD KEY `ID_Comanda` (`ID_Comanda`),
  ADD KEY `ID_Produs` (`ID_Produs`),
  ADD KEY `ID_Pas_Curent` (`ID_Pas_Curent`);

--
-- Indexuri pentru tabele `produse`
--
ALTER TABLE `produse`
  ADD PRIMARY KEY (`ID_Produs`);

--
-- Indexuri pentru tabele `receptie`
--
ALTER TABLE `receptie`
  ADD PRIMARY KEY (`ID_Receptie`),
  ADD KEY `ID_Comanda` (`ID_Comanda`),
  ADD KEY `ID_Produs` (`ID_Produs`);

--
-- Indexuri pentru tabele `stoc`
--
ALTER TABLE `stoc`
  ADD PRIMARY KEY (`ID_Produs`);

--
-- AUTO_INCREMENT pentru tabele eliminate
--

--
-- AUTO_INCREMENT pentru tabele `comenzi`
--
ALTER TABLE `comenzi`
  MODIFY `ID_Comanda` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `pasi_prelucrare`
--
ALTER TABLE `pasi_prelucrare`
  MODIFY `ID_Pas` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `productie`
--
ALTER TABLE `productie`
  MODIFY `ID_Productie` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `produse`
--
ALTER TABLE `produse`
  MODIFY `ID_Produs` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pentru tabele `receptie`
--
ALTER TABLE `receptie`
  MODIFY `ID_Receptie` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constrângeri pentru tabele eliminate
--

--
-- Constrângeri pentru tabele `detalii_comanda`
--
ALTER TABLE `detalii_comanda`
  ADD CONSTRAINT `detalii_comanda_ibfk_1` FOREIGN KEY (`ID_Comanda`) REFERENCES `comenzi` (`ID_Comanda`) ON DELETE CASCADE,
  ADD CONSTRAINT `detalii_comanda_ibfk_2` FOREIGN KEY (`ID_Produs`) REFERENCES `produse` (`ID_Produs`);

--
-- Constrângeri pentru tabele `pasi_prelucrare`
--
ALTER TABLE `pasi_prelucrare`
  ADD CONSTRAINT `pasi_prelucrare_ibfk_1` FOREIGN KEY (`ID_Produs`) REFERENCES `produse` (`ID_Produs`) ON DELETE CASCADE;

--
-- Constrângeri pentru tabele `productie`
--
ALTER TABLE `productie`
  ADD CONSTRAINT `productie_ibfk_1` FOREIGN KEY (`ID_Comanda`) REFERENCES `comenzi` (`ID_Comanda`) ON DELETE CASCADE,
  ADD CONSTRAINT `productie_ibfk_2` FOREIGN KEY (`ID_Produs`) REFERENCES `produse` (`ID_Produs`),
  ADD CONSTRAINT `productie_ibfk_3` FOREIGN KEY (`ID_Pas_Curent`) REFERENCES `pasi_prelucrare` (`ID_Pas`);

--
-- Constrângeri pentru tabele `receptie`
--
ALTER TABLE `receptie`
  ADD CONSTRAINT `receptie_ibfk_1` FOREIGN KEY (`ID_Comanda`) REFERENCES `comenzi` (`ID_Comanda`),
  ADD CONSTRAINT `receptie_ibfk_2` FOREIGN KEY (`ID_Produs`) REFERENCES `produse` (`ID_Produs`);

--
-- Constrângeri pentru tabele `stoc`
--
ALTER TABLE `stoc`
  ADD CONSTRAINT `stoc_ibfk_1` FOREIGN KEY (`ID_Produs`) REFERENCES `produse` (`ID_Produs`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
