-------------
------4------
-------------
--Implementati in Oracle diagrama conceptuala realizata: definiti toate
--tabelele, implementand toate constrangerile de integritate necesare
--(chei primare, cheile externe etc).

create table tara(
    id_tara varchar2(5) primary key,
    denumire_tara varchar2(30) not null
);

create table oras(
    id_oras number(6),
    id_tara varchar2(5),
    denumire_oras varchar2(30) not null
);

create table inchisoare(
    id_inchisoare number(6) primary key,
    denumire_inchisoare varchar2(30) not null,
    id_oras number(6),
    id_tara varchar2(5)
);

create table sentinta(
    id_sentinta number(6) primary key,
    luni_de_inchisoare number(10, 2) not null,
    id_inchisoare number(6)
);

create table judecator(
    id_judecator number(6) primary key,
    nume_judecator varchar2(30) not null,
    prenume_judecator varchar2(30) not null,
    varsta number(6),
    denumire_tribunal varchar2(30) not null
);

create table hot_de_banci(
    id_hot number(6) primary key,
    nume_hot varchar2(30) not null,
    prenume_hot varchar2(30),
    varsta_hot number(6)
);

create table judecator_sentinta_hot(
    id_judecator number(6),
    id_sentinta number(6),
    id_hot number(6),
    data_acordarii date
);

create table banca(
    id_banca number(6) primary key,
    denumire_banca varchar2(30) not null,
    id_oras number(6),
    id_tara varchar2(5)
);

create table client(
    id_client number(6) primary key,
    id_banca number(6),
    nume_client varchar2(30) not null,
    prenume_client varchar2(30),
    varsta_client number(6)
);

create table jaf(
    id_jaf number(6) primary key,
    id_banca number(6),
    data_jaf date not null
);

create table hot_jaf(
    id_jaf number(6),
    id_hot number(6),
    arma varchar2(30)
);

create table martor(
    id_martor number(6) primary key,
    nume_martor varchar2(30) not null,
    prenume_martor varchar2(30),
    varsta_martor number(6)
);

create table sectie_politie(
    id_sectie number(6) primary key,
    denumire_sectie varchar2(35) not null
);

create table politist(
    id_politist number(6) primary key,
    nume_politist varchar2(30) not null,
    prenume_politist varchar2(30),
    varsta_politist number(6),
    data_angajarii date,
    id_sectie number(6)
);

create table martor_jaf(
    id_jaf number(6),
    id_martor number(6)
);

create table arestare_hot(
    id_hot number(6),
    id_politist number(6),
    data_arestarii date
);



alter table oras
add constraint fk_oras_tara foreign key (id_tara) references tara(id_tara);

alter table oras
add constraint pk_oras primary key (id_oras, id_tara);

alter table inchisoare
add constraint fk_inchisoare_oras foreign key (id_oras, id_tara) references oras(id_oras, id_tara);

alter table sentinta
add constraint fk_sentinta_inchisoare foreign key (id_inchisoare) references inchisoare(id_inchisoare);

alter table judecator_sentinta_hot
add constraint fk_judecator_sentinta_hot foreign key (id_judecator) references judecator(id_judecator);

alter table judecator_sentinta_hot
add constraint fk_sentinta_judecator_hot foreign key (id_sentinta) references sentinta(id_sentinta);

alter table judecator_sentinta_hot
add constraint fk_hot_judecator_sentinta foreign key (id_hot) references hot_de_banci(id_hot);

alter table judecator_sentinta_hot
add constraint pk_judecator_sentinta_hot primary key (id_judecator, id_sentinta, id_hot);

alter table banca
add constraint fk_banca_oras foreign key (id_oras, id_tara) references oras(id_oras, id_tara);

alter table client
add constraint fk_client_banca foreign key (id_banca) references banca(id_banca);

alter table jaf
add constraint fk_jaf_banca foreign key (id_banca) references banca(id_banca);

alter table hot_jaf
add constraint fk_jaf_hot foreign key (id_jaf) references jaf(id_jaf);

alter table hot_jaf
add constraint fk_hot_jaf foreign key (id_hot) references hot_de_banci(id_hot);

alter table hot_jaf
add constraint pk_hot_jaf primary key (id_jaf, id_hot);

alter table politist
add constraint fk_politist_sectie foreign key (id_sectie) references sectie_politie(id_sectie);

alter table martor_jaf
add constraint fk_jaf_martor foreign key (id_jaf) references jaf(id_jaf);

alter table martor_jaf
add constraint fk_martor_jaf foreign key (id_martor) references martor(id_martor);

alter table martor_jaf
add constraint pk_martor_jaf primary key (id_jaf, id_martor);

alter table arestare_hot
add constraint fk_hot_arestare foreign key (id_hot) references hot_de_banci(id_hot);

alter table arestare_hot
add constraint fk_arestare_hot foreign key (id_politist) references politist(id_politist);

alter table arestare_hot
add constraint pk_arestare_hot primary key (id_hot, id_politist);

commit;

-------------
------5------
-------------
--Adaugati informatii coerente in tabelele create (minim 5 inregistrari
--pentru fiecare entitate independenta; minim 10 inregistrari pentru
--tabela asociativa).

