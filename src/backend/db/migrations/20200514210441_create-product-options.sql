-- migrate:up
create table "option"
    ( "oid" serial primary key
    , "name" text
    , "description" text
    );

create table "option_item"
    ( "oiid" serial primary key
    , "oid" integer references "option" ("oid")
    , "name" text
    );

create table "product_option"
    ( "poid" serial primary key
    , "pid" integer references "product" ("pid")
    , "oid" integer references "option" ("oid")
    );

insert into "option"
    ("name" , "description") values
    -- 1
    ( 'wave', 'Tipuri carucioare' )
    ;

insert into "option_item"
    ("oid", "name") values
    -- wave
    ( 1   , 'normale' )    ,
    ( 1   , 'wave' )
    ;

insert into "product_option"
    ("pid", "oid") values
    -- wave
    ( 3 , 1 ),
    ( 4 , 1 ),
    ( 5 , 1 ),
    ( 6 , 1 ),
    ( 7 , 1 ),
    ( 8 , 1 )
    ;

-- migrate:down
drop table "product_option";
drop table "option_item";
drop table "option";

