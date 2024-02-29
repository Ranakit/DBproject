DROP SCHEMA IF EXISTS asl;
CREATE SCHEMA asl;
USE asl;

CREATE TABLE Paziente (
    CodiceTesseraSanitaria CHAR(20) PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    Cognome VARCHAR(45) NOT NULL,
    DataNascita DATE NOT NULL,
    LuogoNascita VARCHAR(45) NOT NULL,
    Indirizzo VARCHAR(45) NOT NULL
);
	
CREATE TABLE Cellulare (
    Cellulare VARCHAR(15) NOT NULL,
    Paziente_CodiceTesseraSanitaria CHAR(20) NOT NULL,
    PRIMARY KEY (Cellulare, Paziente_CodiceTesseraSanitaria),
    FOREIGN KEY (Paziente_CodiceTesseraSanitaria) REFERENCES Paziente(CodiceTesseraSanitaria)
);
    
CREATE TABLE Telefono (
    Telefono VARCHAR(15) NOT NULL,
    Paziente_CodiceTesseraSanitaria CHAR(20) NOT NULL,
    PRIMARY KEY (Telefono, Paziente_CodiceTesseraSanitaria),
    FOREIGN KEY (Paziente_CodiceTesseraSanitaria) REFERENCES Paziente(CodiceTesseraSanitaria)
);

CREATE TABLE Email (
    Email VARCHAR(45) NOT NULL,
    Paziente_CodiceTesseraSanitaria CHAR(20) NOT NULL,
    PRIMARY KEY (Email, Paziente_CodiceTesseraSanitaria),
    FOREIGN KEY (Paziente_CodiceTesseraSanitaria) REFERENCES Paziente(CodiceTesseraSanitaria)
);

CREATE TABLE Esame (
    CodiceEsame INT AUTO_INCREMENT PRIMARY KEY,
    Descrizione VARCHAR(45) NOT NULL UNIQUE
    );

CREATE TABLE Personale (
    CodiceFiscale CHAR(16) PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    Cognome VARCHAR(45) NOT NULL
);

CREATE TABLE EsamiSvolti (
    Esame_CodiceEsame INT NOT NULL,
    Personale_CodiceFiscale CHAR(16) NOT NULL,
    FOREIGN KEY (Esame_CodiceEsame) REFERENCES Esame(CodiceEsame),
    FOREIGN KEY (Personale_CodiceFiscale) REFERENCES Personale(CodiceFiscale)
);

CREATE TABLE Laboratorio (
    CodiceLaboratorio INT GENERATED ALWAYS AS (CONCAT(Piano, NumeroAula)) STORED NOT NULL,
    Ospedale VARCHAR(45) NOT NULL,
    NumeroAula INT NOT NULL,
    Piano INT NOT NULL,
    Primario CHAR(16) NOT NULL,
    PRIMARY KEY (CodiceLaboratorio, Ospedale),
    FOREIGN KEY (Primario) REFERENCES Personale(CodiceFiscale)
);

CREATE TABLE Prenotazione (
    CodicePrenotazione INT,
    DataOra DATETIME NOT NULL,
    Esame_CodiceEsame INT NOT NULL,
    Costo DECIMAL(4,2) NOT NULL,
    Urgenza BOOLEAN NOT NULL,
    Laboratorio_CodiceLaboratorio INT NOT NULL,
    Laboratorio_Ospedale VARCHAR(45) NOT NULL,
    Paziente_CodiceTesseraSanitaria CHAR(20) NOT NULL,
    PRIMARY KEY(CodicePrenotazione, DataOra, Esame_CodiceEsame),
    FOREIGN KEY (Esame_CodiceEsame) REFERENCES Esame(CodiceEsame),
    FOREIGN KEY (Laboratorio_CodiceLaboratorio, Laboratorio_Ospedale) REFERENCES Laboratorio(CodiceLaboratorio, Ospedale),
    FOREIGN KEY (Paziente_CodiceTesseraSanitaria) REFERENCES Paziente(CodiceTesseraSanitaria)
);