begin
    insert into tara (id_tara, denumire_tara) 
    values ('RO', 'Romania');
    
    insert into tara (id_tara, denumire_tara) 
    values ('BE', 'Belgia');
    
    insert into tara (id_tara, denumire_tara) 
    values ('ES', 'Spania');
    
    insert into tara (id_tara, denumire_tara) 
    values ('JP', 'Japonia');
    
    insert into tara (id_tara, denumire_tara) 
    values ('DE', 'Germania');
    
    
    
    insert into oras (id_oras, id_tara, denumire_oras) 
    values (1, 'JP', 'Osaka');
    
    insert into oras (id_oras, id_tara, denumire_oras) 
    values (2, 'RO', 'Bucuresti');
    
    insert into oras (id_oras, id_tara, denumire_oras) 
    values (3, 'DE', 'Berlin');
    
    insert into oras (id_oras, id_tara, denumire_oras) 
    values (4, 'BE', 'Saint-Gilles');
    
    insert into oras (id_oras, id_tara, denumire_oras) 
    values (5, 'ES', 'Madrid');
    
    
    
    insert into inchisoare (id_inchisoare, denumire_inchisoare, id_oras, id_tara) 
    values (124, 'Inchisoarea Aranjuez', 5, 'ES');
    
    insert into inchisoare (id_inchisoare, denumire_inchisoare, id_oras, id_tara) 
    values (125, 'Inchisoarea Osaka', 1, 'JP');
    
    insert into inchisoare (id_inchisoare, denumire_inchisoare, id_oras, id_tara) 
    values (126, 'Inchisoarea St. Gilles', 4, 'BE');
    
    insert into inchisoare (id_inchisoare, denumire_inchisoare, id_oras, id_tara) 
    values (127, 'Penitenciarul Bucuresti-Jilava', 2, 'RO');
    
    insert into inchisoare (id_inchisoare, denumire_inchisoare, id_oras, id_tara) 
    values (128, 'Inchisoarea Plotzensee', 3, 'DE');
    
    
    
    insert into sentinta (id_sentinta, luni_de_inchisoare, id_inchisoare) 
    values (475, 120, 124);
    
    insert into sentinta (id_sentinta, luni_de_inchisoare, id_inchisoare) 
    values (476, 135, 128);
    
    insert into sentinta (id_sentinta, luni_de_inchisoare, id_inchisoare) 
    values (477, 200, 126);
    
    insert into sentinta (id_sentinta, luni_de_inchisoare, id_inchisoare) 
    values (478, 80, 125);
    
    insert into sentinta (id_sentinta, luni_de_inchisoare, id_inchisoare) 
    values (479, 110, 127);
    
    
    
    insert into judecator (id_judecator, nume_judecator, prenume_judecator, varsta, denumire_tribunal) 
    values (100, 'Gordon', 'Gilbert', 43, 'Tribunalul Bucuresti');
    
    insert into judecator (id_judecator, nume_judecator, prenume_judecator, varsta, denumire_tribunal) 
    values (101, 'Vincent', 'Horace', 32, 'Tribunalul Bruxelles');
    
    insert into judecator (id_judecator, nume_judecator, prenume_judecator, varsta, denumire_tribunal) 
    values (102, 'Villanova', 'Renata', 36, 'Tribunalul Madrid');
    
    insert into judecator (id_judecator, nume_judecator, prenume_judecator, varsta, denumire_tribunal) 
    values (103, 'Lehmann', 'Emmerich', 58, 'Tribunalul Berlin');
    
    insert into judecator (id_judecator, nume_judecator, prenume_judecator, varsta, denumire_tribunal) 
    values (104, 'Takayuki', 'Kawakami', 40, 'Tribunalul Tokyo');
    
    insert into judecator (id_judecator, nume_judecator, prenume_judecator, varsta, denumire_tribunal) 
    values (105, 'Lapusan', 'Livia', 54, 'Tribunalul Focsani');
    
    
    
    insert into hot_de_banci (id_hot, nume_hot, prenume_hot, varsta_hot) 
    values (405, 'Osborne', 'Kizzy', 45);
    
    insert into hot_de_banci (id_hot, nume_hot, prenume_hot, varsta_hot) 
    values (406, 'Armando', 'Anika', 54);
    
    insert into hot_de_banci (id_hot, nume_hot, prenume_hot, varsta_hot) 
    values (407, 'Derichs', 'Roelof', 42);
    
    insert into hot_de_banci (id_hot, nume_hot, prenume_hot, varsta_hot) 
    values (408, 'Spitznagel', 'Tania', 19);
    
    insert into hot_de_banci (id_hot, nume_hot, prenume_hot, varsta_hot) 
    values (409, 'Jerome', 'Veronika', 48);
    
    
    
    insert into judecator_sentinta_hot (id_judecator, id_sentinta, id_hot, data_acordarii) 
    values (100, 475, 405, to_date('17-Jun-00', 'DD-MON-RR'));
    
    insert into judecator_sentinta_hot (id_judecator, id_sentinta, id_hot, data_acordarii) 
    values (100, 476, 406, to_date('26-Mar-73', 'DD-MON-YY'));
    
    insert into judecator_sentinta_hot (id_judecator, id_sentinta, id_hot, data_acordarii) 
    values (100, 475, 407, to_date('13-Jan-98', 'DD-MON-YY'));
    
    insert into judecator_sentinta_hot (id_judecator, id_sentinta, id_hot, data_acordarii) 
    values (101, 477, 406, to_date('7-Dec-85', 'DD-MON-YY'));
    
    insert into judecator_sentinta_hot (id_judecator, id_sentinta, id_hot, data_acordarii) 
    values (102, 479, 409, to_date('15-Nov-95', 'DD-MON-YY'));
    
    insert into judecator_sentinta_hot (id_judecator, id_sentinta, id_hot, data_acordarii) 
    values (103, 478, 406, to_date('10-Apr-02', 'DD-MON-YY'));
    
    insert into judecator_sentinta_hot (id_judecator, id_sentinta, id_hot, data_acordarii) 
    values (104, 476, 409, to_date('12-Oct-08', 'DD-MON-YY'));
    
    insert into judecator_sentinta_hot (id_judecator, id_sentinta, id_hot, data_acordarii) 
    values (104, 477, 405, to_date('17-Jul-20', 'DD-MON-YY'));
    
    insert into judecator_sentinta_hot (id_judecator, id_sentinta, id_hot, data_acordarii) 
    values (104, 477, 406, to_date('25-May-09', 'DD-MON-YY'));
    
    insert into judecator_sentinta_hot (id_judecator, id_sentinta, id_hot, data_acordarii) 
    values (104, 479, 408, to_date('20-Jan-20', 'DD-MON-YY'));
    
    
    
    insert into banca (id_banca, denumire_banca, id_oras, id_tara) 
    values (500, 'Caixabank', 5, 'ES');
    
    insert into banca (id_banca, denumire_banca, id_oras, id_tara) 
    values (501, 'BCR', 2, 'RO');
    
    insert into banca (id_banca, denumire_banca, id_oras, id_tara) 
    values (502, 'Commerzbank', 3, 'DE');
    
    insert into banca (id_banca, denumire_banca, id_oras, id_tara) 
    values (503, 'Mizuho Bank', 1, 'JP');
    
    insert into banca (id_banca, denumire_banca, id_oras, id_tara) 
    values (504, 'Banque CPH', 4, 'BE');
    
    
    
    insert into client (id_client, id_banca, nume_client, prenume_client, varsta_client) 
    values (300, 502, 'Baaiman', 'Nadine', 47);
    
    insert into client (id_client, id_banca, nume_client, prenume_client, varsta_client) 
    values (301, 501, 'Gabrielli', 'Jaimie', 25);
    
    insert into client (id_client, id_banca, nume_client, prenume_client, varsta_client) 
    values (302, 503, 'Boucher', 'Denise', 56);
    
    insert into client (id_client, id_banca, nume_client, prenume_client, varsta_client) 
    values (303, 500, 'Foster', 'Paul', 72);
    
    insert into client (id_client, id_banca, nume_client, prenume_client, varsta_client) 
    values (304, 504, 'Oliviero', 'Renato', 30);
    
    
    
    insert into jaf (id_jaf, id_banca, data_jaf) 
    values (800, 503, to_date('17-Jan-73', 'DD-MON-YY'));
    
    insert into jaf (id_jaf, id_banca, data_jaf) 
    values (801, 504, to_date('5-Dec-85', 'DD-MON-YY'));
    
    insert into jaf (id_jaf, id_banca, data_jaf) 
    values (802, 502, to_date('13-Nov-95', 'DD-MON-YY'));
    
    insert into jaf (id_jaf, id_banca, data_jaf) 
    values (803, 500, to_date('7-Apr-02', 'DD-MON-YY'));
    
    insert into jaf (id_jaf, id_banca, data_jaf) 
    values (804, 501, to_date('9-Oct-08', 'DD-MON-YY'));
    
    insert into jaf (id_jaf, id_banca, data_jaf) 
    values (805, 504, to_date('20-May-09', 'DD-MON-YY'));
    
    insert into jaf (id_jaf, id_banca, data_jaf) 
    values (806, 502, to_date('15-Jul-20', 'DD-MON-YY'));
    
    
    
    insert into hot_jaf (id_jaf, id_hot, arma) 
    values (800, 406, 'pistol');
    
    insert into hot_jaf (id_jaf, id_hot, arma) 
    values (801, 406, 'cutit');
    
    insert into hot_jaf (id_jaf, id_hot, arma) 
    values (802, 409, 'mitraliera');
    
    insert into hot_jaf (id_jaf, id_hot, arma) 
    values (802, 407, 'pusca');
    
    insert into hot_jaf (id_jaf, id_hot, arma)  
    values (802, 405, 'pistol');
    
    insert into hot_jaf (id_jaf, id_hot, arma) 
    values (803, 406, 'cutit');
    
    insert into hot_jaf (id_jaf, id_hot, arma) 
    values (804, 409, 'electrosoc');
    
    insert into hot_jaf (id_jaf, id_hot, arma) 
    values (805, 406, 'electrosoc');
    
    insert into hot_jaf (id_jaf, id_hot, arma) 
    values (806, 405, 'pistol');
    
    insert into hot_jaf (id_jaf, id_hot, arma) 
    values (806, 408, 'spray paralizant');
    
    
    
    insert into martor (id_martor, nume_martor, prenume_martor, varsta_martor) 
    values (305, 'Norman', 'Valerie', 23);
    
    insert into martor (id_martor, nume_martor, prenume_martor, varsta_martor) 
    values (306, 'Snow', 'Clarence', 68);
    
    insert into martor (id_martor, nume_martor, prenume_martor, varsta_martor) 
    values (307, 'Mendez', 'Andrea', 40);
    
    insert into martor (id_martor, nume_martor, prenume_martor, varsta_martor) 
    values (308, 'Wu', 'Viktoria', 34);
    
    insert into martor (id_martor, nume_martor, prenume_martor, varsta_martor) 
    values (309, 'Mendez', 'Erik', 49);
    
    insert into martor (id_martor, nume_martor, prenume_martor) 
    values (310, 'Dumitrescu', 'Dragos');
    
    
    
    insert into sectie_politie (id_sectie, denumire_sectie) 
    values (600, 'Politia municipala Madrid');
    
    insert into sectie_politie (id_sectie, denumire_sectie) 
    values (601, 'Departamentul de politie Berlin');
    
    insert into sectie_politie (id_sectie, denumire_sectie) 
    values (602, 'Sectia de politie Saint Gilles');
    
    insert into sectie_politie (id_sectie, denumire_sectie) 
    values (603, 'Sectia de politie Osaka');
    
    insert into sectie_politie (id_sectie, denumire_sectie) 
    values (604, 'Sectia 2 Politie');
    
    
    
    insert into politist (id_politist, id_sectie, nume_politist, prenume_politist, varsta_politist, data_angajarii) 
    values (605, 600, 'Gimenez', 'Alejandro', 47, to_date('14-Jan-92', 'DD-MON-YY'));
    
    insert into politist (id_politist, id_sectie, nume_politist, prenume_politist, varsta_politist, data_angajarii) 
    values (606, 601, 'Herrmann', 'Loreley', 75, to_date('25-Feb-64', 'DD-MON-YY'));
    
    insert into politist (id_politist, id_sectie, nume_politist, prenume_politist, varsta_politist, data_angajarii) 
    values (607, 602, 'Piette', 'Janne', 63, to_date('1-Jun-76', 'DD-MON-YY'));
    
    insert into politist (id_politist, id_sectie, nume_politist, prenume_politist, varsta_politist, data_angajarii) 
    values (608, 603, 'Iwamoto', 'Nishikawa', 48, to_date('11-Feb-91', 'DD-MON-YY'));
    
    insert into politist (id_politist, id_sectie, nume_politist, prenume_politist, varsta_politist, data_angajarii) 
    values (609, 604, 'Voiculescu', 'Alina', 30, to_date('1-Mar-09', 'DD-MON-YY'));
    
    insert into politist (id_politist, id_sectie, nume_politist, prenume_politist, varsta_politist, data_angajarii) 
    values (610, 604, 'Dumitrescu', 'Dragos', 38, to_date('1-Jun-05', 'DD-MON-YY'));
    
    
    
    insert into martor_jaf (id_jaf, id_martor) 
    values (800, 306);
    
    insert into martor_jaf (id_jaf, id_martor) 
    values (801, 306);
    
    insert into martor_jaf (id_jaf, id_martor) 
    values (802, 307);
    
    insert into martor_jaf (id_jaf, id_martor) 
    values (802, 309);
    
    insert into martor_jaf (id_jaf, id_martor) 
    values (803, 305);
    
    insert into martor_jaf (id_jaf, id_martor) 
    values (804, 308);
    
    insert into martor_jaf (id_jaf, id_martor) 
    values (804, 305);
    
    insert into martor_jaf (id_jaf, id_martor) 
    values (805, 308);
    
    insert into martor_jaf (id_jaf, id_martor) 
    values (806, 308);
    
    insert into martor_jaf (id_jaf, id_martor) 
    values (806, 309);
    
    
    
    insert into arestare_hot (id_hot, id_politist, data_arestarii) 
    values (405, 605, to_date('30-Jun-00', 'DD-MON-YY'));
    
    insert into arestare_hot (id_hot, id_politist, data_arestarii) 
    values (405, 609, to_date('20-Jul-20', 'DD-MON-YY'));
    
    insert into arestare_hot (id_hot, id_politist, data_arestarii) 
    values (406, 606, to_date('5-Apr-73', 'DD-MON-YY'));
    
    insert into arestare_hot (id_hot, id_politist, data_arestarii) 
    values (406, 607, to_date('30-Dec-85', 'DD-MON-YY'));
    
    insert into arestare_hot (id_hot, id_politist, data_arestarii) 
    values (406, 605, to_date('25-Apr-02', 'DD-MON-YY'));
    
    insert into arestare_hot (id_hot, id_politist, data_arestarii) 
    values (406, 609, to_date('26-May-09', 'DD-MON-YY'));
    
    insert into arestare_hot (id_hot, id_politist, data_arestarii) 
    values (407, 608, to_date('29-Jan-98', 'DD-MON-YY'));
    
    insert into arestare_hot (id_hot, id_politist, data_arestarii) 
    values (408, 609, to_date('27-Jan-20', 'DD-MON-YY'));
    
    insert into arestare_hot (id_hot, id_politist, data_arestarii) 
    values (409, 608, to_date('15-Dec-95', 'DD-MON-YY'));
    
    insert into arestare_hot (id_hot, id_politist, data_arestarii) 
    values (409, 609, to_date('15-Oct-08', 'DD-MON-YY'));
    
    commit;

end;
/

-------------
------6------
-------------
--Formulati in limbaj natural o problema pe care sa o rezolvati folosind un
--subprogram stocat care sa utilizeze doua tipuri de colectie studiate.
--Apelati subprogramul.

--Cerinta:
---Afisati numele, prenumele, varsta, data angajarii si toti hotii de banci
---arestati de politistii care au peste 45 de ani. De asemenea, in cazul in
---care au fost angajati in zi de weekend, sa se modifice data angajarii,
---astfel incat sa fie inregistrata in baza de date urmatoarea zi de luni
---de la data actuala a angajarii.

create or replace procedure politisti_peste45 as
    type hoti is varray(10) of varchar2(30);
    type despre_politisti is record (id politist.id_politist%type,
                                     nume politist.nume_politist%type,
                                     prenume politist.prenume_politist%type,
                                     varsta politist.varsta_politist%type,
                                     data_angajarii politist.data_angajarii%type);
                                     
    type hoti_prinsi is table of hoti index by pls_integer;
    type politisti is table of despre_politisti index by pls_integer;
    
    v_hoti hoti_prinsi;
    v_politisti politisti;
    
begin
    select id_politist, nume_politist, prenume_politist, varsta_politist, data_angajarii
    bulk collect into v_politisti
    from politist
    where varsta_politist > 45;
    
    for i in v_politisti.first..v_politisti.last loop
        select nume_hot "Nume hot"
        bulk collect into v_hoti(i)
        from hot_de_banci h
        join arestare_hot a on (a.id_hot = h.id_hot)
        join politist p on (p.id_politist = a.id_politist)
        where p.id_politist = v_politisti(i).id;
    end loop;
    
    for i in v_politisti.first..v_politisti.last loop
        dbms_output.put_line(v_politisti(i).nume || ' ' || v_politisti(i).prenume || ', ' || v_politisti(i).varsta || ' ani, angajat la data de ' || v_politisti(i).data_angajarii);
        
        if v_hoti(i).count = 0 then
            dbms_output.put_line('Nu exista niciun hot arestat de aceasta persoana.');
        else
            dbms_output.put_line('Hotii arestati:');
            
            for j in v_hoti(i).first..v_hoti(i).last loop
                dbms_output.put_line(v_hoti(i)(j));
            end loop;
        end if;
        
        dbms_output.new_line;
    end loop;
    
    forall i in v_politisti.first..v_politisti.last
        update politist
        set data_angajarii = next_day(data_angajarii, 'Monday')
        where id_politist = v_politisti(i).id
        and (to_char(data_angajarii, 'Day') like 'Saturday%'
        or to_char(data_angajarii, 'Day') like 'Sunday%');
