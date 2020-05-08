-- migrate:up
create table "product_variant"
    ( "pvid" serial primary key
    , "pid" integer references "product" ("pid")
    , "slug" varchar(32) not null
    , "name" text not null
    , "code" text not null
    , "description" text null
    , constraint product_variant_slug_unique unique ("slug")
    , constraint product_variant_code_unique unique ("code")
    );

insert into product_variant ("pid", "slug", "name", "code", "description") values
    (1, 'nexty-alb', 'Alb', 'nexty-1', null),
    (1, 'nexty-gri', 'Gri', 'nexty-2', null),
    (1, 'nexty-bronz', 'Bronz', 'nexty-3', null),
    (2, 'legato-alb', 'Alb', 'legato-1', null),
    (2, 'legato-gri', 'Gri', 'legato-2', null),
    (2, 'legato-bronz', 'Bronz', 'legato-3', null),
    (3, 'squares-albmat', 'Alb mat', 'squares-1', null),
    (3, 'squares-champagne', 'Champagne', 'squares-2', null),
    (3, 'squares-bronz', 'Bronz', 'squares-3', null),
    (3, 'squares-auriumat', 'Auriu mat', 'squares-4', null),
    (3, 'squares-grisatinat', 'Gri satinat', 'squares-5', null),
    (4, 'squarem-albmat', 'Alb mat', 'squarem-1', null),
    (4, 'squarem-champagne', 'Champagne', 'squarem-2', null),
    (4, 'squarem-bronz', 'Bronz', 'squarem-3', null),
    (4, 'squarem-auriumat', 'Auriu mat', 'squarem-4', null),
    (4, 'squarem-grisatinat', 'Gri satinat', 'squarem-5', null),
    (5, 'rounds-albmat', 'Alb mat', 'rounds-1', null),
    (5, 'rounds-champagne', 'Champagne', 'rounds-2', null),
    (5, 'rounds-bronz', 'Bronz', 'rounds-3', null),
    (5, 'rounds-auriumat', 'Auriu mat', 'rounds-4', null),
    (5, 'rounds-grisatinat', 'Gri satinat', 'rounds-5', null),
    (6, 'roundm-albmat', 'Alb mat', 'roundm-1', null),
    (6, 'roundm-champagne', 'Champagne', 'roundm-2', null),
    (6, 'roundm-bronz', 'Bronz', 'roundm-3', null),
    (6, 'roundm-auriumat', 'Auriu mat', 'roundm-4', null),
    (6, 'roundm-grisatinat', 'Gri satinat', 'roundm-5', null),
    (7, 'esse-albmat', 'Alb mat', 'esse-1', null),
    (7, 'esse-grisatinat', 'Gri satinat', 'esse-2', null),
    (7, 'esse-negrumat', 'Negru mat', 'esse-3', null),
    (7, 'esse-crom', 'Crom', 'esse-4', null),
    (8, 'separe-alb', 'Alb', 'separe-1', null),
    (8, 'separe-crom', 'Crom', 'separe-2', null),
    (9, 'modulo205-alb', 'Alb', 'modulo205-1', null),
    (10, 'modulo105-alb', 'Alb', 'modulo105-1', null),
    (11, '1pliu-economicsimplu', 'Incretire economica, nedublat', '1pliu18s', null),
    (11, '1pliu-economicdublat', 'Incretire economica, dublat', '1pliu18d', null),
    (12, '2pliuri-mediusimplu', 'Incretire medie, nedublat', '2pliuri22s', null),
    (12, '2pliuri-mediudublat', 'Incretire medie, dublat', '2pliuri22d', null),
    (13, '3pliuri-maresimplu', 'Incretire mare, nedublat', '3pliuri26s', null),
    (13, '3pliuri-mareudublat', 'Incretire mare, dublat', '3pliuri26d', null),
    (14, 'pliuascuns-economicsimplu', 'Incretire economica, nedublat', 'pliuascuns18s', null),
    (14, 'pliuascuns-economicdublat', 'Incretire economica, dublat', 'pliuascuns18d', null),
    (14, 'pliuascuns-mediusimplu', 'Incretire medie, nedublat', 'pliuascuns22s', null),
    (14, 'pliuascuns-mediudublat', 'Incretire medie, dublat', 'pliuascuns22d', null),
    (14, 'pliuascuns-maresimplu', 'Incretire mare, nedublat', 'pliuascuns26s', null),
    (14, 'pliuascuns-mareudublat', 'Incretire mare, dublat', 'pliuascuns26d', null),
    (15, 'farapliuri-economicsimplu', 'Incretire economica, nedublat', 'farapliuri18s', null),
    (15, 'farapliuri-economicdublat', 'Incretire economica, dublat', 'farapliuri18d', null),
    (16, 'creion-mediusimplu', 'Incretire medie, nedublat', 'creion22s', null),
    (16, 'creion-mediudublat', 'Incretire medie, dublat', 'creion22d', null),
    (16, 'creion-maresimplu', 'Incretire mare, nedublat', 'creion26s', null),
    (16, 'creion-mareudublat', 'Incretire mare, dublat', 'creion26d', null),
    (17, 'wave-mediusimplu', 'Incretire medie, nedublat', 'wave22s', null),
    (17, 'wave-mediudublat', 'Incretire medie, dublat', 'wave22d', null),
    (18, 'inele-economicsimplu', 'Incretire economica, nedublat', 'inele18s', null),
    (18, 'inele-economicdublat', 'Incretire economica, dublat', 'inele18d', null),
    (18, 'inele-mediusimplu', 'Incretire medie, nedublat', 'inele22s', null),
    (18, 'inele-mediudublat', 'Incretire medie, dublat', 'inele22d', null),
    (19, 'material1-alb', 'Alb', 'material1-1', null),
    (19, 'material1-bej', 'Bej', 'material1-2', null),
    (19, 'material1-roz', 'Roz', 'material1-3', null),
    (20, 'material2-alb', 'Alb', 'material2-1', null),
    (20, 'material2-bej', 'Bej', 'material2-2', null),
    (20, 'material2-roz', 'Roz prafuit', 'material2-3', null),
    (20, 'material2-negru', 'negru', 'material2-4', null)
    ;

-- migrate:down
drop table "product_variant"
