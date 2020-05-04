-- migrate:up
create table "category"
    ( "id" serial primary key
    , "slug" varchar(32) not null
    , "name" text not null
    , constraint slug_unique unique ("slug")
    );

insert into category ("slug", "name") values
    ( 'sisteme', 'Sisteme perdele' ),
    ( 'materiale', 'Materiale' ),
    ( 'manopera', 'Manopera' );

-- migrate:down