CREATE TABLE Risultato (
    Nome VARCHAR(45) NOT NULL,
    Prenotazione_DataOra DATETIME NOT NULL,
    Prenotazione_CodicePrenotazione INT NOT NULL,
    Prenotazione_Esame_CodiceEsame INT NOT NULL,
    Valore DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (Nome, Prenotazione_DataOra, Prenotazione_CodicePrenotazione, Prenotazione_Esame_CodiceEsame),
    FOREIGN KEY (Prenotazione_CodicePrenotazione, Prenotazione_DataOra, Prenotazione_Esame_CodiceEsame) REFERENCES Prenotazione(CodicePrenotazione, DataOra, Esame_CodiceEsame)
);

CREATE TABLE Diagnosi (
   Prenotazione_DataOra DATETIME NOT NULL,
   Prenotazione_CodicePrenotazione INT NOT NULL,
   Prenotazione_Esame_CodiceEsame INT NOT NULL,
   Testo VARCHAR(500) NOT NULL,
   PRIMARY KEY (Prenotazione_DataOra, Prenotazione_CodicePrenotazione, Prenotazione_Esame_CodiceEsame),
   FOREIGN KEY (Prenotazione_CodicePrenotazione, Prenotazione_DataOra, Prenotazione_Esame_CodiceEsame) REFERENCES Prenotazione(CodicePrenotazione, DataOra, Esame_CodiceEsame)
);

CREATE TABLE Utente (
    Username VARCHAR(16) PRIMARY KEY,
    Passwd CHAR(10) NOT NULL,
    Ruolo ENUM('CUP', 'AM', 'PM') NOT NULL
);
    
DELIMITER //
        
CREATE PROCEDURE registra_paziente (in var_codiceTesseraSanitaria CHAR(20), in var_nome VARCHAR(45), in var_cognome VARCHAR(45), 
in var_dataNascita DATETIME, in var_luogoNascita VARCHAR(45), in var_indirizzo VARCHAR(45))
	BEGIN
		INSERT INTO Paziente (CodiceTesseraSanitaria, Nome, Cognome, DataNascita, LuogoNascita, Indirizzo) 
		VALUES (var_codiceTesseraSanitaria, var_nome, var_cognome, var_dataNascita, var_luogoNascita, var_indirizzo);
	END//
    
DELIMITER ;

DELIMITER //
        
CREATE PROCEDURE registra_email (in var_email VARCHAR(45), in var_codiceTesseraSanitaria CHAR(20))
	BEGIN
		INSERT INTO Email (Email, Paziente_CodiceTesseraSanitaria) 
		VALUES (var_email, var_codiceTesseraSanitaria);
	END//
    
DELIMITER ;

DELIMITER //
        
CREATE PROCEDURE registra_telefono (in var_telefono VARCHAR(15), in var_codiceTesseraSanitaria CHAR(20))
	BEGIN
		INSERT INTO Telefono (Telefono, Paziente_CodiceTesseraSanitaria) 
		VALUES (var_telefono, var_codiceTesseraSanitaria);
	END//
    
DELIMITER ;

DELIMITER //
        
CREATE PROCEDURE registra_cellulare (in var_cellulare VARCHAR(15), in var_codiceTesseraSanitaria CHAR(20))
	BEGIN
		INSERT INTO Cellulare (Cellulare, Paziente_CodiceTesseraSanitaria) 
		VALUES (var_cellulare, var_codiceTesseraSanitaria);
	END//
    
DELIMITER ;

DELIMITER //

CREATE PROCEDURE lista_esami ()
	BEGIN
		SELECT * 
		FROM Esame;
	END//
    
DELIMITER ;

CREATE FUNCTION codice_laboratorio_disponibile(var_dataOra DATETIME) RETURNS CHAR(3) DETERMINISTIC
	RETURN 
    (SELECT CodiceLaboratorio
		FROM Laboratorio AS L
		WHERE NOT EXISTS (
			SELECT 1
			FROM Prenotazione AS P
			WHERE P.Laboratorio_CodiceLaboratorio = L.CodiceLaboratorio AND P.Laboratorio_Ospedale = L.Ospedale AND P.DataOra = var_dataOra
		)
        LIMIT 1
	);
    
