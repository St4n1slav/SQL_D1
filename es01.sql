-- Clienti

CREATE TABLE public.clienti
(
    numero_cliente bigint NOT NULL,
    nome character varying NOT NULL,
    cognome character varying NOT NULL,
    anno_di_nascita integer NOT NULL,
    regione_residenza character varying NOT NULL,
    PRIMARY KEY (numero_cliente)
);

ALTER TABLE IF EXISTS public.clienti
    OWNER to postgres;

-- Prodotti

	CREATE TABLE public.prodotti
(
    id_prodotto bigint NOT NULL,
    descrizione character varying NOT NULL,
    in_produzione boolean NOT NULL,
    in_commercio boolean NOT NULL,
    data_attivazione date,
    data_disattivazione date,
    PRIMARY KEY (id_prodotto)
);

ALTER TABLE IF EXISTS public.prodotti
    OWNER to postgres;

	-- Fornitori

	CREATE TABLE public.fornitori
(
    numero_fornitore bigint NOT NULL,
    denominazione character varying NOT NULL,
    regione_residenza character varying NOT NULL,
    PRIMARY KEY (numero_fornitore)
);

ALTER TABLE IF EXISTS public.fornitori
    OWNER to postgres;

	-- Fatture

	CREATE TABLE public.fatture
(
    numero_fattura bigint NOT NULL,
    tipologia character varying NOT NULL,
    importo bigint NOT NULL,
    iva bigint NOT NULL,
    id_cliente bigint NOT NULL,
    data_fattura date NOT NULL,
    numero_fornitore bigint NOT NULL,
    PRIMARY KEY (numero_fattura),
    FOREIGN KEY (id_cliente)
        REFERENCES public.clienti (numero_cliente) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    FOREIGN KEY (numero_fornitore)
        REFERENCES public.fornitori (numero_fornitore) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS public.fatture
    OWNER to postgres;

    -- da qua iniziano le query

	select * 
	from public.clienti
	where nome='Mario';

	select nome, cognome
	from public.clienti
	where anno_di_nascita=1982;

	select count(*)
	from fatture
	where iva=20;

	select *
	from prodotti
	where EXTRACT(YEAR from data_attivazione)=2017
	and (in_produzione=true or in_commercio=true);

	select *
	from fatture f
	join clienti c on c.numero_cliente = f.id_cliente
	where f.importo<1000;

	select f.numero_fattura, f.iva, f.importo, f.data_fattura, c.denominazione
	from fatture f
	join fornitori c on c.numero_fornitore = f.numero_fornitore;

	select count(*), EXTRACT(YEAR from data_fattura) as anno
	from fatture
	where iva=20
	group by anno;

	select count(*), EXTRACT(YEAR from data_fattura) as anno, sum(importo)
	from fatture
	group by anno;
	