end politisti_peste45;
/

--apelare
begin
    politisti_peste45;
end;
/

-------------
------7------
-------------
--Formulati in limbaj natural o problema pe care sa o rezolvati folosind un
--subprogram stocat care sa utilizeze un tip de cursor studiat.
--Apelati subprogramul.

--Cerinta:
---Sa se afiseze, pentru fiecare banca, jafurile care au avut loc de-a lungul
---timpului, alaturi de numele si prenumele martorilor care au asistat la acestea.

create or replace procedure banca_jafuri_martori as
    type refcursor is ref cursor;
    cursor c_banca is select id_banca, denumire_banca, cursor (select id_jaf
                                                               from jaf j
                                                               where j.id_banca = b.id_banca)
                      from banca b;
    
    cursor c_martori(v_id_jaf jaf.id_jaf%type) is select nume_martor, prenume_martor
                                                  from martor_jaf mj, martor m
                                                  where mj.id_martor = m.id_martor
                                                  and mj.id_jaf = v_id_jaf;
    v_id_banca banca.id_banca%type;
    v_denumire_banca banca.denumire_banca%type;
    v_cursor refcursor;
    v_id_jaf jaf.id_jaf%type;
begin
    open c_banca;
    
    loop
        fetch c_banca into v_id_banca, v_denumire_banca, v_cursor;
        exit when c_banca%notfound;
        
        dbms_output.put_line('Banca: ' || v_denumire_banca);
        
        loop
            fetch v_cursor into v_id_jaf;
            exit when v_cursor%notfound;
            
            if v_cursor%notfound and v_cursor%rowcount = 0 then
                dbms_output.put_line('--Pentru aceasta banca nu sunt inregistrare jafuri.');
            end if;
            
            dbms_output.put_line('--Jaf: ' || v_id_jaf);
            
            dbms_output.put_line('----Martori: ');
            for i in c_martori(v_id_jaf) loop
                dbms_output.put_line('------' || i.nume_martor || ' ' || i.prenume_martor);
            end loop;
        
        end loop;
        
        dbms_output.new_line;
        dbms_output.new_line;
        
    end loop;

    close c_banca;
end banca_jafuri_martori;
/

--apelare
begin
    banca_jafuri_martori;
end;
/

-------------
------8------
-------------
--Formulati in limbaj natural o problema pe care sa o rezolvati folosind un
--subprogram stocat de tip functie care sa utilizeze intr-o singura comanda
--SQL 3 dintre tabelele definite. Tratati toate exceptiile care pot aparea.
--Apelati subprogramul astfel incat sa evidentiati toate cazurile tratate.

--Cerinta:
---Sa se creeze o functie care returneaza varsta primului raufacator prins
---de politistul primit ca parametru (numele si prenumele politistului).
---Tratati toate cazurile posibile.

create or replace function varsta_prim_hot(v_nume_politist politist.nume_politist%type,
                                           v_prenume_politist politist.prenume_politist%type)
return varchar2 is
    v_varsta_hot number;
    exista_politist number;
    
    no_cop_found exception;
    pragma exception_init(no_cop_found, -20002);
begin
    select count(*)
    into exista_politist
    from politist
    where nume_politist = v_nume_politist
    and prenume_politist = v_prenume_politist;
    
    if exista_politist = 0 then
        raise_application_error(-20002, 'Nu exista niciun politist cu acest nume.');
    end if;
    
    select varsta_hot
    into v_varsta_hot
    from politist p
    join arestare_hot a on (a.id_politist = p.id_politist)
    join hot_de_banci h on (a.id_hot = h.id_hot)
    where h.id_hot = (select id_hot
                      from arestare_hot
                      where data_arestarii = (select DataArest
                                              from (select id_politist, min(data_arestarii) as DataArest
                                                    from arestare_hot
                                                    group by id_politist)
                                              where id_politist = p.id_politist))
    and nume_politist = v_nume_politist
    and prenume_politist = v_prenume_politist
    group by nume_politist, varsta_hot;
    
    return 'Primul raufacator prins de politistul dat are ' || to_char(v_varsta_hot) || ' ani.';
exception
    when NO_DATA_FOUND then
        return 'Nu exista niciun raufacator prins de ' || v_nume_politist || ' ' || v_prenume_politist || '.';
        
    when TOO_MANY_ROWS then
        return 'Politistul ' || v_nume_politist || ' ' || v_prenume_politist || ' a arestat mai mult de un "prim" infractor.';
    
    when others then
        return 'Alta eroare: ' || sqlerrm;
end varsta_prim_hot;
/

--mesaj returnat: "Primul raufacator prins de politistul dat are 45 ani."
begin
    dbms_output.put_line(varsta_prim_hot('Gimenez', 'Alejandro'));
end;
/

--mesaj returnat: "Nu exista niciun raufacator prins de Dumitrescu Dragos."
begin
    dbms_output.put_line(varsta_prim_hot('Dumitrescu', 'Dragos'));
end;
/

--mesaj returnat: "Alta eroare: ORA-20002: Nu exista niciun politist cu acest nume."
begin
    dbms_output.put_line(varsta_prim_hot('Nume', 'Prenume'));
end;
/


-------------
------9------
-------------
--Formulati in limbaj natural o problema pe care sa o rezolvati folosind
--un subprogram stocat de tip procedura care sa utilizeze intr-o singura
--comanda SQL 5 dintre tabelele definite. Tratati toate exceptiile care
--pot aparea, incluzand exceptiile NO_DATA_FOUND si TOO_MANY_ROWS.
--Apelati subprogramul astfel incat sa evidentiati toate cazurile tratate.

--Cerinta:
---Sa se afiseze denumirea tarilor in care se afla inchisorile in care
---au mers/vor merge hotii a caror sentinta a fost stabilita de judecatorul
---dat ca parametru, alaturi de numele fiecaruia. Afisati, apoi, numele
---celui mai periculos hot (cel cu cea mai mare sentinta) judecat de
---persoana primita ca parametru. In cazul in care exista mai multi hoti cu
---sentinta egala, va fi afisat cel mai tanar dintre ei. De asemenea, cresteti
---cu 1 varsta tuturor hotilor judecati de persoana data ca parametru. Tratati
---toate exceptiile/cazurile care pot aparea, returnand un mesaj corespunzator.

create or replace procedure cel_mai_periculos_hot(v_nume_judecator judecator.nume_judecator%type,
                                                  v_prenume_judecator judecator.prenume_judecator%type) as
    type nume is table of varchar2(50);
    type luni is table of number;

    v_nume_hoti nume := nume();
    v_prenume_hoti nume := nume();
    v_denumire_tari nume := nume();
    v_sentinta luni := luni();
    
    v_nume_hot_periculos nume := nume();
    v_prenume_hot_periculos nume := nume();
    
    sentinta_max sentinta.luni_de_inchisoare%type := -1;
    exista_judecator number := 0;
    
    no_judge_found exception;
    pragma exception_init(no_judge_found, -20001);
begin
    select count(*)
    into exista_judecator
    from judecator
    where nume_judecator = v_nume_judecator
    and prenume_judecator = v_prenume_judecator;
    
    if exista_judecator = 0 then
        raise_application_error(-20001, 'Nu exista niciun judecator cu acest nume.');
    end if;
    
    select nume_hot, prenume_hot, denumire_tara, luni_de_inchisoare
    bulk collect into v_nume_hoti, v_prenume_hoti, v_denumire_tari, v_sentinta
    from tara
    join oras using (id_tara)
    join inchisoare using (id_oras)
    join sentinta using (id_inchisoare)
    join judecator_sentinta_hot using (id_sentinta)
    join judecator using (id_judecator)
    join hot_de_banci using (id_hot)
    where nume_judecator = v_nume_judecator
    and prenume_judecator = v_prenume_judecator
    order by varsta_hot;

    select max(luni_de_inchisoare)
    into sentinta_max
    from tara
    join oras using (id_tara)
    join inchisoare using (id_oras)
    join sentinta using (id_inchisoare)
    join judecator_sentinta_hot using (id_sentinta)
    join judecator using (id_judecator)
    join hot_de_banci using (id_hot)
    where nume_judecator = v_nume_judecator
    and prenume_judecator = v_prenume_judecator;

    if cardinality(v_nume_hoti) <> 0 then
        dbms_output.put_line('Judecatorul ' || v_nume_judecator || ' ' || v_prenume_judecator || ':');
    end if;

    if v_nume_hoti.exists(v_nume_hoti.first) then
        for i in v_nume_hoti.first..v_nume_hoti.last loop
            dbms_output.put_line(v_nume_hoti(i) || ' ' || v_prenume_hoti(i) || ', ' || v_denumire_tari(i));

            if v_sentinta(i) = sentinta_max then
                v_nume_hot_periculos.extend;
                v_nume_hot_periculos(v_nume_hot_periculos.last) := v_nume_hoti(i);
            
                v_prenume_hot_periculos.extend;
                v_prenume_hot_periculos(v_prenume_hot_periculos.last) := v_prenume_hoti(i);
            end if;
        end loop;
    end if;
    
    dbms_output.new_line;
    
    if v_nume_hoti.exists(v_nume_hoti.first) then
        forall i in v_nume_hoti.first..v_nume_hoti.last
            update hot_de_banci
            set varsta_hot = varsta_hot + 1
            where nume_hot = v_nume_hoti(i)
            and prenume_hot = v_prenume_hoti(i);
    end if;

    if v_nume_hot_periculos.count = 1 then
        dbms_output.put_line('Cel mai periculos hot: ' || v_nume_hot_periculos(1) || ' ' || v_prenume_hot_periculos(1));
    elsif v_nume_hot_periculos.count = 0 or sentinta_max = -1 then
        raise NO_DATA_FOUND;
    else
        raise TOO_MANY_ROWS;
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('Nu exista niciun hot judecat de ' || v_nume_judecator || ' ' || v_prenume_judecator || '.');
        
    when TOO_MANY_ROWS then
        dbms_output.put_line('Exista mai multi hoti la fel de periculosi judecati de ' || v_nume_judecator || ' ' || v_prenume_judecator || '.');
        dbms_output.put_line('Cel mai periculos este, totusi: ' || v_nume_hot_periculos(1) || ' ' || v_prenume_hot_periculos(1));

    when others then
        dbms_output.put_line('Alta eroare: ' || sqlerrm);
end cel_mai_periculos_hot;
/

--apelare: 1 hot cu sentinta maxima
select nume_hot, prenume_hot, denumire_tara, luni_de_inchisoare, varsta_hot
from tara
join oras using (id_tara)
join inchisoare using (id_oras)
join sentinta using (id_inchisoare)
join judecator_sentinta_hot using (id_sentinta)
join judecator using (id_judecator)
join hot_de_banci using (id_hot)
where nume_judecator = 'Gordon'
and prenume_judecator = 'Gilbert'
order by varsta_hot asc, luni_de_inchisoare desc;

begin
    cel_mai_periculos_hot('Gordon', 'Gilbert');
end;
/

select nume_hot, prenume_hot, denumire_tara, luni_de_inchisoare, varsta_hot
from tara
join oras using (id_tara)
join inchisoare using (id_oras)
join sentinta using (id_inchisoare)
join judecator_sentinta_hot using (id_sentinta)
join judecator using (id_judecator)
join hot_de_banci using (id_hot)
where nume_judecator = 'Gordon'
and prenume_judecator = 'Gilbert'
order by varsta_hot asc, luni_de_inchisoare desc;

rollback;