CREATE FUNCTION ospedale_laboratorio_disponibile(var_dataOra DATETIME) RETURNS VARCHAR(45) DETERMINISTIC
	RETURN 
    (SELECT Ospedale
		FROM Laboratorio AS L
		WHERE NOT EXISTS (
			SELECT 1
			FROM Prenotazione AS P
			WHERE P.Laboratorio_CodiceLaboratorio = L.CodiceLaboratorio AND P.Laboratorio_Ospedale = L.Ospedale AND P.DataOra = var_dataOra
		)
        LIMIT 1
	);
    
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE registra_prenotazione(in var_codicePrenotazione INT, in var_dataOra DATETIME, in var_codiceEsame INT, in var_costo DECIMAL(4,2), 
in var_urgenza BOOLEAN, in var_paziente CHAR(20))
	BEGIN
		declare exit handler for sqlexception
		begin
			rollback;
			resignal;
		end;
        
		set transaction isolation level serializable;
		start transaction;
			INSERT INTO Prenotazione (CodicePrenotazione, DataOra, Esame_CodiceEsame, Costo, Urgenza, Laboratorio_CodiceLaboratorio, Laboratorio_Ospedale, Paziente_CodiceTesseraSanitaria)
			VALUES (var_codicePrenotazione, var_dataOra, var_codiceEsame, var_costo, var_urgenza, codice_laboratorio_disponibile(var_dataOra), ospedale_laboratorio_disponibile(var_dataOra), var_paziente);
		commit;
	END$$

DELIMITER ;

DELIMITER //

CREATE PROCEDURE login (in var_username varchar(16), in var_pass CHAR(10), out var_role INT)
	BEGIN
		declare var_user_role ENUM('AM', 'CUP', 'PM');
         SELECT Ruolo from Utente
			where Username = var_username
			and Passwd = var_pass
			into var_user_role;
		if var_user_role = 'AM' then
			set var_role = 1;
		elseif var_user_role = 'CUP' then
			set var_role = 2;
		elseif var_user_role = 'PM' then
			set var_role = 3;
		else
			set var_role = 4;
		end if;
	END//
    
DELIMITER ;

DELIMITER //

CREATE PROCEDURE report_prenotazioni(in var_codicePrenotazione INT)
	BEGIN
		declare exit handler for sqlexception
		begin
			rollback;
			resignal;
		end;
        
		set transaction isolation level read committed;
        set transaction read only;
		start transaction;
			SELECT Nome, Valore
				FROM Risultato
				WHERE Prenotazione_CodicePrenotazione = var_codicePrenotazione;
		commit;
	END//
    
DELIMITER ;

DELIMITER //

CREATE PROCEDURE storico_esami(in var_tesseraSanitaria CHAR(20))
BEGIN
     declare exit handler for sqlexception
		begin
			rollback;
			resignal;
		end;
        
		set transaction isolation level read committed;
        set transaction read only;
        start transaction;
			SELECT P.DataOra, P.Esame_CodiceEsame, E.Descrizione, P.Costo, P.Urgenza
				FROM Prenotazione AS P
				JOIN Esame AS E ON P.Esame_CodiceEsame = E.CodiceEsame
			WHERE P.Paziente_CodiceTesseraSanitaria = var_tesseraSanitaria AND EXISTS (
				SELECT 1
				FROM Risultato AS R
				WHERE R.Prenotazione_CodicePrenotazione = P.CodicePrenotazione AND R.Prenotazione_DataOra = P.DataOra AND R.Prenotazione_Esame_CodiceEsame = P.Esame_CodiceEsame
			);
		commit;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE registra_esame(in var_descrizione VARCHAR(45))
	BEGIN
		INSERT INTO Esame(Descrizione)
        VALUES (var_descrizione);
	END//
    
DELIMITER ;

