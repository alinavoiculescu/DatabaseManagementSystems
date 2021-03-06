--Inserare date

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