--apelare: 2 hoti cu sentinta maxima (TOO_MANY_ROWS)
select nume_hot, prenume_hot, denumire_tara, luni_de_inchisoare, varsta_hot
from tara
join oras using (id_tara)
join inchisoare using (id_oras)
join sentinta using (id_inchisoare)
join judecator_sentinta_hot using (id_sentinta)
join judecator using (id_judecator)
join hot_de_banci using (id_hot)
where nume_judecator = 'Takayuki'
and prenume_judecator = 'Kawakami'
order by varsta_hot asc, luni_de_inchisoare desc;

begin
    cel_mai_periculos_hot('Takayuki', 'Kawakami');
end;
/

select nume_hot, prenume_hot, denumire_tara, luni_de_inchisoare, varsta_hot
from tara
join oras using (id_tara)
join inchisoare using (id_oras)
join sentinta using (id_inchisoare)
join judecator_sentinta_hot using (id_sentinta)
join judecator using (id_judecator)
join hot_de_banci using (id_hot)
where nume_judecator = 'Takayuki'
and prenume_judecator = 'Kawakami'
order by varsta_hot asc, luni_de_inchisoare desc;

rollback;

--apelare: niciun hot judecat (NO_DATA_FOUND)
begin
    cel_mai_periculos_hot('Lapusan', 'Livia');
end;
/

--apelare: nu exista judecatorul (OTHER ERROR)
begin
    cel_mai_periculos_hot('Nume', 'Prenume');
end;
/

--------------
------10------
--------------
--Definiti un trigger de tip LMD la nivel de comanda. Declansati trigger-ul.

--Cerinta:
---Definiti un declansator de tip LMD la nivel de comanda care permite inserarea,
---actualizarea si stergerea datelor din tabela SENTINTA doar in intervalul orar
---6:00 - 20:59, de luni pana vineri. De asemenea, sa se permita stergerea
---informatiilor din tabelul SENTINTA doar utilizatorului ADMIN.
---Comenzile care s-au executat cu succes sa se introduca in tabelul INFO_SENTINTA,
---alaturi de user-ul care a executat comanda, data executarii si denumirea comenzii.

drop sequence seq_info;
drop table info_sentinta;

create sequence seq_info
increment by 1
start with 1
nocache
nocycle;

create table info_sentinta (id int primary key,
                            utilizator varchar2(30),
                            data date,
                            comanda varchar2(100));

create or replace trigger restrictie_interval_orar_si_user
for insert or update or delete on sentinta
compound trigger
before statement is
    begin
        if (to_char(sysdate, 'D') = 7) or (to_char(sysdate, 'D') = 1) or (to_char(sysdate, 'HH24') not between 6 and 20) then
            raise_application_error(-20003, 'Tabelul SENTINTA nu poate fi actualizat in afara orelor de program!');
        end if;
        
        if deleting then
            if user <> 'ADMIN' then
                raise_application_error(-20004, 'Dvs sunteti ' || user || '. Nu aveti voie sa stergeti informatii din acest tabel. Doar ADMIN-ul are voie.');
            end if;
        end if;
    end before statement;

after statement is
    begin
        if inserting then
            insert into info_sentinta
            values (seq_info.nextval, sys.login_user, sysdate, 'INSERT');
        elsif updating then
            insert into info_sentinta
            values (seq_info.nextval, sys.login_user, sysdate, 'UPDATE');
        elsif deleting then
            insert into info_sentinta
            values (seq_info.nextval, sys.login_user, sysdate, 'DELETE');
        end if;
    end after statement;
end;
/

insert into sentinta (id_sentinta, luni_de_inchisoare, id_inchisoare) 
values (480, 500, 124);

delete from sentinta
where id_sentinta = 480
and luni_de_inchisoare = 500
and id_inchisoare = 124;

select * from info_sentinta;

drop trigger restrictie_interval_orar_si_user;

rollback;
--------------
------11------
--------------
--Definiti un trigger de tip LMD la nivel de linie. Declansati trigger-ul.

--Cerinta 1:
---Definiti un declansator de tip LMD la nivel de linie care sa nu permita
---judecarea unui hot de mai mult de doua ori de aceeasi persoana
---(acelasi judecator).

create or replace trigger hot_rejudecat
before insert on judecator_sentinta_hot
for each row
declare
    v_nr_judecari number := 0;
begin
    select count(*)
    into v_nr_judecari
    from judecator_sentinta_hot
    where id_hot = :NEW.id_hot
    and id_judecator = :NEW.id_judecator
    group by id_hot, id_judecator;
    
    if v_nr_judecari = 2 then
        raise_application_error(-20005, 'Hotul trebuie rejudecat de alta persoana. Un judecator poate da sentinte de maxim 2 ori unui anumit hot!');
    end if;
end;
/

--La momentul actual, hotul cu id-ul 405 a fost judecat o singura data de judecatorul cu id-ul 100
--Dovada:
select count(*) "Numar judecari"
from judecator_sentinta_hot
where id_hot = 405
and id_judecator = 100
group by id_hot, id_judecator;

--a doua judecare: OK!
insert into judecator_sentinta_hot
values (100, 478, 405, sysdate);

--a treia judecare: EROARE!
insert into judecator_sentinta_hot
values (100, 479, 405, sysdate);

rollback;

drop trigger hot_rejudecat;

--Cerinta 2:
---Definiti un declansator de tip LMD la nivel de linie care sa nu permita
---micsorarea varstei clientilor, si nici marirea varstei cu mai mult de
---un an. De asemenea, sa nu se poata sa se introduca un client cu o
---varsta mai mica de 18 ani.

create or replace trigger restrictii_clienti
before insert or update of varsta_client on client
for each row
when (NEW.varsta_client < 18 or
      NEW.varsta_client < nvl(OLD.varsta_client,NEW.varsta_client - 1) or
      NEW.varsta_client > nvl(OLD.varsta_client,NEW.varsta_client - 1) + 1)
declare
    v_varsta number;
begin
    raise_application_error(-20005, 'Varsta clientului nu poate avea acea valoare!');
end;
/

--inserare client cu varsta de 10 ani: EROARE
insert into client
values (305, 500, 'Nume', 'Prenume', 10);

--marire varsta client cu mai mult de 1 an: EROARE
update client
set varsta_client = varsta_client + 3
where id_client = 304;

--micsorare varsta client: EROARE
update client
set varsta_client = varsta_client - 1
where id_client = 304;

drop trigger restrictii_clienti;

--------------
------12------
--------------
--Definiti un trigger de tip LDD. Declansati trigger-ul.

--Cerinta:
---Sa se defineasca un declansator care are rolul de a bloca orice eventuala modificare asupra
---bazei de date. Se va defini un tabel de tip audit numit INFO_INCERCARI, care va contine
---toate incercarile de modificare a bazei de date (user-ul, evenimentul incercat, data incercarii
---si numele obiectului).

drop sequence seq_info;
drop table info_incercari;

create sequence seq_info
increment by 1
start with 1
nocache
nocycle;

create table info_incercari(id int primary key,
                            utilizator varchar2(30),
                            eveniment varchar2(20),
                            nume_obiect varchar2(100),
                            data date);
/

create or replace trigger fara_alte_modificari
after create or drop or alter on database
declare
    pragma autonomous_transaction;
begin
    insert into info_incercari
    values (seq_info.nextval, sys.login_user, sys.sysevent, sys.dictionary_obj_name, sysdate);
    
    commit;
    
    raise_application_error(-20006, 'Baza de date este deja in forma finala, nemaiputand fi editata.');
end;
/

drop table martor cascade constraints;

select * from info_incercari;

drop trigger fara_alte_modificari;

--------------
------13------
--------------
--Definiti un pachet care sa contina toate obiectele definite în
--cadrul proiectului.

create or replace package pkg as
    procedure politisti_peste45;
    
    procedure banca_jafuri_martori;
    
    function varsta_prim_hot(v_nume_politist politist.nume_politist%type,
                             v_prenume_politist politist.prenume_politist%type)
    return varchar2;
                             
    procedure cel_mai_periculos_hot(v_nume_judecator judecator.nume_judecator%type,
                                    v_prenume_judecator judecator.prenume_judecator%type);
end pkg;
/

create or replace package body pkg as
    procedure politisti_peste45 as
        type hoti is varray(10) of varchar2(30);
        type despre_politisti is record (id politist.id_politist%type,
                                         nume politist.nume_politist%type,
                                         prenume politist.prenume_politist%type,
                                         varsta politist.varsta_politist%type,
                                         data_angajarii politist.data_angajarii%type);
                                         
        type hoti_prinsi is table of hoti index by pls_integer;
        type politisti is table of despre_politisti index by pls_integer;
        
        v_hoti hoti_prinsi;
        v_politisti politisti;
        
    begin
        select id_politist, nume_politist, prenume_politist, varsta_politist, data_angajarii
        bulk collect into v_politisti
        from politist
        where varsta_politist > 45;
        
        for i in v_politisti.first..v_politisti.last loop
            select nume_hot "Nume hot"
            bulk collect into v_hoti(i)
            from hot_de_banci h
            join arestare_hot a on (a.id_hot = h.id_hot)
            join politist p on (p.id_politist = a.id_politist)
            where p.id_politist = v_politisti(i).id;
        end loop;
        
        for i in v_politisti.first..v_politisti.last loop
            dbms_output.put_line(v_politisti(i).nume || ' ' || v_politisti(i).prenume || ', ' || v_politisti(i).varsta || ' ani, angajat la data de ' || v_politisti(i).data_angajarii);
            
            if v_hoti(i).count = 0 then
                dbms_output.put_line('Nu exista niciun hot arestat de aceasta persoana.');
            else
                dbms_output.put_line('Hotii arestati:');
                
                for j in v_hoti(i).first..v_hoti(i).last loop
                    dbms_output.put_line(v_hoti(i)(j));
                end loop;
            end if;
            
            dbms_output.new_line;
        end loop;
        
        forall i in v_politisti.first..v_politisti.last
            update politist
            set data_angajarii = next_day(data_angajarii, 'Monday')
            where id_politist = v_politisti(i).id
            and (to_char(data_angajarii, 'Day') like 'Saturday%'
            or to_char(data_angajarii, 'Day') like 'Sunday%');
    end politisti_peste45;

---------------------------------------------------------------------------------------------------------------

    procedure banca_jafuri_martori as
        type refcursor is ref cursor;
        cursor c_banca is select id_banca, denumire_banca, cursor (select id_jaf
                                                                   from jaf j
                                                                   where j.id_banca = b.id_banca)
                          from banca b;
        
        cursor c_martori(v_id_jaf jaf.id_jaf%type) is select nume_martor, prenume_martor
                                                      from martor_jaf mj, martor m
                                                      where mj.id_martor = m.id_martor
                                                      and mj.id_jaf = v_id_jaf;
        v_id_banca banca.id_banca%type;
        v_denumire_banca banca.denumire_banca%type;
        v_cursor refcursor;
        v_id_jaf jaf.id_jaf%type;
    begin
        open c_banca;
        
        loop
            fetch c_banca into v_id_banca, v_denumire_banca, v_cursor;
            exit when c_banca%notfound;
            
            dbms_output.put_line('Banca: ' || v_denumire_banca);
            
            loop
                fetch v_cursor into v_id_jaf;
                exit when v_cursor%notfound;
                
                if v_cursor%notfound and v_cursor%rowcount = 0 then
                    dbms_output.put_line('--Pentru aceasta banca nu sunt inregistrare jafuri.');
                end if;
                
                dbms_output.put_line('--Jaf: ' || v_id_jaf);
                
                dbms_output.put_line('----Martori: ');
                for i in c_martori(v_id_jaf) loop
                    dbms_output.put_line('------' || i.nume_martor || ' ' || i.prenume_martor);
                end loop;
            
            end loop;
            
            dbms_output.new_line;
            dbms_output.new_line;
            
        end loop;
    
        close c_banca;
    end banca_jafuri_martori;
    
