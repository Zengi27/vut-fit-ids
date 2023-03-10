drop table pobocka cascade constraints;
drop table zamestnanec cascade constraints;
drop table klient cascade constraints;
drop table platobnakarta cascade constraints;
drop table ucet cascade constraints;
drop table tranzakcia cascade constraints;

create table pobocka (
    pobockaID number generated by default as identity primary key,
    hodinyod varchar(5) not null , -- pretoze hodiny nam stacia ako string formatu hh:mm
    hodinydo varchar(5) not null ,
    ulica varchar(50) not null ,
    mesto varchar(50) not null ,
    psc varchar(5)  -- lebo number vymaze 0 na zaciatku
);

create table zamestnanec (
    zamestnanecID number generated by default as identity primary key,
    meno varchar(50) not null,
    priezvisko varchar(50) not null,
    email varchar(50) default null,      -- nemusi by not null pretoze moze mat bud telefon alebo email alebo sa mu posle odkaz na adresu
    telefon varchar(50) default null,
    ulica varchar(50) not null ,
    mesto varchar(50) not null ,
    psc varchar(50) not null ,-- lebo obsahuje char napr medzera
    plat int not null,
    pracuje int not null,
    nadrriadeny varchar(50), -- moze byt null pretoze najvyssi nadriadeny v hierarchii uz nema ziadneho nadriadeneho
    FOREIGN KEY (pracuje) REFERENCES pobocka(pobockaID) on delete cascade
);

create table klient (
    klientID number generated by default as identity primary key,
    meno varchar(50) not null,
    priezvisko varchar(50) not null,
    email varchar(50) default null,      -- nemusi by not null pretoze moze mat bud telefon alebo email alebo sa mu posle odkaz na adresu
    telefon varchar(50) default null,
    ulica varchar(50) not null ,
    mesto varchar(50) not null ,
    psc varchar(50) not null ,-- lebo obsahuje char napr medzera
    limit int,      -- limit nemusi byt lebo vlastnik moze mat neobmedzeni limit kdezto disponent nie
    pravo_zmena_hesla number(1) default 0 , -- pravo na zmenu hesla
    pravo_pridat_disponenta number(1) default 0 ,
    pravo_zmena_limit number(1) default 0
);


create table platobnakarta(
    platobnakartaID number generated by default as identity primary key,
    drzitel varchar(50) not null, -- drzitel nemusi
    PIN number(4) not null , ----  banky mavaju pinkody ktore obsahuju prave 4 cislice
    platobnylimit int not null, -- vzdy musi mat limit
    pobockaID int not null,
    FOREIGN KEY (pobockaID) REFERENCES pobocka(pobockaID) on delete cascade,
    ma int not null, -- drzitel je zaroven klientom banky ktory vlastni banku
    FOREIGN KEY (ma) REFERENCES klient(klientID) on delete cascade
);

create table ucet(
    ucetID number generated by default as identity primary key,
    nazov varchar(50) not null, -- drzitel nemusi
    zostatok int not null , ----  nemoze byt null, pretoze vacsinou u bank pri zavedeni uctu sa musizadat vzdy nejaka suma ktora je vratena az po zruseni uctu
    zriadenie date , --not null,
    typuctu varchar(12) check ( typuctu in ('bezny','sporiaci','internetovy')) NOT NULL ,
    limit int default null,  -- pre bezny ucet
    urok float default null,    -- pre sporiaci ucet
    heslo varchar(50) default null, -- pre internetovy ucet
    vlastni int not null, -- drzitel je zaroven klientom banky ktory vlastni banku
    FOREIGN KEY (vlastni) REFERENCES klient(klientID) on delete cascade
);

create table tranzakcia (
    tranzakciaID number generated by default as identity primary key,
    ucetID int not null ,
    druhtranzakcie varchar(50) not null,
    ciastka int not null , ---- nemozeme poslat 0
    datum date not null ,
    FOREIGN KEY (ucetID) REFERENCES ucet(ucetID),
    sprostrekovatelID int not null,
    FOREIGN KEY (sprostrekovatelID) REFERENCES zamestnanec(zamestnanecID) on delete cascade
);

insert into pobocka (hodinyod, hodinydo, ulica, mesto, psc) values ('08:00','16:00','Hviezdoslavova','Lokca','02951');
insert into pobocka (hodinyod, hodinydo, ulica, mesto, psc) values ('08:00','15:00','Podstarobincom','Vasilov','02952');
insert into pobocka (hodinyod, hodinydo, ulica, mesto, psc) values ('10:00','17:00','Pod mostom','Babin','02352');



insert into zamestnanec (meno, priezvisko, ulica, mesto, psc,plat, pracuje, nadrriadeny) values ('Pavol','fendek','Brabirla','Lokca','02951',860,1,null);
insert into zamestnanec (meno, priezvisko, ulica, mesto, psc,plat, pracuje, nadrriadeny) values ('Ignac','Povala','Brezovica','Breza','02955',500,1,'Pavol');
insert into zamestnanec (meno, priezvisko, ulica, mesto, psc,plat, pracuje, nadrriadeny) values ('Jozef','Hruska','Lomna','Lomna','02956',500,2,null);
insert into zamestnanec (meno, priezvisko, ulica, mesto, psc,plat, pracuje, nadrriadeny) values ('Frantise','Mrkava','Trilo','Lomna','02956',500,2,'Jozef');
insert into zamestnanec (meno, priezvisko, ulica, mesto, psc,plat, pracuje, nadrriadeny) values ('Jozefina','Bryndzova','Javorova','Lomna','02956',630,3,null);


