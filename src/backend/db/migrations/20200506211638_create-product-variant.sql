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
    (1, 'prevvy', 'Prevy + Nexty = Identity', '1234', null);

-- migrate:down
drop table "product_variant"