---------------------------------------------------------------------------------------------------------------

    function varsta_prim_hot(v_nume_politist politist.nume_politist%type,
                             v_prenume_politist politist.prenume_politist%type)
    return varchar2 is
        v_varsta_hot number;
        exista_politist number;
        
        no_cop_found exception;
        pragma exception_init(no_cop_found, -20002);
    begin
        select count(*)
        into exista_politist
        from politist
        where nume_politist = v_nume_politist
        and prenume_politist = v_prenume_politist;
        
        if exista_politist = 0 then
            raise_application_error(-20002, 'Nu exista niciun politist cu acest nume.');
        end if;
        
        select varsta_hot
        into v_varsta_hot
        from politist p
        join arestare_hot a on (a.id_politist = p.id_politist)
        join hot_de_banci h on (a.id_hot = h.id_hot)
        where h.id_hot = (select id_hot
                          from arestare_hot
                          where data_arestarii = (select DataArest
                                                  from (select id_politist, min(data_arestarii) as DataArest
                                                        from arestare_hot
                                                        group by id_politist)
                                                  where id_politist = p.id_politist))
        and nume_politist = v_nume_politist
        and prenume_politist = v_prenume_politist
        group by nume_politist, varsta_hot;
        
        return 'Primul raufacator prins de politistul dat are ' || to_char(v_varsta_hot) || ' ani.';
    exception
        when NO_DATA_FOUND then
            return 'Nu exista niciun raufacator prins de ' || v_nume_politist || ' ' || v_prenume_politist || '.';
            
        when TOO_MANY_ROWS then
            return 'Politistul ' || v_nume_politist || ' ' || v_prenume_politist || ' a arestat mai mult de un "prim" infractor.';
        
        when others then
            return 'Alta eroare: ' || sqlerrm;
    end varsta_prim_hot;

---------------------------------------------------------------------------------------------------------------

    procedure cel_mai_periculos_hot(v_nume_judecator judecator.nume_judecator%type,
                                    v_prenume_judecator judecator.prenume_judecator%type) as
        type nume is table of varchar2(50);
        type luni is table of number;
    
        v_nume_hoti nume := nume();
        v_prenume_hoti nume := nume();
        v_denumire_tari nume := nume();
        v_sentinta luni := luni();
        
        v_nume_hot_periculos nume := nume();
        v_prenume_hot_periculos nume := nume();
        
        sentinta_max sentinta.luni_de_inchisoare%type := -1;
        exista_judecator number := 0;
        
        no_judge_found exception;
        pragma exception_init(no_judge_found, -20001);
    begin
        select count(*)
        into exista_judecator
        from judecator
        where nume_judecator = v_nume_judecator
        and prenume_judecator = v_prenume_judecator;
        
        if exista_judecator = 0 then
            raise_application_error(-20001, 'Nu exista niciun judecator cu acest nume.');
        end if;
        
        select nume_hot, prenume_hot, denumire_tara, luni_de_inchisoare
        bulk collect into v_nume_hoti, v_prenume_hoti, v_denumire_tari, v_sentinta
        from tara
        join oras using (id_tara)
        join inchisoare using (id_oras)
        join sentinta using (id_inchisoare)
        join judecator_sentinta_hot using (id_sentinta)
        join judecator using (id_judecator)
        join hot_de_banci using (id_hot)
        where nume_judecator = v_nume_judecator
        and prenume_judecator = v_prenume_judecator
        order by varsta_hot;
    
        select max(luni_de_inchisoare)
        into sentinta_max
        from tara
        join oras using (id_tara)
        join inchisoare using (id_oras)
        join sentinta using (id_inchisoare)
        join judecator_sentinta_hot using (id_sentinta)
        join judecator using (id_judecator)
        join hot_de_banci using (id_hot)
        where nume_judecator = v_nume_judecator
        and prenume_judecator = v_prenume_judecator;
    
        if cardinality(v_nume_hoti) <> 0 then
            dbms_output.put_line('Judecatorul ' || v_nume_judecator || ' ' || v_prenume_judecator || ':');
        end if;
    
        if v_nume_hoti.exists(v_nume_hoti.first) then
            for i in v_nume_hoti.first..v_nume_hoti.last loop
                dbms_output.put_line(v_nume_hoti(i) || ' ' || v_prenume_hoti(i) || ', ' || v_denumire_tari(i));
    
                if v_sentinta(i) = sentinta_max then
                    v_nume_hot_periculos.extend;
                    v_nume_hot_periculos(v_nume_hot_periculos.last) := v_nume_hoti(i);
                
                    v_prenume_hot_periculos.extend;
                    v_prenume_hot_periculos(v_prenume_hot_periculos.last) := v_prenume_hoti(i);
                end if;
            end loop;
        end if;
        
        dbms_output.new_line;
        
        if v_nume_hoti.exists(v_nume_hoti.first) then
            forall i in v_nume_hoti.first..v_nume_hoti.last
                update hot_de_banci
                set varsta_hot = varsta_hot + 1
                where nume_hot = v_nume_hoti(i)
                and prenume_hot = v_prenume_hoti(i);
        end if;
    
        if v_nume_hot_periculos.count = 1 then
            dbms_output.put_line('Cel mai periculos hot: ' || v_nume_hot_periculos(1) || ' ' || v_prenume_hot_periculos(1));
        elsif v_nume_hot_periculos.count = 0 or sentinta_max = -1 then
            raise NO_DATA_FOUND;
        else
            raise TOO_MANY_ROWS;
        end if;
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Nu exista niciun hot judecat de ' || v_nume_judecator || ' ' || v_prenume_judecator || '.');
            
        when TOO_MANY_ROWS then
            dbms_output.put_line('Exista mai multi hoti la fel de periculosi judecati de ' || v_nume_judecator || ' ' || v_prenume_judecator || '.');
            dbms_output.put_line('Cel mai periculos este, totusi: ' || v_nume_hot_periculos(1) || ' ' || v_prenume_hot_periculos(1));
    
        when others then
            dbms_output.put_line('Alta eroare: ' || sqlerrm);
    end cel_mai_periculos_hot;
end pkg;
/

--apelarea in diverse moduri (SQL si PL/SQL)
exec pkg.politisti_peste45;

execute pkg.banca_jafuri_martori;

select pkg.varsta_prim_hot('Gimenez', 'Alejandro') "Varsta primului hot prins de politistul dat"
from dual;

begin
    pkg.cel_mai_periculos_hot('Takayuki', 'Kawakami');
end;
/


--------------
------14------
--------------
--Definiti un pachet care sa includa tipuri de date complexe si obiecte necesare unui flux
--de actiuni integrate, specifice bazei de date definite (minim 2 tipuri de date, minim 2
--functii, minim 2 proceduri).

--Cerinta:
---Sa se defineasca un pachet (denumit UTILITIES) prin care sa se poata realiza urmatoarele
---actiuni:

---a)	Adaugarea unui jaf
---          -	denumire banca
---          -	data -> default ziua inserarii

---b)	Adaugarea unui hot la un anumit jaf
---          -	nume
---          -	prenume
---          -	denumire banca
---          -	data jafului -> default ziua inserarii

---c)	Adaugarea unui martor la un anumit jaf
---          -	nume
---          -	prenume
---          -	denumire banca
---          -	data jafului -> default ziua inserarii

---d)	Arestarea unui hot
---          -	nume hot
---          -	prenume hot
---          -	nume politist
---          -	prenume politist
---          -	data arestarii -> default ziua inserarii

---e)	Adaugarea unei sentinte
---          -	nume hot
---          -	prenume hot
---          -	nume judecator
---          -	prenume judecator
---          -	timp de inchisoare -> in luni
---          -	denumire inchisoare
---          -	data acordarii -> default ziua inserarii

---f)	Verificarea existentei unui anumit client la o anumita banca
---          -	nume
---          -	prenume
---          -	denumire banca

---g)	Verificarea existentei a cel putin unui martor la un anumit jaf
---          -	denumire banca
---          -	data jafului -> default ziua curenta

---h)	Verificarea existentei unui anumit martor la un anumit jaf
---          -	nume
---          -	prenume
---          -	denumire banca
---          -	data jafului -> default ziua curenta

---i)	Afisarea orasului si a tarii unde se afla o anumita banca
---          -	denumire banca

---j)	Afisarea orasului si a tarii unde se afla o anumita inchisoare
---          -	denumire inchisoare

---k)	Afisarea sentintelor (lunilor de inchisoare) savarsite de / pe care le va savarsi un anumit hot
---          -	nume
---          -	prenume

---l)	Afisarea hotilor care nu sunt inca prinsi

---m)	Afisarea sectiei la care lucreaza un anumit politist
---          -	nume
---          -	prenume

---n)	Afisarea politistilor care lucreaza la o anumita sectie
---          -	 denumire sectie

---o)	Afisarea tuturor tribunalelor in care a fost judecat un anumit hot 
---          -	nume
---          -	prenume

---p)	Afisarea tuturor politistilor care au prins, de-a lungul timpului, un anumit hot
---          -	nume
---          -	prenume

---q)	Afisarea tuturor judecatorilor care au judecat, de-a lungul timpului, un anumit hot
---          -	nume
---          -	prenume

---r)	Afisarea numarului de jafuri la care a participat un anumit hot
---          -	nume
---          -	prenume

---s)	Afisarea tuturor bancilor pe care le-a jefuit un anumit hot
---          -	nume
---          -	prenume

---t)	Afisarea tuturor oraselor si tarilor in care exista banci jefuite de un anumit hot
---          -	nume
---          -	prenume

---u)	Afisarea detaliilor martorilor la un anumit jaf
---          -	denumire banca
---          -	data jafului -> default ziua curenta

---v)	Afisarea detaliilor clientilor unei anumite banci
---          -	denumire banca