DELIMITER //

CREATE PROCEDURE report_personale_annuale()
	BEGIN	
		SELECT 
			Personale_CodiceFiscale, 
			YEAR(DataOra) AS Anno, 
			COUNT(*) AS NumeroEsami
		FROM Prenotazione
			JOIN EsamiSvolti ON Prenotazione.Esame_CodiceEsame = EsamiSvolti.Esame_CodiceEsame
		GROUP BY Personale_CodiceFiscale, YEAR(DataOra)
		ORDER BY Personale_CodiceFiscale, Anno;
	END//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE report_personale_mensile()
	BEGIN	
		SELECT 
			Personale_CodiceFiscale, 
			YEAR(DataOra) AS Anno, 
			MONTH(DataOra) AS Mese, 
			COUNT(*) AS NumeroEsami
		FROM Prenotazione
			JOIN EsamiSvolti ON Prenotazione.Esame_CodiceEsame = EsamiSvolti.Esame_CodiceEsame
		GROUP BY Personale_CodiceFiscale, YEAR(DataOra), MONTH(DataOra)
		ORDER BY Personale_CodiceFiscale, Anno, Mese;
	END//
    
DELIMITER ;

DELIMITER //

CREATE PROCEDURE registra_risultato(in var_codicePrenotazione INT, in var_dataOra DATETIME, in var_codiceEsame INT, in var_nome VARCHAR(45), in var_valore DECIMAL(5,2))
	BEGIN
		declare exit handler for sqlexception
		begin
			rollback;
			resignal;
		end;
		start transaction;
        INSERT INTO Risultato (Nome, Prenotazione_DataOra, Prenotazione_CodicePrenotazione, Prenotazione_Esame_CodiceEsame, Valore)
		VALUES (var_nome, var_dataOra, var_codicePrenotazione, var_codiceEsame, var_valore);
        commit;
	END//
    
DELIMITER ;

DELIMITER //

CREATE PROCEDURE registra_diagnosi(in var_testo VARCHAR(500), in var_dataOra DATETIME, in var_codicePrenotazione INT, in var_codiceEsame INT)
	BEGIN
        INSERT INTO Diagnosi (Testo, Prenotazione_DataOra, Prenotazione_CodicePrenotazione, Prenotazione_Esame_CodiceEsame)
		VALUES (var_testo, var_dataOra, var_codicePrenotazione, var_codiceEsame);
	END//
    
DELIMITER ;

DELIMITER //

CREATE PROCEDURE esami_svolti(in var_codiceEsame INT, in var_codiceFiscale CHAR(16))
	BEGIN 
    	declare exit handler for sqlexception
		begin
			rollback;
			resignal;
		end;
		start transaction;
			INSERT INTO EsamiSvolti(Esame_CodiceEsame, Personale_CodiceFiscale)
			VALUES(var_codiceEsame, var_codiceFiscale);
		commit;
	END//

DELIMITER ;
    
CREATE INDEX idx_paziente_tessera
ON Prenotazione (Paziente_CodiceTesseraSanitaria);

DELIMITER //

CREATE TRIGGER verifica_paziente_prenotazione
BEFORE INSERT ON Prenotazione
FOR EACH ROW
BEGIN
    DECLARE prenotazioni INT;
    SELECT COUNT(*) INTO prenotazioni
    FROM Prenotazione
    WHERE CodicePrenotazione = NEW.CodicePrenotazione AND Paziente_CodiceTesseraSanitaria != NEW.Paziente_CodiceTesseraSanitaria;
    IF prenotazioni > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un codice di prenotazione può essere associato ad un solo paziente';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER verifica_prenotazione
