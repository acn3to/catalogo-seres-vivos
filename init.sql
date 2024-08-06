DROP TABLE IF EXISTS ProgramaProtecaoLocalizacaoGeografica;
DROP TABLE IF EXISTS EspecieLocalizacaoGeografica;
DROP TABLE IF EXISTS ProgramaProtecaoEspecie;
DROP TABLE IF EXISTS DoencaEspecie;
DROP TABLE IF EXISTS BiomaEspecie;
DROP TABLE IF EXISTS HabitatEspecie;
DROP TABLE IF EXISTS HabitoAlimentarEspecie;
DROP TABLE IF EXISTS ReferenciaCientificaEspecie;
DROP TABLE IF EXISTS Predacao;
DROP TABLE IF EXISTS MonitoramentoPopulacao;
DROP TABLE IF EXISTS ProgramaProtecao;
DROP TABLE IF EXISTS HabitoAlimentar;
DROP TABLE IF EXISTS ReferenciaCientifica;
DROP TABLE IF EXISTS VideoEspecie;
DROP TABLE IF EXISTS ImagemEspecie;
DROP TABLE IF EXISTS Doenca;
DROP TABLE IF EXISTS Bioma;
DROP TABLE IF EXISTS Habitat;
DROP TABLE IF EXISTS LocalizacaoGeografica;
DROP TABLE IF EXISTS Especie;
DROP TABLE IF EXISTS Genero;
DROP TABLE IF EXISTS Familia;
DROP TABLE IF EXISTS Ordem;
DROP TABLE IF EXISTS Classe;
DROP TABLE IF EXISTS Filo;
DROP TABLE IF EXISTS Reino;
DROP TABLE IF EXISTS PresencaBacteriana;
DROP TABLE IF EXISTS AmostraSolo;
DROP TABLE IF EXISTS DiversidadeGenetica;
DROP TABLE IF EXISTS MonitoramentoPesticida;
DROP TABLE IF EXISTS MonitoramentoInvertebrados;
DROP TABLE IF EXISTS Pesticida;
DROP TABLE IF EXISTS MortalidadePorDoenca;
DROP TABLE IF EXISTS Especie;
DROP TABLE IF EXISTS Doenca;
DROP TABLE IF EXISTS Localizacao;
DROP TABLE IF EXISTS Bioma;
DROP TABLE IF EXISTS MonitoramentoPopulacao;

DROP TYPE IF EXISTS StatusConservacao;
DROP TYPE IF EXISTS TipoHabitatoAlimentar;
DROP TYPE IF EXISTS TipoDoenca;

CREATE TYPE TipoDoenca AS ENUM (
  'INFEC',
  'PARASITARIA',
  'GENETICA',
  'NUTRICIONAL',
  'OUTRAS'
);

CREATE TYPE TipoHabitoAlimentar AS ENUM (
  'HERBIVORO',
  'CARNIVORO',
  'ONIVORO',
  'DETRETIVORO',
  'INSECTIVORO',
  'FRUGIVORO'
);

CREATE TYPE StatusConservacao AS ENUM (
  'EXTINTA',
  'EXTINTA_NA_NATUREZA',
  'CRITICAMENTE_EM_PERIGO',
  'EM_PERIGO',
  'VULNERAVEL',
  'QUASE_AMEACADA',
  'POUCO_PREOCUPANTE',
  'NAO_AVALIADO'
);

CREATE TABLE Reino (
    id_reino SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    descricao TEXT
);

CREATE TABLE Filo (
    id_filo SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    descricao TEXT,
    id_reino INT NOT NULL REFERENCES Reino(id_reino) ON DELETE CASCADE
);

CREATE TABLE Classe (
    id_classe SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    descricao TEXT,
    id_filo INT NOT NULL REFERENCES Filo(id_filo) ON DELETE CASCADE
);

CREATE TABLE Ordem (
    id_ordem SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    descricao TEXT,
    id_classe INT NOT NULL REFERENCES Classe(id_classe) ON DELETE CASCADE
);

CREATE TABLE Familia (
    id_familia SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    descricao TEXT,
    id_ordem INT NOT NULL REFERENCES Ordem(id_ordem) ON DELETE CASCADE
);

CREATE TABLE Genero (
    id_genero SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    descricao TEXT,
    id_familia INT NOT NULL REFERENCES Familia(id_familia) ON DELETE CASCADE
);