create or replace package utilities as
    type sentinte is table of number;
    
    type ids is table of number index by pls_integer;

    type nume is table of varchar(62) index by pls_integer;
    
    procedure adaugare_jaf(v_denumire_banca banca.denumire_banca%type,
                           v_data_jaf jaf.data_jaf%type default sysdate);
                           
    procedure adaugare_hot(v_nume_hot hot_de_banci.nume_hot%type,
                           v_prenume_hot hot_de_banci.prenume_hot%type,
                           v_denumire_banca banca.denumire_banca%type,
                           v_data_jaf jaf.data_jaf%type default sysdate);
                           
    procedure adaugare_martor(v_nume_martor martor.nume_martor%type,
                           v_prenume_martor martor.prenume_martor%type,
                           v_denumire_banca banca.denumire_banca%type,
                           v_data_jaf jaf.data_jaf%type default sysdate);

    procedure arestare_hot_politist(v_nume_hot hot_de_banci.nume_hot%type,
                           v_prenume_hot hot_de_banci.prenume_hot%type,
                           v_nume_politist politist.nume_politist%type,
                           v_prenume_politist politist.prenume_politist%type,
                           v_data_arestarii arestare_hot.data_arestarii%type default sysdate);
    
    procedure adaugare_sentinta(v_nume_hot hot_de_banci.nume_hot%type,
                                v_prenume_hot hot_de_banci.prenume_hot%type,
                                v_nume_judecator judecator.nume_judecator%type,
                                v_prenume_judecator judecator.prenume_judecator%type,
                                v_luni_sentinta sentinta.luni_de_inchisoare%type,
                                v_denumire_inchisoare inchisoare.denumire_inchisoare%type,
                                v_data_acordarii judecator_sentinta_hot.data_acordarii%type default sysdate);
                                
    function exista_client(v_nume_client client.nume_client%type,
                           v_prenume_client client.prenume_client%type,
                           v_denumire_banca banca.denumire_banca%type)
    return number;

    function exista_martori_la_jaf(v_denumire_banca banca.denumire_banca%type,
                                   v_data_jaf jaf.data_jaf%type default sysdate)
    return number;
    
    function exista_martor(v_nume_martor martor.nume_martor%type,
                           v_prenume_martor martor.prenume_martor%type,
                           v_denumire_banca banca.denumire_banca%type,
                           v_data_jaf jaf.data_jaf%type default sysdate)
    return number;
    
    function locatie_banca(v_denumire_banca banca.denumire_banca%type)
    return varchar2;
    
    function locatie_inchisoare(v_denumire_inchisoare inchisoare.denumire_inchisoare%type)
    return varchar2;
    
    procedure sentinte_hot(v_nume_hot hot_de_banci.nume_hot%type,
                           v_prenume_hot hot_de_banci.prenume_hot%type);
                           
    procedure hoti_neprinsi;
    
    function sectie_politist(v_nume_politist politist.nume_politist%type,
                             v_prenume_politist politist.prenume_politist%type)
    return varchar2;
    
    procedure politisti_din_sectie(v_denumire_sectie sectie_politie.denumire_sectie%type);
    
    procedure tribunale_hot(v_nume_hot hot_de_banci.nume_hot%type,
                            v_prenume_hot hot_de_banci.prenume_hot%type);
                            
    procedure politisti_hot(v_nume_hot hot_de_banci.nume_hot%type,
                            v_prenume_hot hot_de_banci.prenume_hot%type);
                            
    procedure judecatori_hot(v_nume_hot hot_de_banci.nume_hot%type,
                             v_prenume_hot hot_de_banci.prenume_hot%type);
                             
    function numar_jafuri_hot(v_nume_hot hot_de_banci.nume_hot%type,
                              v_prenume_hot hot_de_banci.prenume_hot%type)
    return number;
    
    procedure banci_jefuite_hot(v_nume_hot hot_de_banci.nume_hot%type,
                                v_prenume_hot hot_de_banci.prenume_hot%type);
    
    procedure orase_tari_jefuite_hot(v_nume_hot hot_de_banci.nume_hot%type,
                                     v_prenume_hot hot_de_banci.prenume_hot%type);
                                     
    procedure martori(v_denumire_banca banca.denumire_banca%type,
                      v_data_jaf jaf.data_jaf%type default sysdate);
                      
    procedure clienti(v_denumire_banca banca.denumire_banca%type);
end utilities;
/

create or replace package body utilities as
---a)	Adaugarea unui jaf
    procedure adaugare_jaf(v_denumire_banca banca.denumire_banca%type,
                           v_data_jaf jaf.data_jaf%type default sysdate) is
        v_id_banca banca.id_banca%type;
        v_id_jaf jaf.id_jaf%type;
        v_nr_banci number;
    begin
        select count(*)
        into v_nr_banci
        from banca
        where denumire_banca = v_denumire_banca;
        
        if v_nr_banci <> 0 then
            select id_banca
            into v_id_banca
            from banca
            where denumire_banca = v_denumire_banca;
        else
            select nvl(max(id_banca),0) + 1
            into v_id_banca
            from banca;
            
            insert into banca (id_banca, denumire_banca)
            values (v_id_banca, v_denumire_banca);
        end if;
        
        select nvl(max(id_jaf),0) + 1
        into v_id_jaf
        from jaf;
        
        insert into jaf
        values (v_id_jaf, v_id_banca, v_data_jaf);
        
        dbms_output.put_line('Jaful a fost inregistrat.');
    exception
        when TOO_MANY_ROWS then
            dbms_output.put_line('Operatie esuata! Exista doua banci cu aceeasi denumire.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end adaugare_jaf;

---b)	Adaugarea unui hot la un anumit jaf
    procedure adaugare_hot(v_nume_hot hot_de_banci.nume_hot%type,
                           v_prenume_hot hot_de_banci.prenume_hot%type,
                           v_denumire_banca banca.denumire_banca%type,
                           v_data_jaf jaf.data_jaf%type default sysdate) is
        v_id_banca banca.id_banca%type;
        v_id_jaf jaf.id_jaf%type;
        v_id_hot hot_de_banci.id_hot%type;
        v_exista_hot number;
    begin
        select count(*)
        into v_exista_hot
        from hot_de_banci
        where nume_hot = v_nume_hot
        and prenume_hot = v_prenume_hot;
        
        select id_banca
        into v_id_banca
        from banca
        where denumire_banca = v_denumire_banca;
        
        select id_jaf
        into v_id_jaf
        from jaf
        where id_banca = v_id_banca
        and data_jaf = v_data_jaf;

        if v_exista_hot = 0 then
            select nvl(max(id_hot),0) + 1
            into v_id_hot
            from hot_de_banci;
            
            insert into hot_de_banci (id_hot, nume_hot, prenume_hot)
            values (v_id_hot, v_nume_hot, v_prenume_hot);
        end if;
        
        insert into hot_jaf (id_jaf, id_hot)
        values (v_id_jaf, v_id_hot);
        
        dbms_output.put_line('Hotul a fost inregistrat.');
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Operatie esuata! Verificati corectitudinea denumirii bancii si a datii jafului.');
        when TOO_MANY_ROWS then
            dbms_output.put_line('Operatie esuata! Exista doua banci cu aceeasi denumire.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end adaugare_hot;

---c)	Adaugarea unui martor la un anumit jaf
    procedure adaugare_martor(v_nume_martor martor.nume_martor%type,
                              v_prenume_martor martor.prenume_martor%type,
                              v_denumire_banca banca.denumire_banca%type,
                              v_data_jaf jaf.data_jaf%type default sysdate) is
        v_id_banca banca.id_banca%type;
        v_id_jaf jaf.id_jaf%type;
        v_id_martor martor.id_martor%type;
        v_exista_martor number;
    begin
        select count(*)
        into v_exista_martor
        from martor
        where nume_martor = v_nume_martor
        and prenume_martor = v_prenume_martor;
        
        select id_banca
        into v_id_banca
        from banca
        where denumire_banca = v_denumire_banca;
        
        select id_jaf
        into v_id_jaf
        from jaf
        where id_banca = v_id_banca
        and data_jaf = v_data_jaf;
        
        if v_exista_martor = 0 then
            select nvl(max(id_martor),0) + 1
            into v_id_martor
            from martor;
            
            insert into martor (id_martor, nume_martor, prenume_martor)
            values (v_id_martor, v_nume_martor, v_prenume_martor);
        end if;
        
        insert into martor_jaf (id_jaf, id_martor)
        values (v_id_jaf, v_id_martor);
        
        dbms_output.put_line('Martorul a fost inregistrat.');
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Operatie esuata! Verificati corectitudinea denumirii bancii si a datii jafului.');
        when TOO_MANY_ROWS then
            dbms_output.put_line('Operatie esuata! Exista doua banci cu aceeasi denumire.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end adaugare_martor;

---d)	Arestarea unui hot
    procedure arestare_hot_politist(v_nume_hot hot_de_banci.nume_hot%type,
                                    v_prenume_hot hot_de_banci.prenume_hot%type,
                                    v_nume_politist politist.nume_politist%type,
                                    v_prenume_politist politist.prenume_politist%type,
                                    v_data_arestarii arestare_hot.data_arestarii%type default sysdate) is
        v_id_politist politist.id_politist%type;
        v_id_hot hot_de_banci.id_hot%type;
    begin
        select id_politist
        into v_id_politist
        from politist
        where nume_politist = v_nume_politist
        and prenume_politist = v_prenume_politist;
        
        select id_hot
        into v_id_hot
        from hot_de_banci
        where nume_hot = v_nume_hot
        and prenume_hot = v_prenume_hot;
        
        insert into arestare_hot
        values (v_id_hot, v_id_politist, v_data_arestarii);
        
        dbms_output.put_line('Arestarea a fost inregistrata.');
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Operatie esuata! Verificati corectitudinea numelor hotului si politistului.');
        when TOO_MANY_ROWS then
            dbms_output.put_line('Operatie esuata! Exista mai multe persoane cu acelasi nume.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end arestare_hot_politist;

---e)	Adaugarea unei sentinte
    procedure adaugare_sentinta(v_nume_hot hot_de_banci.nume_hot%type,
                                v_prenume_hot hot_de_banci.prenume_hot%type,
                                v_nume_judecator judecator.nume_judecator%type,
                                v_prenume_judecator judecator.prenume_judecator%type,
                                v_luni_sentinta sentinta.luni_de_inchisoare%type,
                                v_denumire_inchisoare inchisoare.denumire_inchisoare%type,
                                v_data_acordarii judecator_sentinta_hot.data_acordarii%type default sysdate) is
        v_id_judecator judecator.id_judecator%type;
        v_id_hot hot_de_banci.id_hot%type;
        v_id_sentinta sentinta.id_sentinta%type;
        v_id_inchisoare inchisoare.id_inchisoare%type;
        v_exista_sentinta number;
    begin
        select id_inchisoare
        into v_id_inchisoare
        from inchisoare
        where denumire_inchisoare = v_denumire_inchisoare;
        
        select count(*)
        into v_exista_sentinta
        from sentinta
        where luni_de_inchisoare = v_luni_sentinta
        and id_inchisoare = v_id_inchisoare
        group by id_inchisoare, luni_de_inchisoare;

        select id_judecator
        into v_id_judecator
        from judecator
        where nume_judecator = v_nume_judecator
        and prenume_judecator = v_prenume_judecator;
        
        select id_hot
        into v_id_hot
        from hot_de_banci
        where nume_hot = v_nume_hot
        and prenume_hot = v_prenume_hot;
        
        if v_exista_sentinta = 0 then
            select nvl(max(id_sentinta), 0) + 1
            into v_id_sentinta
            from sentinta;

            insert into sentinta
            values (v_id_sentinta, v_luni_sentinta, v_id_inchisoare);
        else
            select id_sentinta
            into v_id_sentinta
            from sentinta
            where luni_de_inchisoare = v_luni_sentinta
            and id_inchisoare = v_id_inchisoare;
        end if;

        insert into judecator_sentinta_hot
        values (v_id_judecator, v_id_sentinta, v_id_hot, v_data_acordarii);
        
        dbms_output.put_line('Sentinta a fost inregistrata.');
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Operatie esuata! Verificati corectitudinea denumirii inchisorii si numelor hotului si judecatorului.');
        when TOO_MANY_ROWS then
            dbms_output.put_line('Operatie esuata! Exista mai multe inchisori/persoane cu acelasi nume.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end adaugare_sentinta;

---f)	Verificarea existentei unui anumit client la o anumita banca
    function exista_client(v_nume_client client.nume_client%type,
                           v_prenume_client client.prenume_client%type,
                           v_denumire_banca banca.denumire_banca%type)
    return number is
        v_exista_client number;
    begin
        select count(*)
        into v_exista_client
        from client
        join banca using (id_banca)
        where nume_client = v_nume_client
        and prenume_client = v_prenume_client
        and denumire_banca = v_denumire_banca;
        
        if v_exista_client = 0 then
            return 0;
        else
            return 1;
        end if;
    exception
        when others then
            return -1;
    end exista_client;

---g)	Verificarea existentei a cel putin unui martor la un anumit jaf
    function exista_martori_la_jaf(v_denumire_banca banca.denumire_banca%type,
                                   v_data_jaf jaf.data_jaf%type default sysdate)
    return number is
        v_exista_martori number;
    begin
        select count(*)
        into v_exista_martori
        from martor
        join martor_jaf using (id_martor)
        join jaf using (id_jaf)
        join banca using (id_banca)
        where denumire_banca = v_denumire_banca
        and data_jaf = v_data_jaf;

        if v_exista_martori = 0 then
            return 0;
        else
            return 1;
        end if;
    exception
        when others then
            return -1;
    end exista_martori_la_jaf;

