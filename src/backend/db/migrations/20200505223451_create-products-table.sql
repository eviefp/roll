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
    , "price" integer not null
    , "description" text null
    , constraint product_slug_unique unique ("slug")
    );

insert into supplier ("name", "url", "description") values
    ( 'Toso', 'https://www.toso.com/', 'From Japan' ),
    ( 'Mottura', 'https://www.mottura.com/en/', 'From Italy' ),
    ( 'Vako', 'https://www.vako.com/', 'From Netherlands' ),
    ( 'Creation Baumann', 'https://www.creationbaumann.com/', 'From Switzerland <3' )
    ;

insert into product ("slug", "cid", "sid", "name", "price", "description") values
    ( 'nexty', 1, 1, 'Nexty', 100, 'Aceasta este descrierea sistemului Nexty.' ),
    ( 'legato', 1, 1, 'Legato', 100, 'Aceasta este descrierea sistemului Legato.' ),
    ( 'squares', 1, 3, 'Square S', 100, null ),
    ( 'squarem', 1, 3, 'Square M', 100, null ),
    ( 'rounds', 1, 3, 'Round S', 100, null ),
    ( 'roundm', 1, 3, 'Round M', 100, null ),
    ( 'esse', 1, 2, 'Esse', 100,'Aceasta este descrierea sistemului Esse. Acest sistem merge cu WAVE'),
    ( 'separe', 1, 2, 'Separe', 100, 'Aceasta este descrierea sistemului Separe. Acesta merge cu WAVE'),
    ( 'modulo205', 1, 2, 'Modulo 205', 100, null ),
    ( 'modulo105', 1, 2, 'Modulo 105', 100, null ),
    ( '1pliu', 3, null , '1-pliu', 100, 'Descrierea manoperei 1pliu' ),
    ( '2pliuri', 3, null , '2-pliuri', 100, null ),
    ( '3pliuri', 3, null , '3-pliuri', 100, null ),
    ( 'pliu-ascuns', 3, null , 'Pliu ascuns', 100, null ),
    ( 'fara-pliuri', 3, null , 'Banda fara pliuri', 100, null ),
    ( 'creion', 3, null , 'Rejansa creion', 100, null ),
    ( 'wave', 3, null , 'Rejansa WAVE', 100, null ),
    ( 'inele', 3, null , 'Banda cu inele', 100, null ),
    ( 'material1', 2, null , 'Material 1', 100, 'Un material deosebit de fin.' ),
    ( 'material2', 2, null , 'Material 2', 100, 'Material lejer.' )
    ;

-- migrate:down
drop table "product";

drop table "supplier";
