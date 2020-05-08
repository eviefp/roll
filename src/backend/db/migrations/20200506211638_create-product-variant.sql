-- migrate:up
create table "product_variant"
    ( "pvid" serial primary key
    , "pid" integer references "product" ("pid")
    , "slug" varchar(32) not null
    , "name" text not null
    , "code" text not null
    , "price" integer not null
    , "description" text null
    , constraint product_variant_slug_unique unique ("slug")
    , constraint product_variant_code_unique unique ("code")
    );

insert into product_variant ("pid", "slug", "name", "code", "price", "description") values
    (1, 'nexty-alb', 'Alb', 'nexty-1', 100, null ),
    (1, 'nexty-gri', 'Gri', 'nexty-2', 100, null ),
    (1, 'nexty-bronz', 'Bronz', 'nexty-3', 100, null ),
    (2, 'legato-alb', 'Alb', 'legato-1', 100, null ),
    (2, 'legato-gri', 'Gri', 'legato-2', 100, null ),
    (2, 'legato-bronz', 'Bronz', 'legato-3', 100, null ),
    (3, 'squares-albmat', 'Alb mat', 'squares-1', 100, null ),
    (3, 'squares-champagne', 'Champagne', 'squares-2', 100, null ),
    (3, 'squares-bronz', 'Bronz', 'squares-3', 100, null ),
    (3, 'squares-auriumat', 'Auriu mat', 'squares-4', 100, null ),
    (3, 'squares-grisatinat', 'Gri satinat', 'squares-5', 100, null ),
    (4, 'squarem-albmat', 'Alb mat', 'squarem-1', 100, null ),
    (4, 'squarem-champagne', 'Champagne', 'squarem-2', 100, null ),
    (4, 'squarem-bronz', 'Bronz', 'squarem-3', 100, null ),
    (4, 'squarem-auriumat', 'Auriu mat', 'squarem-4', 100, null ),
    (4, 'squarem-grisatinat', 'Gri satinat', 'squarem-5', 100, null ),
    (5, 'rounds-albmat', 'Alb mat', 'rounds-1', 100, null ),
    (5, 'rounds-champagne', 'Champagne', 'rounds-2', 100, null ),
    (5, 'rounds-bronz', 'Bronz', 'rounds-3', 100, null ),
    (5, 'rounds-auriumat', 'Auriu mat', 'rounds-4', 100, null ),
    (5, 'rounds-grisatinat', 'Gri satinat', 'rounds-5', 100, null ),
    (6, 'roundm-albmat', 'Alb mat', 'roundm-1', 100, null ),
    (6, 'roundm-champagne', 'Champagne', 'roundm-2', 100, null ),
    (6, 'roundm-bronz', 'Bronz', 'roundm-3', 100, null ),
    (6, 'roundm-auriumat', 'Auriu mat', 'roundm-4', 100, null ),
    (6, 'roundm-grisatinat', 'Gri satinat', 'roundm-5', 100, null ),
    (7, 'esse-albmat', 'Alb mat', 'esse-1', 100, null ),
    (7, 'esse-grisatinat', 'Gri satinat', 'esse-2', 100, null ),
    (7, 'esse-negrumat', 'Negru mat', 'esse-3', 100, null ),
    (7, 'esse-crom', 'Crom', 'esse-4', 100, null ),
    (8, 'separe-alb', 'Alb', 'separe-1', 100, null ),
    (8, 'separe-crom', 'Crom', 'separe-2', 100, null ),
    (9, 'modulo205-alb', 'Alb', 'modulo205-1', 100, null ),
    (10, 'modulo105-alb', 'Alb', 'modulo105-1', 100, null ),
    (11, '1pliu-economicsimplu', 'Incretire economica, nedublat', '1pliu18s', 100, null ),
    (11, '1pliu-economicdublat', 'Incretire economica, dublat', '1pliu18d', 100, null ),
    (12, '2pliuri-mediusimplu', 'Incretire medie, nedublat', '2pliuri22s', 100, null ),
    (12, '2pliuri-mediudublat', 'Incretire medie, dublat', '2pliuri22d', 100, null ),
    (13, '3pliuri-maresimplu', 'Incretire mare, nedublat', '3pliuri26s', 100, null ),
    (13, '3pliuri-mareudublat', 'Incretire mare, dublat', '3pliuri26d', 100, null ),
    (14, 'pliuascuns-economicsimplu', 'Incretire economica, nedublat', 'pliuascuns18s', 100, null ),
    (14, 'pliuascuns-economicdublat', 'Incretire economica, dublat', 'pliuascuns18d', 100, null ),
    (14, 'pliuascuns-mediusimplu', 'Incretire medie, nedublat', 'pliuascuns22s', 100, null ),
    (14, 'pliuascuns-mediudublat', 'Incretire medie, dublat', 'pliuascuns22d', 100, null ),
    (14, 'pliuascuns-maresimplu', 'Incretire mare, nedublat', 'pliuascuns26s', 100, null ),
    (14, 'pliuascuns-mareudublat', 'Incretire mare, dublat', 'pliuascuns26d', 100, null ),
    (15, 'farapliuri-economicsimplu', 'Incretire economica, nedublat', 'farapliuri18s', 100, null ),
    (15, 'farapliuri-economicdublat', 'Incretire economica, dublat', 'farapliuri18d', 100, null ),
    (16, 'creion-mediusimplu', 'Incretire medie, nedublat', 'creion22s', 100, null ),
    (16, 'creion-mediudublat', 'Incretire medie, dublat', 'creion22d', 100, null ),
    (16, 'creion-maresimplu', 'Incretire mare, nedublat', 'creion26s', 100, null ),
    (16, 'creion-mareudublat', 'Incretire mare, dublat', 'creion26d', 100, null ),
    (17, 'wave-mediusimplu', 'Incretire medie, nedublat', 'wave22s', 100, null ),
    (17, 'wave-mediudublat', 'Incretire medie, dublat', 'wave22d', 100, null ),
    (18, 'inele-economicsimplu', 'Incretire economica, nedublat', 'inele18s', 100, null ),
    (18, 'inele-economicdublat', 'Incretire economica, dublat', 'inele18d', 100, null ),
    (18, 'inele-mediusimplu', 'Incretire medie, nedublat', 'inele22s', 100, null ),
    (18, 'inele-mediudublat', 'Incretire medie, dublat', 'inele22d', 100, null ),
    (19, 'material1-alb', 'Alb', 'material1-1', 100, null ),
    (19, 'material1-bej', 'Bej', 'material1-2', 100, null ),
    (19, 'material1-roz', 'Roz', 'material1-3', 100, null ),
    (20, 'material2-alb', 'Alb', 'material2-1', 100, null ),
    (20, 'material2-bej', 'Bej', 'material2-2', 100, null ),
    (20, 'material2-roz', 'Roz prafuit', 'material2-3', 100, null ),
    (20, 'material2-negru', 'negru', 'material2-4', 100, null )
    ;

-- migrate:down
drop table "product_variant"
