-- migrate:up
create table "product_relationship"
    ( "prid" serial primary key
    , "left" integer references "product" ("pid")
    , "right" integer references "product" ("pid")
    , constraint product_relationship_lr_unique unique ("left", "right")
    );

insert into "product_relationship" ("left", "right") values
    ( 1, 19 ),
    ( 1, 11 );

-- migrate:down
drop table "product_relationship";