CREATE TABLE Especie (
    id_especie SERIAL PRIMARY KEY,
    nome_cientifico VARCHAR(255) UNIQUE NOT NULL,
    nome_comum VARCHAR(255),
    descricao TEXT,
    status_conservacao StatusConservacao NOT NULL,
    id_genero INT NOT NULL REFERENCES Genero(id_genero) ON DELETE CASCADE,
    comportamento TEXT,
    outras_informacoes JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE LocalizacaoGeografica (
    id_localizacao_geografica SERIAL PRIMARY KEY,
    localizacao GEOMETRY(POLYGON, 4326) NOT NULL,
    descricao TEXT,
    area_protegida BOOLEAN DEFAULT FALSE
);

CREATE TABLE Habitat (
    id_habitat SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    descricao TEXT
);

CREATE TABLE Bioma (
    id_bioma SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    descricao TEXT
);

CREATE TABLE Doenca (
    id_doenca SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    descricao TEXT,
    tipo_doenca TipoDoenca NOT NULL,
    is_transmissivel BOOLEAN DEFAULT FALSE
);

CREATE TABLE ImagemEspecie (
    id_imagem_especie SERIAL PRIMARY KEY,
    url VARCHAR(255) UNIQUE NOT NULL,
    descricao TEXT,
    id_especie INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE VideoEspecie (
    id_video_especie SERIAL PRIMARY KEY,
    url VARCHAR(255) UNIQUE NOT NULL,
    descricao TEXT,
    id_especie INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE ReferenciaCientifica (
    id_referencia_cientifica SERIAL PRIMARY KEY,
    titulo VARCHAR(255) UNIQUE NOT NULL,
    autor VARCHAR(255),
    ano_publicacao INT CHECK (ano_publicacao <= EXTRACT(YEAR FROM CURRENT_DATE)),
    url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE HabitoAlimentar (
    id_habito_alimentar SERIAL PRIMARY KEY,
    tipo_habito TipoHabitoAlimentar NOT NULL,
    descricao TEXT
);

CREATE TABLE ProgramaProtecao (
    id_programa_protecao INT PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    descricao TEXT,
  	medidas_conservacao TEXT
);

CREATE TABLE Predacao (
    id_predacao SERIAL PRIMARY KEY,
    id_especie_predador INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE,
    id_especie_presa INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE,
    descricao TEXT
);

CREATE TABLE AmostraSolo (
    id_amostra_solo SERIAL PRIMARY KEY,
    id_bioma INT NOT NULL REFERENCES Bioma(id_bioma) ON DELETE CASCADE,
    id_localizacao_geografica INT NOT NULL REFERENCES LocalizacaoGeografica(id_localizacao_geografica) ON DELETE CASCADE, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE Pesticida (
    id_pesticida SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    descricao TEXT
);

CREATE TABLE PresencaBacteriana (
    id_amostra_solo INT NOT NULL REFERENCES AmostraSolo(id_amostra_solo) ON DELETE CASCADE,
    id_especie INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE
);

CREATE TABLE MonitoramentoPopulacao (
    id_monitoramento_populacao SERIAL PRIMARY KEY,
    id_especie INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE,
    ano INT NOT NULL,
    quantidade_populacao INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT NULL
);

CREATE TABLE MonitoramentoInvertebrados (
    id_monitoramento_invertebrados SERIAL PRIMARY KEY,
	  id_especie INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE,
    id_localizacao_geografica INT NOT NULL REFERENCES LocalizacaoGeografica(id_localizacao_geografica) ON DELETE CASCADE,
    data_coleta DATE,
    abundancia INT
);

CREATE TABLE MonitoramentoPesticida (
    id_monitoramento_pesticida SERIAL PRIMARY KEY,
    id_pesticida INT NOT NULL REFERENCES Pesticida(id_pesticida) ON DELETE CASCADE,
    id_monitoramento_invertebrados INT NOT NULL REFERENCES MonitoramentoInvertebrados(id_monitoramento_invertebrados) ON DELETE CASCADE,
    quantidade_pesticida FLOAT
);

CREATE TABLE MortalidadePorDoenca (
	  id_mortalidade_doenca SERIAL PRIMARY KEY,
    id_especie INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE,
    id_doenca INT NOT NULL REFERENCES Doenca(id_doenca) ON DELETE CASCADE,
    ano INT NOT NULL,
    quantidade_mortos INT NOT NULL,
    quantidade_doentes INT NOT NULL
);

CREATE TABLE DiversidadeGenetica (
	  id_diversidade_genetica SERIAL PRIMARY KEY,
    id_especie INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE,
    id_monitoramento_populacao INT NOT NULL REFERENCES MonitoramentoPopulacao(id_monitoramento_populacao) ON DELETE CASCADE,
    ano INT NOT NULL,
    diversidade FLOAT NOT NULL
);

CREATE TABLE ReferenciaCientificaEspecie (
    id_referencia_cientifica INT NOT NULL REFERENCES ReferenciaCientifica(id_referencia_cientifica) ON DELETE CASCADE,
    id_especie INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE
);

CREATE TABLE HabitoAlimentarEspecie (
    id_especie INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE,
    id_habito_alimentar INT NOT NULL REFERENCES HabitoAlimentar(id_habito_alimentar) ON DELETE CASCADE
);

CREATE TABLE HabitatEspecie (
    id_habitat INT NOT NULL REFERENCES Habitat(id_habitat) ON DELETE CASCADE,
    id_especie INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE
);

CREATE TABLE BiomaEspecie (
    id_bioma INT NOT NULL REFERENCES Bioma(id_bioma) ON DELETE CASCADE,
    id_especie INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE
);

CREATE TABLE DoencaEspecie (
    id_doenca INT NOT NULL REFERENCES Doenca(id_doenca) ON DELETE CASCADE,
    id_especie INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE
);

CREATE TABLE ProgramaProtecaoEspecie (
    id_programa_protecao INT NOT NULL REFERENCES ProgramaProtecao(id_programa_protecao) ON DELETE CASCADE,
    id_especie INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE
);

CREATE TABLE EspecieLocalizacaoGeografica (
    id_especie INT NOT NULL REFERENCES Especie(id_especie) ON DELETE CASCADE,
    id_localizacao_geografica INT NOT NULL REFERENCES LocalizacaoGeografica(id_localizacao_geografica) ON DELETE CASCADE
);

CREATE TABLE ProgramaProtecaoLocalizacaoGeografica (
    id_programa_protecao INT NOT NULL REFERENCES ProgramaProtecao(id_programa_protecao) ON DELETE CASCADE,
    id_localizacao_geografica INT NOT NULL REFERENCES LocalizacaoGeografica(id_localizacao_geografica) ON DELETE CASCADE
);


CREATE INDEX idx_reino_nome ON Reino (nome);
CREATE INDEX idx_filo_nome ON Filo (nome);
CREATE INDEX idx_filo_reino ON Filo (id_reino);
CREATE INDEX idx_classe_nome ON Classe (nome);
CREATE INDEX idx_classe_filo ON Classe (id_filo);
CREATE INDEX idx_ordem_nome ON Ordem (nome);
CREATE INDEX idx_ordem_classe ON Ordem (id_classe);
CREATE INDEX idx_familia_nome ON Familia (nome);
CREATE INDEX idx_familia_ordem ON Familia (id_ordem);
CREATE INDEX idx_genero_nome ON Genero (nome);
CREATE INDEX idx_genero_familia ON Genero (id_familia);
CREATE INDEX idx_especie_genero ON Especie (id_genero);
CREATE INDEX idx_especie_nome_cientifico ON Especie (nome_cientifico);
CREATE INDEX idx_especie_nome_comum ON Especie (nome_comum);
CREATE INDEX idx_especie_status_conservacao ON Especie (status_conservacao);
CREATE INDEX idx_localizacao_geografica_geom ON LocalizacaoGeografica USING GIST (localizacao);
CREATE INDEX idx_habitat_nome ON Habitat (nome);
CREATE INDEX idx_doenca_nome ON Doenca (nome);
CREATE INDEX idx_imagem_especie ON ImagemEspecie (id_especie);
CREATE INDEX idx_imagem_url ON ImagemEspecie (url);
CREATE INDEX idx_video_especie ON VideoEspecie (id_especie);
CREATE INDEX idx_video_url ON VideoEspecie (url);
CREATE INDEX idx_programa_protecao_nome ON ProgramaProtecao (nome);
CREATE INDEX idx_referencia_cientifica_titulo ON ReferenciaCientifica (titulo);
CREATE INDEX idx_monitoramento_populacao ON MonitoramentoPopulacao (id_especie, ano);
CREATE INDEX idx_predacao_predador ON Predacao (id_especie_predador);
CREATE INDEX idx_predacao_presa ON Predacao (id_especie_presa);
CREATE INDEX idx_predacao_predador_presa ON Predacao (id_especie_predador, id_especie_presa);
CREATE INDEX idx_habitat_especie ON HabitatEspecie (id_habitat, id_especie);
CREATE INDEX idx_doenca_especie ON DoencaEspecie (id_doenca, id_especie);
CREATE INDEX idx_programa_protecao_especie ON ProgramaProtecaoEspecie (id_programa_protecao, id_especie);
CREATE INDEX idx_especie_localizacao ON EspecieLocalizacaoGeografica (id_especie, id_localizacao_geografica);
CREATE INDEX idx_programa_protecao_localizacao ON ProgramaProtecaoLocalizacaoGeografica (id_programa_protecao, id_localizacao_geografica);


CREATE OR REPLACE FUNCTION atualizar_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION atualizar_status_conservacao()
RETURNS TRIGGER AS $$
DECLARE
    media_quantidade FLOAT;
BEGIN
    SELECT AVG(quantidade_populacao::FLOAT) INTO media_quantidade
    FROM MonitoramentoPopulacao
    WHERE id_especie = NEW.id_especie;
    
    UPDATE Especie
    SET status_conservacao = 
        CASE
            WHEN media_quantidade IS NULL THEN 'NAO_AVALIADO'::StatusConservacao
            WHEN media_quantidade < 0.5 THEN 'EXTINTA'::StatusConservacao
            WHEN media_quantidade < 1.0 THEN 'EXTINTA_NA_NATUREZA'::StatusConservacao
            WHEN media_quantidade < 5.0 THEN 'CRITICAMENTE_EM_PERIGO'::StatusConservacao
            WHEN media_quantidade < 10.0 THEN 'EM_PERIGO'::StatusConservacao
            WHEN media_quantidade < 20.0 THEN 'VULNERAVEL'::StatusConservacao
            WHEN media_quantidade < 50.0 THEN 'QUASE_AMEACADA'::StatusConservacao
            ELSE 'POUCO_PREOCUPANTE'::StatusConservacao
        END
    WHERE id_especie = NEW.id_especie;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION atualizar_area_protegida()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE LocalizacaoGeografica
        SET area_protegida = TRUE
        WHERE id_localizacao_geografica = NEW.id_localizacao_geografica;
        
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.id_localizacao_geografica <> NEW.id_localizacao_geografica THEN
            UPDATE LocalizacaoGeografica
            SET area_protegida = FALSE
            WHERE id_localizacao_geografica = OLD.id_localizacao_geografica;
            
            UPDATE LocalizacaoGeografica
            SET area_protegida = TRUE
            WHERE id_localizacao_geografica = NEW.id_localizacao_geografica;
        END IF;
        
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE LocalizacaoGeografica
        SET area_protegida = FALSE
        WHERE id_localizacao_geografica = OLD.id_localizacao_geografica;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_atualizar_updated_at_especie
BEFORE UPDATE ON Especie
FOR EACH ROW
EXECUTE FUNCTION atualizar_updated_at();


CREATE TRIGGER trg_atualizar_updated_at_imagem
BEFORE UPDATE ON ImagemEspecie
FOR EACH ROW
EXECUTE FUNCTION atualizar_updated_at();


CREATE TRIGGER trg_atualizar_updated_at_video
BEFORE UPDATE ON VideoEspecie
FOR EACH ROW
EXECUTE FUNCTION atualizar_updated_at();


CREATE TRIGGER trg_atualizar_updated_at_referencia_cientifica
BEFORE UPDATE ON ReferenciaCientifica
FOR EACH ROW
EXECUTE FUNCTION atualizar_updated_at();


CREATE TRIGGER trg_atualizar_updated_at_amostra_solo
BEFORE UPDATE ON AmostraSolo
FOR EACH ROW
EXECUTE FUNCTION atualizar_updated_at();


CREATE TRIGGER trg_atualizar_updated_at_monitoramento_populacao
BEFORE UPDATE ON MonitoramentoPopulacao
FOR EACH ROW
EXECUTE FUNCTION atualizar_updated_at();


CREATE TRIGGER trg_atualizar_updated_at_monitoramento_invertebrados
BEFORE UPDATE ON MonitoramentoInvertebrados
FOR EACH ROW
EXECUTE FUNCTION atualizar_updated_at();


CREATE TRIGGER trg_atualizar_status_conservacao
AFTER INSERT OR UPDATE ON MonitoramentoPopulacao
FOR EACH ROW
EXECUTE FUNCTION atualizar_status_conservacao();


CREATE TRIGGER trg_atualizar_area_protegida_insert
AFTER INSERT OR UPDATE ON ProgramaProtecaoLocalizacaoGeografica
FOR EACH ROW
EXECUTE FUNCTION atualizar_area_protegida();


CREATE TRIGGER trg_atualizar_area_protegida_delete
AFTER DELETE ON ProgramaProtecaoLocalizacaoGeografica
FOR EACH ROW
EXECUTE FUNCTION atualizar_area_protegida();

 
CREATE VIEW EspeciesAvesMigratorias AS
SELECT e.id_especie, 
       e.nome_cientifico, 
       e.nome_comum,
       lg.descricao AS localizacao_descricao, 
       lg.localizacao AS localizacao_geografica
FROM Especie e
INNER JOIN EspecieLocalizacaoGeografica elg ON e.id_especie = elg.id_especie
INNER JOIN LocalizacaoGeografica lg ON elg.id_localizacao_geografica = lg.id_localizacao_geografica
WHERE e.outras_informacoes ->> 'migratoria' = 'true' 
AND lg.descricao ILIKE '%Amazônia%';


CREATE OR REPLACE VIEW OncaPintadaCerrado AS
SELECT e.id_especie, e.nome_cientifico, lg.id_localizacao_geografica,
    lg.localizacao, mp.quantidade_populacao, b.nome AS bioma_nome, lg.area_protegida
FROM Especie e
INNER JOIN EspecieLocalizacaoGeografica elg ON e.id_especie = elg.id_especie
INNER JOIN LocalizacaoGeografica lg ON elg.id_localizacao_geografica = lg.id_localizacao_geografica
INNER JOIN MonitoramentoPopulacao mp ON e.id_especie = mp.id_especie
INNER JOIN BiomaEspecie be ON e.id_especie = be.id_especie
INNER JOIN Bioma b ON be.id_bioma = b.id_bioma
WHERE e.nome_cientifico = 'Panthera onca'
AND b.nome = 'Cerrado'
AND lg.area_protegida = true;

CREATE VIEW PlantasEndemicasMataAtlanticaAmeacadas AS
SELECT e.id_especie, e.nome_cientifico, e.nome_comum, e.status_conservacao, e.descricao
FROM Especie e
INNER JOIN BiomaEspecie be ON e.id_especie = be.id_especie
INNER JOIN Bioma b ON be.id_bioma = b.id_bioma
WHERE e.status_conservacao IN ('CRITICAMENTE_EM_PERIGO', 'EM_PERIGO', 'VULNERAVEL')
AND b.nome = 'Mata Atlântica';


CREATE VIEW GeneroEspeciesPorFamilia AS
SELECT g.id_genero, g.nome AS nome_genero,
    COUNT(e.id_especie) AS numero_especies
FROM Genero g
JOIN Especie e ON g.id_genero = e.id_genero
JOIN Familia f ON g.id_familia = f.id_familia
WHERE f.nome = 'Felidae'
GROUP BY g.id_genero, g.nome
ORDER BY numero_especies DESC;


CREATE VIEW EspeciesPorStatusConservacao AS
SELECT  e.nome_comum, e.status_conservacao,
    COUNT(e.id_especie) AS numero_especies
FROM Especie e
GROUP BY e.status_conservacao,e.nome_comum;


CREATE VIEW EspeciesHabitats AS
SELECT e.id_especie, e.nome_cientifico, e.nome_comum,
    h.nome AS nome_habitat
FROM Especie e
INNER JOIN HabitatEspecie he ON e.id_especie = he.id_especie
INNER JOIN Habitat h ON he.id_habitat = h.id_habitat;


CREATE VIEW MonitoramentoPopulacaoView AS
SELECT e.id_especie, e.nome_cientifico, e.nome_comum,
    m.ano, m.quantidade_populacao
FROM MonitoramentoPopulacao m
INNER JOIN Especie e ON m.id_especie = e.id_especie;


CREATE VIEW DoencasEspecies AS
SELECT d.id_doenca, d.nome AS nome_doenca,
    e.id_especie, e.nome_cientifico
FROM DoencaEspecie de
INNER JOIN Doenca d ON de.id_doenca = d.id_doenca
INNER JOIN Especie e ON de.id_especie = e.id_especie;


CREATE VIEW DiversidadeGeneticaView AS
SELECT e.id_especie, e.nome_cientifico, e.nome_comum,
    mp.id_monitoramento_populacao, mp.ano,
    d.diversidade
FROM DiversidadeGenetica d
INNER JOIN Especie e ON d.id_especie = e.id_especie
INNER JOIN MonitoramentoPopulacao mp ON d.id_monitoramento_populacao = mp.id_monitoramento_populacao;

INSERT INTO Reino (nome, descricao) VALUES 
('Animalia', 'Reino que inclui todos os animais multicelulares.'),
('Plantae', 'Reino que compreende todas as plantas multicelulares.'),
('Fungi', 'Reino que abrange todos os fungos.'),
('Protista', 'Reino que inclui organismos eucarióticos unicelulares ou simples multicelulares.'),
('Monera', 'Reino que engloba todos os organismos procarióticos, como bactérias.'),
('Archaea', 'Reino de organismos procarióticos, diferentes das bactérias tradicionais.'),
('Chromista', 'Reino que inclui organismos como algas marrons e diatomáceas.'),
('Protozoa', 'Reino que engloba organismos unicelulares eucarióticos heterotróficos.'),
('Viridiplantae', 'Reino que compreende plantas verdes, incluindo algas verdes e plantas terrestres.'),
('Amoebozoa', 'Reino de organismos ameboides que se movem e se alimentam através de pseudópodes.');

INSERT INTO Filo (nome, descricao, id_reino) VALUES
('Chordata', 'Filo dos animais com notocorda, como peixes, anfíbios, répteis, aves e mamíferos.', 1),
('Magnoliophyta', 'Filo das plantas com flores, incluindo todas as angiospermas.', 2),
('Ascomycota', 'Filo dos fungos que formam ascos, como leveduras e bolores.', 3),
('Euglenozoa', 'Filo dos protistas que possuem flagelos, incluindo euglênas.', 4),
('Proteobacteria', 'Filo de bactérias com grande diversidade metabólica e ecológica.', 5);

INSERT INTO Classe ( nome, descricao, id_filo) VALUES
('Mammalia', 'Classe dos mamíferos, animais com glândulas mamárias e pelos.', 1),
('Monocotyledonae', 'Classe das plantas com um único cotilédone, como gramíneas e lírios.', 2),
( 'Saccharomycetes', 'Classe dos fungos conhecidos como leveduras, como a Saccharomyces cerevisiae.', 3),
('Euglenophyceae', 'Classe de protistas com cloroplastos e flagelos, como as euglênas.', 4),
( 'Gamma Proteobacteria', 'Classe de bactérias com grande diversidade metabólica, incluindo várias patógenos.', 5);

INSERT INTO Ordem ( nome, descricao, id_classe) VALUES
('Carnivora', 'Ordem dos mamíferos carnívoros, como leões e tigres.', 1),
('Poales', 'Ordem das monocotiledôneas que inclui gramíneas e cana-de-açúcar.', 2),
('Saccharomycetales', 'Ordem dos fungos que inclui leveduras e outros ascomicetos.', 3),
('Euglenales', 'Ordem dos protistas Euglenophyceae, como Euglena.', 4),
('Enterobacteriales', 'Ordem de bactérias Gram-negativas, incluindo muitos patógenos como Escherichia coli.', 5);

INSERT INTO Familia (nome, descricao, id_ordem) VALUES
('Felidae', 'Família dos felinos, incluindo leões, tigres, e gatos domésticos.', (SELECT id_ordem FROM Ordem WHERE nome = 'Carnivora')),
('Poaceae', 'Família das gramíneas, incluindo trigo, milho e arroz.', (SELECT id_ordem FROM Ordem WHERE nome = 'Poales')),
('Saccharomycetaceae', 'Família de fungos que inclui o gênero Saccharomyces.', (SELECT id_ordem FROM Ordem WHERE nome = 'Saccharomycetales')),
('Euglenaceae', 'Família de protistas Euglenales, como Euglena.', (SELECT id_ordem FROM Ordem WHERE nome = 'Euglenales')),
('Enterobacteriaceae', 'Família de bactérias, incluindo Escherichia coli e Salmonella.', (SELECT id_ordem FROM Ordem WHERE nome = 'Enterobacteriales'));

INSERT INTO Genero (nome, descricao, id_familia) VALUES
('Panthera', 'Gênero que inclui grandes felinos como leões, tigres e leopardos.', (SELECT id_familia FROM Familia WHERE nome = 'Felidae')),
('Hordeum', 'Gênero de gramíneas, incluindo a cevada.', (SELECT id_familia FROM Familia WHERE nome = 'Poaceae')),
('Saccharomyces', 'Gênero de leveduras que inclui Saccharomyces cerevisiae.', (SELECT id_familia FROM Familia WHERE nome = 'Saccharomycetaceae')),
('Euglena', 'Gênero de protistas com cloroplastos e flagelos.', (SELECT id_familia FROM Familia WHERE nome = 'Euglenaceae')),
('Escherichia', 'Gênero de bactérias que inclui Escherichia coli.', (SELECT id_familia FROM Familia WHERE nome = 'Enterobacteriaceae'));

INSERT INTO Especie (nome_cientifico, nome_comum, descricao, status_conservacao, id_genero, comportamento, outras_informacoes) VALUES
('Panthera leo', 'Leão', 'Grande felino conhecido por sua juba.', 'NAO_AVALIADO'::StatusConservacao, 1, 'Carnívoro', '{"habitat": "savanas"}'),
('Hordeum vulgare', 'Cevada', 'Planta cultivada para grãos.', 'NAO_AVALIADO'::StatusConservacao, 2, 'Cultivada', '{"uso": "alimentação"}'),
('Saccharomyces cerevisiae', 'Levedura de Cerveja', 'Fungo utilizado na fermentação.', 'NAO_AVALIADO'::StatusConservacao, 3, 'Fermentador', '{"uso": "culinária"}'),
('Euglena gracilis', 'Euglena', 'Protista com características de planta e animal.', 'NAO_AVALIADO'::StatusConservacao, 4, 'Autótrofo e heterótrofo', '{"ambiente": "água doce"}'),
('Escherichia coli', 'E. coli', 'Bactéria comum no trato intestinal.', 'NAO_AVALIADO'::StatusConservacao, 5, 'Comensal e patógeno', '{"encontrado_em": "intestinos"}'),
('Panthera onca', 'Onça-pintada', 'Grande felino nativo das Américas, conhecido por sua pelagem manchada.', 'NAO_AVALIADO'::StatusConservacao, 1, 'Carnívoro', '{"habitat": "florestas e cerrados"}');

INSERT INTO LocalizacaoGeografica (localizacao, descricao, area_protegida) VALUES
('POLYGON((10 10, 20 10, 20 20, 10 20, 10 10))', 'Área de floresta tropical com rica biodiversidade.', TRUE),
('POLYGON((30 30, 40 30, 40 40, 30 40, 30 30))', 'Reserva natural de savana com diversas espécies de fauna.', TRUE),
('POLYGON((50 50, 60 50, 60 60, 50 60, 50 50))', 'Zona de proteção de habitat para aves migratórias.', TRUE),
('POLYGON((70 70, 80 70, 80 80, 70 80, 70 70))', 'Área de campo aberto com vegetação xerófila.', TRUE),
('POLYGON((90 90, 100 90, 100 100, 90 100, 90 90))', 'Localização de projeto de replantio de vegetação nativa.', TRUE);

INSERT INTO Habitat (nome, descricao) VALUES
('Floresta Tropical', 'Habitat de alta biodiversidade com árvores de grande porte e clima quente e úmido. Encontra-se em regiões equatoriais.'),
('Savana', 'Área com vegetação de gramíneas e arbustos, e clima tropical com estação seca e chuvosa. É habitada por grandes herbívoros e predadores.'),
('Deserto', 'Ambiente árido com pouca vegetação e temperaturas extremas. Adaptado a espécies que conseguem sobreviver com pouca água.'),
('Região Ártica', 'Área com clima frio extremo, gelo e neve. Lar de espécies adaptadas ao frio, como ursos polares e focas.'),
('Recifes de Coral', 'Ecossistema marinho diversificado, composto por corais e organismos associados. Importante para a biodiversidade marinha e proteção das costas.');

INSERT INTO Bioma (nome, descricao) VALUES
('Floresta Amazônica', 'Bioma de floresta tropical úmida localizada na América do Sul, conhecida por sua vasta biodiversidade e papel crucial no equilíbrio climático global.'),
('Savana Tropical', 'Bioma caracterizado por gramíneas e algumas árvores dispersas, com um clima tropical e estações bem definidas de seca e chuva. Encontra-se na África, América do Sul e Austrália.'),
('Deserto do Saara', 'Bioma de deserto quente, localizado na África, com temperaturas extremas, baixa umidade e vegetação escassa adaptada à aridez.'),
('Taiga', 'Bioma de floresta boreal localizada nas regiões subárticas da América do Norte, Europa e Ásia, caracterizada por coníferas e invernos longos e frios.'),
('Recife de Coral', 'Bioma marinho formado por estruturas de corais, rico em biodiversidade marinha e importante para a proteção das costas e manutenção do equilíbrio ecológico dos oceanos.'),
('Cerrado', 'Bioma de savana tropical localizada no Brasil, caracterizado por vegetação herbácea e arbustiva com árvores esparsas, além de um clima tropical com estação seca bem definida.');

INSERT INTO Doenca (nome, descricao, tipo_doenca, is_transmissivel) VALUES
('Gripe', 'Infecção viral aguda que afeta o sistema respiratório, causando febre, tosse e dores no corpo.', 'INFEC', TRUE),
('Malária', 'Infecção parasitária transmitida por mosquitos, causando febre e calafrios.', 'PARASITARIA', TRUE),
('Fibrose Cística', 'Doença genética que causa a produção de muco espesso e pegajoso, afetando os pulmões e o sistema digestivo.', 'GENETICA', FALSE),
('Escorbuto', 'Deficiência de vitamina C que leva a sintomas como sangramento nas gengivas e fraqueza geral.', 'NUTRICIONAL', FALSE),
('Esclerose Múltipla', 'Doença autoimune que afeta o sistema nervoso central, causando problemas de mobilidade e coordenação.', 'OUTRAS', FALSE);

INSERT INTO ImagemEspecie (url, descricao, id_especie, created_at, updated_at) VALUES
('https://example.com/images/leao.jpg', 'Leão em habitat natural.', 1, CURRENT_TIMESTAMP, NULL),
('https://example.com/images/cevada.jpg', 'Planta de cevada em campo.', 2, CURRENT_TIMESTAMP, NULL),
('https://example.com/images/levedura.jpg', 'Levedura de panificação em cultura.', 3, CURRENT_TIMESTAMP, NULL),
('https://example.com/images/euglena.jpg', 'Euglena em microscópio.', 4, CURRENT_TIMESTAMP, NULL),
('https://example.com/images/ecoli.jpg', 'Escherichia coli sob o microscópio.', 5, CURRENT_TIMESTAMP, NULL);

INSERT INTO VideoEspecie (url, descricao, id_especie, created_at, updated_at) VALUES
('https://example.com/videos/leao.mp4', 'Vídeo de um leão caçando na savana.', 1, CURRENT_TIMESTAMP, NULL),
('https://example.com/videos/cevada.mp4', 'Processo de crescimento da cevada em campo.', 2, CURRENT_TIMESTAMP, NULL),
('https://example.com/videos/levedura.mp4', 'Vídeo mostrando a fermentação pela levedura.', 3, CURRENT_TIMESTAMP, NULL),
('https://example.com/videos/euglena.mp4', 'Observação de Euglena em microscópio.', 4, CURRENT_TIMESTAMP, NULL),
('https://example.com/videos/ecoli.mp4', 'Vídeo sobre o crescimento e características de Escherichia coli.', 5, CURRENT_TIMESTAMP, NULL);

INSERT INTO ReferenciaCientifica (titulo, autor, ano_publicacao, url, created_at, updated_at) VALUES
('Biologia das Espécies de Felinos', 'John Doe', 2021, 'https://example.com/artigo/felinos', CURRENT_TIMESTAMP, NULL),
('Estudos sobre Cevada e suas Aplicações', 'Jane Smith', 2019, 'https://example.com/artigo/cevada', CURRENT_TIMESTAMP, NULL),
('A Fermentação por Saccharomyces cerevisiae', 'Alice Johnson', 2020, 'https://example.com/artigo/levedura', CURRENT_TIMESTAMP, NULL),
('Características de Euglena e seu Habitat', 'Robert Brown', 2018, 'https://example.com/artigo/euglena', CURRENT_TIMESTAMP, NULL),
('O Papel de Escherichia coli na Medicina', 'Emily Davis', 2022, 'https://example.com/artigo/ecoli', CURRENT_TIMESTAMP, NULL);

INSERT INTO HabitoAlimentar (tipo_habito, descricao) VALUES
('HERBIVORO', 'Alimenta-se exclusivamente de plantas e vegetais. Exemplos incluem vacas e coelhos.'),
('CARNIVORO', 'Alimenta-se exclusivamente de carne de outros animais. Exemplos incluem leões e tigres.'),
('ONIVORO', 'Alimenta-se de uma dieta variada, incluindo tanto plantas quanto animais. Exemplos incluem seres humanos e ursos.'),
('DETRETIVORO', 'Alimenta-se de matéria orgânica em decomposição. Exemplos incluem minhocas e besouros de esterco.'),
('INSECTIVORO', 'Alimenta-se principalmente de insetos. Exemplos incluem sapos e andorinhas.'),
('FRUGIVORO', 'Alimenta-se predominantemente de frutas. Exemplos incluem algumas espécies de primatas e pássaros frugívoros.');

INSERT INTO Predacao (id_especie_predador, id_especie_presa, descricao) VALUES
(1, 2, 'O leão caça a cebada em áreas agrícolas quando a fome é extrema.'),
(3, 4, 'A levedura de cerveja predadora consome as Euglenas em ambientes aquáticos.'),
(5, 1, 'A bactéria Escherichia coli pode consumir células do leão durante infecções intestinais.'),
(2, 3, 'A cebada pode ser atacada por diversos fungos, incluindo a levedura Saccharomyces cerevisiae.'),
(4, 5, 'A Euglena é uma presa comum para as bactérias, incluindo a Escherichia coli em ambientes aquáticos.');

INSERT INTO ProgramaProtecao (id_programa_protecao, nome, descricao, medidas_conservacao) VALUES
(1, 'Programa de Recuperação de Habitat', 'Iniciativa para restaurar habitats naturais degradados.', 'Reflorestamento, controle de espécies invasoras'),
(2, 'Plano de Conservação das Aves', 'Programa dedicado à proteção de aves ameaçadas.', 'Criação de reservas, monitoramento de populações, combate à caça ilegal'),
(3, 'Iniciativa para Preservação de Corais', 'Esforço para proteger e restaurar os recifes de corais.', 'Redução da poluição, proteção de áreas marinhas, pesquisa científica'),
(4, 'Programa de Proteção de Espécies em Perigo', 'Ações para a conservação de espécies ameaçadas de extinção.', 'Criação de áreas protegidas, programas de reprodução em cativeiro, campanhas de conscientização'),
(5, 'Iniciativa de Conservação de Florestas Tropicais', 'Esforços para preservar as florestas tropicais e sua biodiversidade.', 'Proteção legal das florestas, programas de manejo sustentável, combate ao desmatamento');

INSERT INTO AmostraSolo (id_bioma, id_localizacao_geografica, created_at, updated_at) VALUES
(1, 1, CURRENT_TIMESTAMP, NULL),
(2, 2, CURRENT_TIMESTAMP, NULL),
(3, 3, CURRENT_TIMESTAMP, NULL),
(4, 4, CURRENT_TIMESTAMP, NULL),
(5, 5, CURRENT_TIMESTAMP, NULL);

INSERT INTO Pesticida (nome, descricao) VALUES
('Glifosato', 'Herbicida amplamente utilizado para controlar uma ampla gama de plantas daninhas.'),
('Atrazina', 'Herbicida seletivo usado principalmente em culturas de milho para controle de ervas daninhas.'),
('Clorpirifós', 'Inseticida que atua como um neurotoxina, utilizado para controlar uma variedade de insetos.'),
('Carbaryl', 'Inseticida de amplo espectro usado para controle de pragas em várias culturas.'),
('Imidacloprido', 'Inseticida da classe dos neonicotinoides, utilizado para controlar insetos sugadores e mastigadores.');

INSERT INTO PresencaBacteriana (id_amostra_solo, id_especie) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO MonitoramentoPopulacao (id_especie, ano, quantidade_populacao, created_at, updated_at) VALUES
(1, 2023, 1500, CURRENT_TIMESTAMP, NULL),
(2, 2023, 20000, CURRENT_TIMESTAMP, NULL),
(3, 2022, 500000, CURRENT_TIMESTAMP, NULL),
(4, 2024, 7500, CURRENT_TIMESTAMP, NULL),
(5, 2023, 12000, CURRENT_TIMESTAMP, NULL),
(6, 2023, 300, CURRENT_TIMESTAMP, NULL),
(6, 2022, 250, CURRENT_TIMESTAMP, NULL);

INSERT INTO MonitoramentoInvertebrados (id_especie, id_localizacao_geografica, data_coleta, abundancia) VALUES
(1, 1, '2024-07-01', 150),
(2, 2, '2024-07-02', 200),
(3, 3, '2024-07-03', 300),
(4, 4, '2024-07-04', 400),
(5, 5, '2024-07-05', 500);

INSERT INTO MonitoramentoPesticida (id_pesticida, id_monitoramento_invertebrados, quantidade_pesticida) VALUES
(1, 1, 12.5),
(2, 2, 8.0), 
(3, 3, 15.0),
(4, 4, 10.0),
(5, 5, 5.0);

INSERT INTO MortalidadePorDoenca (id_especie, id_doenca, ano, quantidade_mortos, quantidade_doentes) VALUES
(1, 1, 2023, 50, 200),
(2, 2, 2023, 100, 300),
(3, 3, 2022, 500, 800),
(4, 4, 2024, 10, 100),
(5, 5, 2023, 80, 250);

INSERT INTO DiversidadeGenetica (id_especie, id_monitoramento_populacao, ano, diversidade) VALUES
(1, 1, 2023, 0.75),
(2, 2, 2023, 0.80),
(3, 3, 2022, 0.65),
(4, 4, 2024, 0.70),
(5, 5, 2023, 0.85);

INSERT INTO ReferenciaCientificaEspecie (id_especie, id_referencia_cientifica) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO HabitoAlimentarEspecie (id_especie, id_habito_alimentar) VALUES
(1, 1),
(2, 3),
(3, 5),
(4, 4),
(5, 2);

INSERT INTO HabitatEspecie (id_habitat, id_especie) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO BiomaEspecie (id_bioma, id_especie) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(1, 6);

INSERT INTO ProgramaProtecaoEspecie (id_programa_protecao, id_especie) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO EspecieLocalizacaoGeografica (id_especie, id_localizacao_geografica) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 1);