BEFORE INSERT ON Prenotazione
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Prenotazione
        WHERE Paziente_CodiceTesseraSanitaria = NEW.Paziente_CodiceTesseraSanitaria AND Esame_CodiceEsame = NEW.Esame_CodiceEsame AND DATE(DataOra) = DATE(NEW.DataOra)
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un paziente non può prenotare lo stesso esame più volte nello stesso giorno';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER doppia_prenotazione
BEFORE INSERT ON Prenotazione
FOR EACH ROW
BEGIN
    DECLARE prenotazioni INT;
    SELECT COUNT(*) INTO prenotazioni
    FROM Prenotazione
    WHERE DataOra = NEW.DataOra AND Paziente_CodiceTesseraSanitaria = NEW.Paziente_CodiceTesseraSanitaria;
    IF prenotazioni > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un paziente non può prenotare più esami alla stessa ora';
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER verifica_data_prenotazione
BEFORE INSERT ON Prenotazione
FOR EACH ROW
BEGIN
    IF NEW.DataOra <= NOW() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La data e l''ora della prenotazione devono essere successive a quella in cui la prenotazione viene registrata';
    END IF;
END //

DELIMITER ;

DROP USER IF EXISTS login, CUP, amministratore, medico;
CREATE USER login IDENTIFIED BY 'login';
CREATE USER CUP IDENTIFIED BY 'personaleCUP';
CREATE USER amministratore IDENTIFIED BY 'amministratore';
CREATE USER medico IDENTIFIED BY 'medico';

GRANT ALL PRIVILEGES ON asl TO CUP, amministratore, medico, login;

GRANT EXECUTE ON PROCEDURE login TO login;
GRANT EXECUTE ON PROCEDURE registra_paziente TO CUP;
GRANT EXECUTE ON PROCEDURE registra_email TO CUP;
GRANT EXECUTE ON PROCEDURE registra_telefono TO CUP;
GRANT EXECUTE ON PROCEDURE registra_cellulare TO CUP;
GRANT EXECUTE ON PROCEDURE lista_esami TO CUP;
GRANT EXECUTE ON PROCEDURE registra_prenotazione TO CUP;
GRANT EXECUTE ON PROCEDURE report_prenotazioni TO CUP;
GRANT EXECUTE ON PROCEDURE storico_esami TO CUP;
GRANT EXECUTE ON PROCEDURE registra_esame TO amministratore;
GRANT EXECUTE ON PROCEDURE report_personale_annuale TO amministratore;
GRANT EXECUTE ON PROCEDURE report_personale_mensile TO amministratore;
GRANT EXECUTE ON PROCEDURE registra_risultato TO medico;
GRANT EXECUTE ON PROCEDURE registra_diagnosi TO medico;
GRANT EXECUTE ON PROCEDURE esami_svolti TO medico;

FLUSH PRIVILEGES;

INSERT INTO Personale (CodiceFiscale, Nome, Cognome)
VALUES
('CF00000000000001', 'Mario', 'Rossi'),
('CF00000000000002', 'Giuseppe', 'Verdi'),
('CF00000000000003', 'Luigi', 'Bianchi'),
('CF00000000000004', 'Francesco', 'Romano'),
('CF00000000000005', 'Antonio', 'Ricci'),
('CF00000000000006', 'Giovanni', 'Ferrari'),
('CF00000000000007', 'Angelo', 'Esposito'),
('CF00000000000008', 'Roberto', 'Conti'),
('CF00000000000009', 'Paolo', 'Vitale'),
('CF00000000000010', 'Marco', 'Rizzo'),
('CF00000000000011', 'Paolo', 'Conti'),
('CF00000000000012', 'Mario', 'Rossi'),
('CF00000000000013', 'Giuseppe', 'Verdi'),
('CF00000000000014', 'Luigi', 'Bianchi'),
('CF00000000000015', 'Francesco', 'Romano'),
('CF00000000000016', 'Antonio', 'Ricci'),
('CF00000000000017', 'Giovanni', 'Ferrari'),
('CF00000000000018', 'Angelo', 'Esposito'),
('CF00000000000019', 'Roberto', 'Conti'),
('CF00000000000020', 'Paolo', 'Vitale'),
('CF00000000000021', 'Marco', 'Rizzo'),
('CF00000000000022', 'Paolo', 'Conti'),
('CF00000000000023', 'Mario', 'Rossi'),
('CF00000000000024', 'Giuseppe', 'Verdi'),
('CF00000000000025', 'Luigi', 'Bianchi'),
('CF00000000000026', 'Francesco', 'Romano'),
('CF00000000000027', 'Antonio', 'Ricci'),
('CF00000000000028', 'Giovanni', 'Ferrari'),
('CF00000000000029', 'Angelo', 'Esposito'),
('1234567890123456', 'Giuseppe', 'Verdi'),
('CF00000000000030', 'Roberto', 'Conti');

