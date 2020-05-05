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
    , "sid" integer references "supplier" ("sid")
    , "name" text not null
    , "description" text null
    , constraint product_slug_unique unique ("slug")
    );

-- migrate:down
drop table "product";

drop table "supplier";
