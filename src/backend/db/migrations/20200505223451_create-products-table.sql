-- migrate:up
create table "supplier"
    ( "sid" serial primary key
    , "name" text not null
    , "url" text not null
    , "description" text null
    );

create table "product"
    ( "pid" serial primary key
    , "slug" varchar(32) not null
    , "cid" integer references "category" ("cid")
    , "sid" integer null references "supplier" ("sid")
    , "name" text not null
    , "description" text null
    , constraint product_slug_unique unique ("slug")
    );

insert into supplier ("name", "url", "description") values
    ( 'Toso', 'https://www.toso.com/', 'From Japan' ),
    ( 'Mottura', 'https://www.mottura.com/en/', 'From Italy' ),
    ( 'Vako', 'https://www.vako.com/', 'From Netherlands' ),
    ( 'Creation Baumann', 'https://www.creationbaumann.com/', 'From Switzerland <3' )
    ;

insert into product ("slug", "cid", "sid", "name", "description") values
    ( 'nexty', 1, 1, 'Nexty', 'Aceasta este descrierea sistemului Nexty.' ),
    ( 'legato', 1, 1, 'Legato', 'Aceasta este descrierea sistemului Legato.' ),
    ( 'squares', 1, 3, 'Square S', null ),
    ( 'squarem', 1, 3, 'Square M', null ),
    ( 'rounds', 1, 3, 'Round S', null ),
    ( 'roundm', 1, 3, 'Round M', null ),
    ( 'esse', 1, 2, 'Esse', 'Aceasta este descrierea sistemului Esse. Acest sistem merge cu WAVE'),
    ( 'separe', 1, 2, 'Separe', 'Aceasta este descrierea sistemului Separe. Acesta merge cu WAVE'),
    ( 'modulo205', 1, 2, 'Modulo 205', null ),
    ( 'modulo105', 1, 2, 'Modulo 105', null ),
    ( '1pliu', 3, null , '1-pliu', 'Descrierea manoperei 1pliu' ),
    ( '2pliuri', 3, null , '2-pliuri', null ),
    ( '3pliuri', 3, null , '3-pliuri', null ),
    ( 'pliu-ascuns', 3, null , 'Pliu ascuns', null ),
    ( 'fara-pliuri', 3, null , 'Banda fara pliuri', null ),
    ( 'wave', 3, null , 'Rejansa WAVE', null ),
    ( 'inele', 3, null , 'Banda cu inele', null ),
    ( 'material1', 2, null , 'Material 1', 'Un material deosebit de fin.' ),
    ( 'material2', 2, null , 'Material 2', 'Material lejer.' )
    ;

-- migrate:down
drop table "product";

drop table "supplier";