INSERT INTO Laboratorio (Ospedale, NumeroAula, Piano, Primario)
VALUES
('Ospedale 1', 01, 1, 'CF00000000000001'),
('Ospedale 1', 02, 1, 'CF00000000000002'),
('Ospedale 1', 03, 1, 'CF00000000000003'),
('Ospedale 1', 04, 2, 'CF00000000000004'),
('Ospedale 1', 05, 2, 'CF00000000000005'),
('Ospedale 1', 06, 2, 'CF00000000000006'),
('Ospedale 1', 07, 3, 'CF00000000000007'),
('Ospedale 1', 08, 3, 'CF00000000000008'),
('Ospedale 1', 09, 3, 'CF00000000000009'),
('Ospedale 1', 10, 4, 'CF00000000000010'),
('Ospedale 2', 01, 1, 'CF00000000000011'),
('Ospedale 2', 02, 1, 'CF00000000000012'),
('Ospedale 2', 03, 1, 'CF00000000000013'),
('Ospedale 2', 04, 2, 'CF00000000000014'),
('Ospedale 2', 05, 2, 'CF00000000000015'),
('Ospedale 2', 06, 2, 'CF00000000000016'),
('Ospedale 2', 07, 3, 'CF00000000000017'),
('Ospedale 2', 08, 3, 'CF00000000000018'),
('Ospedale 2', 09, 3, 'CF00000000000019'),
('Ospedale 2' ,10 ,4 ,'CF00000000000020');

INSERT INTO Paziente (CodiceTesseraSanitaria, Nome, Cognome, DataNascita, LuogoNascita, Indirizzo)
VALUES
('TS000000000000000001', 'Mario', 'Rossi', '1990-01-01', 'Roma', 'Via Roma 1'),
('TS000000000000000002', 'Giuseppe', 'Verdi', '1991-02-02', 'Milano', 'Via Milano 2'),
('TS000000000000000003', 'Luigi', 'Bianchi', '1992-03-03', 'Napoli', 'Via Napoli 3'),
('TS000000000000000004', 'Francesco', 'Romano', '1993-04-04', 'Torino', 'Via Torino 4'),
('TS000000000000000005', 'Antonio', 'Ricci', '1994-05-05', 'Palermo', 'Via Palermo 5'),
('TS000000000000000006', 'Giovanni', 'Ferrari', '1995-06-06', 'Genova', 'Via Genova 6'),
('TS000000000000000007', 'Angelo', 'Esposito', '1996-07-07', 'Bologna', 'Via Bologna 7'),
('TS000000000000000008', 'Mario', 'Rossi', '1990-01-01', 'Roma', 'Via Roma 1'),
('TS000000000000000009', 'Giuseppe', 'Verdi', '1991-02-02', 'Milano', 'Via Milano 2'),
('TS000000000000000010', 'Luigi', 'Bianchi', '1992-03-03', 'Napoli', 'Via Napoli 3'),
('TS000000000000000011', 'Francesco', 'Romano', '1993-04-04', 'Torino', 'Via Torino 4'),
('TS000000000000000013', 'Antonio', 'Ricci', '1994-05-05', 'Palermo', 'Via Palermo 5'),
('TS000000000000000014', 'Giovanni', 'Ferrari', '1995-06-06', 'Genova', 'Via Genova 6'),
('TS000000000000000015', 'Angelo', 'Esposito', '1996-07-07', 'Bologna', 'Via Bologna 7');

