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

insert into "option" ("name", "description") values
    ( 'wave', 'bla' ),
    ( 'foo', 'foobar' );

insert into "option_item" ("oid", "name") values
    -- wave
    ( 1, 'da' ),
    ( 1, 'nu' ),
    -- foo
    ( 2, 'bar' ),
    ( 2, 'baz' );

insert into "product_option" ("pid", "oid") values
    ( 1 , 1 ),
    ( 2 , 2 );

-- migrate:down
drop table "product_option";
drop table "option_item";
drop table "option";