insert into klient (meno, priezvisko, ulica, mesto, psc, limit, pravo_zmena_hesla, pravo_pridat_disponenta, pravo_zmena_limit) values ('Jan','Homola','Lan','Lokca','02951',null,1,1,1);
insert into klient (meno, priezvisko, ulica, mesto, psc, limit, pravo_zmena_hesla, pravo_pridat_disponenta, pravo_zmena_limit) values ('Damian','Gorcak','koskos','Breza','02954',null,1,0,1);
insert into klient (meno, priezvisko, ulica, mesto, psc, limit, pravo_zmena_hesla, pravo_pridat_disponenta, pravo_zmena_limit) values ('Ferinko','Dobo??ka','Mrkvickova','Breza','02966',null,1,1,1);


insert into ucet (nazov, zostatok, zriadenie, typuctu, limit, vlastni) values ('GOrkyho ucet',800,'11-11-2000','bezny',800,2);
insert into ucet (nazov, zostatok, zriadenie, typuctu, heslo, vlastni) values ('Hanzov ucet',300,'10-05-1999','internetovy','12345',1);

insert into tranzakcia (ucetID, druhtranzakcie, ciastka, datum, sprostrekovatelID) values (1,'prevod',344,'04-03-3333', 3);
insert into tranzakcia (ucetID, druhtranzakcie, ciastka, datum, sprostrekovatelID) values (2,'Poslal papkovi',144,'02-03-3333', 2);
insert into tranzakcia (ucetID, druhtranzakcie, ciastka, datum, sprostrekovatelID) values (2,'prijem',4444,'01-03-3333', 2);


insert into platobnakarta (drzitel, PIN, platobnylimit, pobockaID, ma)  values ('Jozko Mrkva', 1111, 50, 1, 2);


-------------------------------------- SELECTY -----------------------------------------


--------------------- selecty na skusku foreign keys ----------------------------

--select  z.meno from zamestnanec z, pobocka p where z.pracuje =p.pobockaID and z.mesto = 'Lokca';

--select  z.nazov from ucet z, klient p where z.vlastni =p.klientID and z.typuctu = 'bezny';

--select  p.mesto,z.meno  from zamestnanec  z, pobocka p where z.pracuje = p.pobockaID order by z.plat;

--select p.mesto, p.hodinyod, p.hodinydo  from pobocka p;

--select  z.meno from zamestnanec z, pobocka p where z.pracuje =p.pobockaID and z.mesto = 'Lokca';

--select  z.nazov from ucet z, klient p where z.vlastni =p.klientID and z.typuctu = 'bezny';

--------------------- selecty na skusku foreign keys ----------------------------





--select urceny na vyratanie sumy kolko minie dana polozka v danom meste na vyplaty
select  p.mesto, sum(z.plat)
from zamestnanec  z, pobocka p
where z.pracuje = p.pobockaID
group by p.mesto
order by sum(z.plat);


--select urceny na otvaracie hodiny
select p.mesto, p.hodinyod, p.hodinydo
from pobocka p;


--tento select je cez 3 tabulky a ukaze aku sumu previedol v transakciach jednotlivy zamestnanec
--zoradene od najmensej po najvaciu
select  Z.meno, Z.priezvisko, sum(T.ciastka)
from zamestnanec Z , tranzakcia T, ucet U
where U.ucetID = T.ucetID and T.sprostrekovatelID = Z.zamestnanecID
GROUP BY Z.zamestnanecID, Z.meno, Z.priezvisko
order by sum(T.ciastka);


--select na vypisanie klientov ktory maju iba internetovy ucet, a zostatok na ucte
select K.meno, K.priezvisko, U.zostatok
from klient K, ucet U
where K.klientID = U.vlastni
and U.typuctu = 'internetovy'
and not exists
    (select *
    from ucet U
    where K.klientID = U.vlastni and U.typuctu in ('bezny','sporiaci')
    );


--tento vybere zamestnanca ktory urobil tranzakciu dna 04-03-3333
select z.meno, z.priezvisko from zamestnanec z
where z.zamestnanecID in
     (select t.sprostrekovatelID  from tranzakcia t
            where t.DATUM = '04-03-3333'
         );


--tento vybere zamestnanca ktory urobil tranzakciu pre ucet s nazvom 'Hanzov ucet'
select z.meno, z.priezvisko
from zamestnanec z
where z.zamestnanecID in
     (select t.sprostrekovatelID  from tranzakcia t
            where t.ucetID in (
                select u.ucetID from ucet u
                where u.nazov = 'Hanzov ucet'
                )
         );


-- selec na vypisanie sefa na pobocke a pobocky zoradi abecedne
select P.mesto, Z.meno, Z.priezvisko
from pobocka P, zamestnanec Z
where P.pobockaID = Z.pracuje and Z.nadrriadeny is null
order by 1;