INSERT INTO Cellulare (Paziente_CodiceTesseraSanitaria, Cellulare)
VALUES
('TS000000000000000001', '1234567890'),
('TS000000000000000002', '1234567890'),
('TS000000000000000003', '3456789012'),
('TS000000000000000004', '4567890123'),
('TS000000000000000005', '5678901234'),
('TS000000000000000006', '6789012345'),
('TS000000000000000007', '7890123456'),
('TS000000000000000008', '8901234567'),
('TS000000000000000009', '9012345678'),
('TS000000000000000010', '0123456789'),
('TS000000000000000011', '1357924680'),
('TS000000000000000013', '2468013579'),
('TS000000000000000014', '3579246801'),
('TS000000000000000015', '4680135792');


INSERT INTO Esame (Descrizione)
VALUES
('Esame del sangue'),
('Radiografia'),
('Ecografia'),
('Risonanza magnetica'),
('Tomografia computerizzata'),
('Elettrocardiogramma'),
('Esame delle urine'),
('Biopsia'),
('Endoscopia'),
('Mammografia'),
('Esame del liquido cefalorachidiano'),
('Esame del midollo osseo'),
('Esame del tessuto muscolare'),
('Esame del tessuto nervoso'),
('Esame del tessuto cutaneo'),
('Esame del tessuto adiposo'),
('Esame del tessuto connettivo'),
('Esame del tessuto osseo'),
('Esame del tessuto cartilagineo'),
('Esame del tessuto epiteliale');


INSERT INTO Utente (Username, Passwd, Ruolo)
VALUES
('utente1', 'password1', 'CUP'),
('utente2', 'password2', 'AM'),
('utente3', 'password3', 'PM'),
('utente4', 'password4', 'CUP'),
('utente5', 'password5', 'AM'),
('utente6', 'password6', 'PM'),
('utente7', 'password7', 'CUP'),
('utente8', 'password8', 'AM'),
('utente9', 'password9', 'PM'),
('utente10','passwrd10','CUP'),
('utente11','passwrd11','AM'),
('utente12','passwrd12','PM'),
('utente13','passwrd13','CUP'),
('utente14','passwrd14','AM'),
('utente15','passwrd15','PM'),
('utente16','passwrd16','CUP'),
('utente17','passwrd17','AM'),
('utente18','passwrd18','PM'),
('utente19','passwrd19','CUP'),
('utente20','passwrd20','AM'),
('utente21','passwrd21','PM'),
('utente22','passwrd22','CUP'),
('utente23','passwrd23','AM'),
('utente24','passwrd24','PM'),
('utente25','passwrd25','CUP');

INSERT INTO Prenotazione (CodicePrenotazione, DataOra, Esame_CodiceEsame, Costo, Urgenza, Laboratorio_CodiceLaboratorio, Laboratorio_Ospedale, Paziente_CodiceTesseraSanitaria)
VALUES (1, '2024-11-30 09:00:00', 1, 50.00, false, 11, 'Ospedale 1', 'TS000000000000000001'),
(1, '2023-07-04 20:00:00', 1, 50.00, false, 11, 'Ospedale 1', 'TS000000000000000001'),
(1, '2023-07-05 20:00:00', 1, 50.00, false, 11, 'Ospedale 1', 'TS000000000000000001'),
(1, '2023-07-06 20:00:00', 1, 50.00, false, 11, 'Ospedale 1', 'TS000000000000000001');

INSERT INTO EsamiSvolti (Esame_CodiceEsame, Personale_CodiceFiscale)
VALUES (1, '1234567890123456');

INSERT INTO Risultato (Nome, Prenotazione_DataOra, Prenotazione_CodicePrenotazione, Prenotazione_Esame_CodiceEsame, Valore)
VALUES ('Emoglobina', '2024-11-30 09:00:00', 1, 1, 15.5);

INSERT INTO Diagnosi (Prenotazione_DataOra, Prenotazione_CodicePrenotazione, Prenotazione_Esame_CodiceEsame, Testo)
VALUES ('2024-11-30 09:00:00', 1, 1, 'Tutto nella norma');