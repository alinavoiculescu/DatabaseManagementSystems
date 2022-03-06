--Creare tabele

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