---h)	Verificarea existentei unui anumit martor la un anumit jaf
    function exista_martor(v_nume_martor martor.nume_martor%type,
                           v_prenume_martor martor.prenume_martor%type,
                           v_denumire_banca banca.denumire_banca%type,
                           v_data_jaf jaf.data_jaf%type default sysdate)
    return number is
        v_exista_martor number;
    begin
        select count(*)
        into v_exista_martor
        from martor
        join martor_jaf using (id_martor)
        join jaf using (id_jaf)
        join banca using (id_banca)
        where nume_martor = v_nume_martor
        and prenume_martor = v_prenume_martor
        and denumire_banca = v_denumire_banca
        and data_jaf = v_data_jaf;
        
        if v_exista_martor = 0 then
            return 0;
        else
            return 1;
        end if;
    exception
        when others then
            return -1;
    end exista_martor;

---i)	Afisarea orasului si a tarii unde se afla o anumita banca
    function locatie_banca(v_denumire_banca banca.denumire_banca%type)
    return varchar2 is
        v_id_banca banca.id_banca%type;
        v_oras oras.denumire_oras%type;
        v_tara tara.denumire_tara%type;
    begin
        select denumire_oras, denumire_tara
        into v_oras, v_tara
        from banca b, oras o, tara t
        where b.id_oras = o.id_oras
        and b.id_tara = t.id_tara
        and denumire_banca = v_denumire_banca;

        return v_oras || ', ' || v_tara;
    exception
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end locatie_banca;

---j)	Afisarea orasului si a tarii unde se afla o anumita inchisoare
    function locatie_inchisoare(v_denumire_inchisoare inchisoare.denumire_inchisoare%type)
    return varchar2 is
        v_id_inchisoare inchisoare.id_inchisoare%type;
        v_oras oras.denumire_oras%type;
        v_tara tara.denumire_tara%type;
    begin
        select denumire_oras, denumire_tara
        into v_oras, v_tara
        from inchisoare i, oras o, tara t
        where i.id_oras = o.id_oras
        and i.id_tara = t.id_tara
        and denumire_inchisoare = v_denumire_inchisoare;

        return v_oras || ', ' || v_tara;
    exception
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end locatie_inchisoare;

---k)	Afisarea sentintelor (lunilor de inchisoare) savarsite de / pe care le va savarsi un anumit hot
    procedure sentinte_hot(v_nume_hot hot_de_banci.nume_hot%type,
                           v_prenume_hot hot_de_banci.prenume_hot%type) is
        v_sentinte_hot sentinte := sentinte();
        v_numar_sentinte number;
    begin
        select count(*)
        into v_numar_sentinte
        from sentinta
        join judecator_sentinta_hot using (id_sentinta)
        join hot_de_banci using (id_hot)
        where nume_hot = v_nume_hot
        and prenume_hot = v_prenume_hot
        group by nume_hot, prenume_hot;
        
        if v_numar_sentinte = 0 then
            dbms_output.put_line('Hotul ' || v_prenume_hot || ' ' || v_nume_hot || ' nu are inca nicio sentinta.');
        else
            select luni_de_inchisoare
            bulk collect into v_sentinte_hot
            from sentinta
            join judecator_sentinta_hot using (id_sentinta)
            join hot_de_banci using (id_hot)
            where nume_hot = v_nume_hot
            and prenume_hot = v_prenume_hot
            order by data_acordarii;
            
            for i in v_sentinte_hot.first..v_sentinte_hot.last loop
                dbms_output.put_line('Sentinta ' || i || ': ' || v_sentinte_hot(i) || ' luni');
            end loop;
        end if;
    exception
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end sentinte_hot;

---l)	Afisarea hotilor care nu sunt inca prinsi
    procedure hoti_neprinsi is
        v_id_hoti ids := ids();
        v_nume_hoti_neprinsi nume := nume();
        v_nume_hot hot_de_banci.nume_hot%type;
        v_prenume_hot hot_de_banci.prenume_hot%type;
        v_nr_arestari number;
        v_nr_sentinte number;
        counter number := 1;
    begin
        select id_hot
        bulk collect into v_id_hoti
        from hot_de_banci;
        
        for i in v_id_hoti.first..v_id_hoti.last loop
            select count(*), nume_hot, prenume_hot
            into v_nr_sentinte, v_nume_hot, v_prenume_hot
            from sentinta
            join judecator_sentinta_hot using (id_sentinta)
            right join hot_de_banci using (id_hot)
            where id_hot = v_id_hoti(i)
            group by nume_hot, prenume_hot;
            
            select count(*)
            into v_nr_arestari
            from arestare_hot
            right join hot_de_banci using (id_hot)
            where id_hot = v_id_hoti(i)
            group by id_hot;
            
            if v_nr_arestari < v_nr_sentinte then
                v_nume_hoti_neprinsi(counter) := v_nume_hot || ' ' || v_prenume_hot;
                counter := counter + 1;
            end if;
        end loop;
        
        if v_nume_hoti_neprinsi.count <> 0 then
            for i in v_nume_hoti_neprinsi.first..v_nume_hoti_neprinsi.last loop
                dbms_output.put_line('Hot neprins ' || i || ': ' || v_nume_hoti_neprinsi(i));
            end loop;
        else
            dbms_output.put_line('Nu exista niciun hot neprins.');
        end if;
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Nu exista niciun hot inregistrat in baza de date.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end hoti_neprinsi;

---m)	Afisarea sectiei la care lucreaza un anumit politist
    function sectie_politist(v_nume_politist politist.nume_politist%type,
                             v_prenume_politist politist.prenume_politist%type)
    return varchar2 is
        v_id_sectie sectie_politie.id_sectie%type;
        v_denumire_sectie sectie_politie.denumire_sectie%type;
    begin
        select id_sectie
        into v_id_sectie
        from politist
        where nume_politist = v_nume_politist
        and prenume_politist = v_prenume_politist;
        
        select denumire_sectie
        into v_denumire_sectie
        from sectie_politie
        where id_sectie = v_id_sectie;
        
        return v_denumire_sectie;
    exception
        when NO_DATA_FOUND then
            return 'Sectia politistului' || v_nume_politist || ' ' || v_prenume_politist || 'nu este inregistrata in baza de date.';
        when TOO_MANY_ROWS then
            return 'Exista mai multi politisti cu acelasi nume.';
        when others then
            return 'Operatie esuata! Eroarea este: ' || sqlerrm || '.';
    end sectie_politist;

---n)	Afisarea politistilor care lucreaza la o anumita sectie
    procedure politisti_din_sectie(v_denumire_sectie sectie_politie.denumire_sectie%type) is
        v_id_sectie sectie_politie.id_sectie%type;
        v_nume_politisti nume := nume();
    begin
        select id_sectie
        into v_id_sectie
        from sectie_politie
        where denumire_sectie = v_denumire_sectie;
        
        select nume_politist || ' ' || prenume_politist
        bulk collect into v_nume_politisti
        from politist
        where id_sectie = v_id_sectie;
        
        if v_nume_politisti.count <> 0 then
            for i in v_nume_politisti.first..v_nume_politisti.last loop
                dbms_output.put_line('Politist ' || i || ': ' || v_nume_politisti(i));
            end loop;
        else
            dbms_output.put_line('Nu exista politisti care lucreaza in aceasta sectie.');
        end if;
        
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Nu exista nicio sectie de politie cu acest nume.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end politisti_din_sectie;

---o)	Afisarea tuturor tribunalelor in care a fost judecat un anumit hot 
    procedure tribunale_hot(v_nume_hot hot_de_banci.nume_hot%type,
                            v_prenume_hot hot_de_banci.prenume_hot%type) is
        v_id_hot hot_de_banci.id_hot%type;
        v_nume_tribunale nume := nume();
        v_nr_tribunale number;
    begin
        select id_hot
        into v_id_hot
        from hot_de_banci
        where nume_hot = v_nume_hot
        and prenume_hot = v_prenume_hot;
        
        select count(*)
        into v_nr_tribunale
        from judecator_sentinta_hot
        join judecator using (id_judecator)
        where id_hot = v_id_hot;
        
        if v_nr_tribunale <> 0 then
            select denumire_tribunal
            bulk collect into v_nume_tribunale
            from judecator_sentinta_hot
            join judecator using (id_judecator)
            where id_hot = v_id_hot;

            for i in v_nume_tribunale.first..v_nume_tribunale.last loop
                dbms_output.put_line('Tribunal ' || i || ': ' || v_nume_tribunale(i));
            end loop;
        else
            dbms_output.put_line('Hotul ' || v_nume_hot || ' ' || v_prenume_hot || ' nu a fost judecat pana in acest moment.');
        end if;
        
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Nu exista niciun hot cu numele dat.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end tribunale_hot;

---p)	Afisarea tuturor politistilor care au prins, de-a lungul timpului, un anumit hot
    procedure politisti_hot(v_nume_hot hot_de_banci.nume_hot%type,
                            v_prenume_hot hot_de_banci.prenume_hot%type) is
        v_id_hot hot_de_banci.id_hot%type;
        v_id_politisti ids := ids();
        v_nume_politisti nume := nume();
        v_nr_politisti number;
    begin
        select id_hot
        into v_id_hot
        from hot_de_banci
        where nume_hot = v_nume_hot
        and prenume_hot = v_prenume_hot;
        
        select count(*)
        into v_nr_politisti
        from arestare_hot
        where id_hot = v_id_hot
        group by id_hot;
        
        if v_nr_politisti <> 0 then
            select nume_politist || ' ' || prenume_politist
            bulk collect into v_nume_politisti
            from arestare_hot
            join politist using (id_politist)
            where id_hot = v_id_hot;

            for i in v_nume_politisti.first..v_nume_politisti.last loop
                dbms_output.put_line('Politist ' || i || ': ' || v_nume_politisti(i));
            end loop;
        else
            dbms_output.put_line('Hotul ' || v_nume_hot || ' ' || v_prenume_hot || ' nu a fost prins pana in acest moment.');
        end if;
        
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Nu exista niciun hot cu numele dat.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end politisti_hot;

---q)	Afisarea tuturor judecatorilor care au judecat, de-a lungul timpului, un anumit hot
    procedure judecatori_hot(v_nume_hot hot_de_banci.nume_hot%type,
                             v_prenume_hot hot_de_banci.prenume_hot%type) is
        v_id_hot hot_de_banci.id_hot%type;
        v_id_judecatori ids := ids();
        v_nume_judecatori nume := nume();
        v_nr_judecatori number;
    begin
        select id_hot
        into v_id_hot
        from hot_de_banci
        where nume_hot = v_nume_hot
        and prenume_hot = v_prenume_hot;
        
        select count(*)
        into v_nr_judecatori
        from judecator_sentinta_hot
        where id_hot = v_id_hot
        group by id_hot;
        
        if v_nr_judecatori <> 0 then
            select nume_judecator || ' ' || prenume_judecator
            bulk collect into v_nume_judecatori
            from judecator_sentinta_hot
            join judecator using (id_judecator)
            where id_hot = v_id_hot;

            for i in v_nume_judecatori.first..v_nume_judecatori.last loop
                dbms_output.put_line('Judecator ' || i || ': ' || v_nume_judecatori(i));
            end loop;
        else
            dbms_output.put_line('Hotul ' || v_nume_hot || ' ' || v_prenume_hot || ' nu a fost judecat pana in acest moment.');
        end if;
        
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Nu exista niciun hot cu numele dat.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end judecatori_hot;

---r)	Afisarea numarului de jafuri la care a participat un anumit hot
    function numar_jafuri_hot(v_nume_hot hot_de_banci.nume_hot%type,
                              v_prenume_hot hot_de_banci.prenume_hot%type)
    return number is
        v_nr_jafuri number;
    begin
        select count(*)
        into v_nr_jafuri
        from hot_jaf
        join hot_de_banci using (id_hot)
        where nume_hot = v_nume_hot
        and prenume_hot = v_prenume_hot
        group by id_hot;
        
        return v_nr_jafuri;
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Nu exista niciun hot cu numele dat.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end numar_jafuri_hot;

---s)	Afisarea tuturor bancilor pe care le-a jefuit un anumit hot
    procedure banci_jefuite_hot(v_nume_hot hot_de_banci.nume_hot%type,
                                v_prenume_hot hot_de_banci.prenume_hot%type) is
        v_id_hot hot_de_banci.id_hot%type;
        v_id_banci ids := ids();
        v_nume_banci nume := nume();
        v_nr_banci number;
    begin
        select id_hot
        into v_id_hot
        from hot_de_banci
        where nume_hot = v_nume_hot
        and prenume_hot = v_prenume_hot;
        
        select count(distinct id_banca)
        into v_nr_banci
        from hot_jaf
        join hot_de_banci using (id_hot)
        join jaf using (id_jaf)
        where id_hot = v_id_hot
        group by id_hot;
        
        if v_nr_banci <> 0 then
            select distinct denumire_banca
            bulk collect into v_nume_banci
            from hot_jaf
            join hot_de_banci using (id_hot)
            join jaf using (id_jaf)
            join banca using (id_banca)
            where id_hot = v_id_hot;

            for i in v_nume_banci.first..v_nume_banci.last loop
                dbms_output.put_line('Banca ' || i || ': ' || v_nume_banci(i));
            end loop;
        else
            dbms_output.put_line('Hotul ' || v_nume_hot || ' ' || v_prenume_hot || ' nu a jefuit nicio banca pana in acest moment.');
        end if;
        
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Nu exista niciun hot cu numele dat.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end banci_jefuite_hot;

---t)	Afisarea tuturor oraselor si tarilor in care exista banci jefuite de un anumit hot
    procedure orase_tari_jefuite_hot(v_nume_hot hot_de_banci.nume_hot%type,
                                     v_prenume_hot hot_de_banci.prenume_hot%type) is
        v_id_hot hot_de_banci.id_hot%type;
        v_id_banci ids := ids();
        v_nume_orase_tari nume := nume();
        v_nr_banci number;
    begin
        select id_hot
        into v_id_hot
        from hot_de_banci
        where nume_hot = v_nume_hot
        and prenume_hot = v_prenume_hot;
        
        select count(distinct id_banca)
        into v_nr_banci
        from hot_jaf
        join hot_de_banci using (id_hot)
        join jaf using (id_jaf)
        where id_hot = v_id_hot
        group by id_hot;
        
        if v_nr_banci <> 0 then
            select distinct denumire_oras || ', ' || denumire_tara
            bulk collect into v_nume_orase_tari
            from hot_jaf hj, hot_de_banci h, jaf j, banca b, oras o, tara t
            where hj.id_hot = h.id_hot
            and j.id_jaf = hj.id_jaf
            and j.id_banca = b.id_banca
            and b.id_oras = o.id_oras
            and o.id_tara = t.id_tara
            and h.id_hot = v_id_hot;

            for i in v_nume_orase_tari.first..v_nume_orase_tari.last loop
                dbms_output.put_line('Locatie banca ' || i || ': ' || v_nume_orase_tari(i));
            end loop;
        else
            dbms_output.put_line('Hotul ' || v_nume_hot || ' ' || v_prenume_hot || ' nu a jefuit nicio banca pana in acest moment.');
        end if;
        
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Nu exista niciun hot cu numele dat.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end orase_tari_jefuite_hot;

---u)	Afisarea detaliilor martorilor la un anumit jaf
    procedure martori(v_denumire_banca banca.denumire_banca%type,
                      v_data_jaf jaf.data_jaf%type default sysdate) is
        v_id_jaf jaf.id_jaf%type;
        v_nr_martori number;
        v_nume_martori nume := nume();
        v_varsta_martori ids := ids();
    begin
        select id_jaf
        into v_id_jaf
        from jaf
        join banca using (id_banca)
        where denumire_banca = v_denumire_banca
        and data_jaf = v_data_jaf;
        
        select count(*)
        into v_nr_martori
        from martor_jaf
        where id_jaf = v_id_jaf
        group by id_jaf;
        
        if v_nr_martori <> 0 then
            select nume_martor || ' ' || prenume_martor, varsta_martor
            bulk collect into v_nume_martori, v_varsta_martori
            from martor_jaf 
            join martor using (id_martor)
            where id_jaf = v_id_jaf;
        
            for i in v_nume_martori.first..v_nume_martori.last loop
                dbms_output.put_line('Martor ' || i || ': ' || v_nume_martori(i) || ', ' || v_varsta_martori(i) || ' ani');
            end loop;
        else
            dbms_output.put_line('Jaful bancii' || v_denumire_banca || ' din data de ' || v_data_jaf || ' nu are niciun martor.');
        end if;
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Nu exista niciun jaf la aceasta banca, in data respectiva.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end martori;

---v)	Afisarea detaliilor clientilor unei anumite banci
    procedure clienti(v_denumire_banca banca.denumire_banca%type) is
        v_nr_clienti number;
        v_nume_clienti nume := nume();
        v_varsta_clienti ids := ids();
    begin
        select count(*)
        into v_nr_clienti
        from client
        join banca using (id_banca)
        where denumire_banca = v_denumire_banca
        group by id_banca;
        
        if v_nr_clienti <> 0 then
            select nume_client || ' ' || prenume_client, varsta_client
            bulk collect into v_nume_clienti, v_varsta_clienti
            from client
            join banca using (id_banca)
            where denumire_banca = v_denumire_banca;
        
            for i in v_nume_clienti.first..v_nume_clienti.last loop
                dbms_output.put_line('Client ' || i || ': ' || v_nume_clienti(i) || ', ' || v_varsta_clienti(i) || ' ani');
            end loop;
        else
            dbms_output.put_line('Banca' || v_denumire_banca || ' nu are niciun client.');
        end if;
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line('Nu exista nicio banca cu aceasta denumire.');
        when others then
            dbms_output.put_line('Operatie esuata! Eroarea este: ' || sqlerrm || '.');
    end clienti;

end utilities;
/

--apelare:
---a)
-----OK! (exista banca)
begin
    utilities.adaugare_jaf('BCR');
end;
/

select denumire_banca
from jaf
join banca using (id_banca)
where denumire_banca = 'BCR';

-----OK! (nu exista banca)
begin
    utilities.adaugare_jaf('BRD');
end;
/

select denumire_banca
from jaf
join banca using (id_banca)
where denumire_banca = 'BRD';

-----EROARE!
begin
    insert into banca values (505, 'BCR', 2, 'RO');
    utilities.adaugare_jaf('BCR');
end;
/

rollback;

---b)
begin
    utilities.adaugare_hot('Nume', 'Prenume', 'Caixabank', '07-APR-02');
end;
/

select nume_hot, prenume_hot, denumire_banca
from hot_jaf
join jaf using (id_jaf)
join banca using (id_banca)
join hot_de_banci using (id_hot)
where nume_hot = 'Nume'
and denumire_banca = 'Caixabank';

rollback;

---c)
begin
    utilities.adaugare_martor('Nume', 'Prenume', 'Caixabank', '07-APR-02');
end;
/

select nume_martor, prenume_martor, denumire_banca
from martor_jaf
join jaf using (id_jaf)
join banca using (id_banca)
join martor using (id_martor)
where nume_martor = 'Nume'
and denumire_banca = 'Caixabank';

rollback;

---d)
begin
    utilities.arestare_hot_politist('Derichs', 'Roelof', 'Voiculescu', 'Alina');
end;
/

select nume_hot, prenume_hot, nume_politist, prenume_politist
from arestare_hot
join hot_de_banci using (id_hot)
join politist using (id_politist)
where nume_hot = 'Derichs'
and nume_politist = 'Voiculescu';

rollback;

---e)
begin
    utilities.adaugare_sentinta('Spitznagel', 'Tania', 'Villanova', 'Renata', 500, 'Inchisoarea St. Gilles');
end;
/

select nume_hot, prenume_hot, nume_judecator, prenume_judecator, luni_de_inchisoare
from judecator_sentinta_hot
join judecator using (id_judecator)
join hot_de_banci using (id_hot)
join sentinta using (id_sentinta)
where nume_hot = 'Spitznagel'
and nume_judecator = 'Villanova';

rollback;

---f)
select utilities.exista_client('Gabrielli', 'Jaimie', 'BCR') as "Exista clientul dat?"
from dual;

select nume_client, prenume_client, denumire_banca
from client
join banca using (id_banca)
where nume_client = 'Gabrielli';

---g)
select utilities.exista_martori_la_jaf('Caixabank', '07-APR-02') as "Exista martori?"
from dual;

select count(*) as "Numar martori"
from martor
join martor_jaf using (id_martor)
join jaf using (id_jaf)
join banca using (id_banca)
where denumire_banca = 'Caixabank'
and data_jaf = '07-APR-02';

---h)
select utilities.exista_martor('Norman', 'Valerie', 'Caixabank', '07-APR-02') as "Exista martorul dat?"
from dual;

select nume_martor, prenume_martor, denumire_banca, data_jaf
from martor
join martor_jaf using (id_martor)
join jaf using (id_jaf)
join banca using (id_banca)
where nume_martor = 'Norman'
and denumire_banca = 'Caixabank'
and data_jaf = '07-APR-02';

---i)
select utilities.locatie_banca('Caixabank') as "Locatie banca"
from dual;

select denumire_oras, denumire_tara
from banca b, oras o, tara t
where b.id_oras = o.id_oras
and b.id_tara = t.id_tara
and denumire_banca = 'Caixabank';

---j)
select utilities.locatie_inchisoare('Penitenciarul Bucuresti-Jilava') as "Locatie inchisoare"
from dual;

select denumire_oras, denumire_tara
from inchisoare i, oras o, tara t
where i.id_oras = o.id_oras
and i.id_tara = t.id_tara
and denumire_inchisoare = 'Penitenciarul Bucuresti-Jilava';

---k)
begin
    utilities.sentinte_hot('Armando', 'Anika');
end;
/

select luni_de_inchisoare, nume_hot, prenume_hot
from sentinta
join judecator_sentinta_hot using (id_sentinta)
join hot_de_banci using (id_hot)
where nume_hot = 'Armando'
and prenume_hot = 'Anika'
order by data_acordarii;

---l)
begin
    utilities.hoti_neprinsi;
end;
/

---m)
select utilities.sectie_politist('Voiculescu', 'Alina')
from dual;

---n)
begin
    utilities.politisti_din_sectie('Sectia 2 Politie');
end;
/

---o)
begin
    utilities.tribunale_hot('Jerome', 'Veronika');
end;
/

---p)
begin
    utilities.politisti_hot('Armando', 'Anika');
end;
/

---q)
begin
    utilities.judecatori_hot('Armando', 'Anika');
end;
/

---r)
select utilities.numar_jafuri_hot('Armando', 'Anika') "Numar jafuri"
from dual;

---s)
begin
    utilities.banci_jefuite_hot('Armando', 'Anika');
end;
/

select count(distinct id_banca) "Numar banci jefuite"
from hot_jaf
join hot_de_banci using (id_hot)
join jaf using (id_jaf)
where nume_hot = 'Armando'
group by id_hot;

---t)
begin
    utilities.orase_tari_jefuite_hot('Armando', 'Anika');
end;
/

---u)
begin
    utilities.martori('Commerzbank', '15-JUL-20');
end;
/

---v)
begin
    utilities.clienti('Commerzbank');
end;
/