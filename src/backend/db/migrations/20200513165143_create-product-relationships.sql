-- migrate:up
create table "product_relationship"
    ( "prid" serial primary key
    , "left" integer references "product" ("pid")
    , "right" integer references "product" ("pid")
    , constraint product_relationship_lr_unique unique ("left", "right")
    );

insert into "product_relationship" 
    ("left", "right") values
    -- sisteme cu manopera
    -- nexty
    ( 1    , 11 )           ,
    ( 1    , 12 )           ,
    ( 1    , 13 )           ,
    ( 1    , 14 )           ,
    ( 1    , 15 )           ,
    ( 1    , 16 )           ,
    -- legato
    ( 2    , 11 )           ,
    ( 2    , 12 )           ,
    ( 2    , 13 )           ,
    ( 2    , 14 )           ,
    ( 2    , 15 )           ,
    ( 2    , 16 )           ,
    -- squares
    ( 3    , 11 )           ,
    ( 3    , 12 )           ,
    ( 3    , 13 )           ,
    ( 3    , 14 )           ,
    ( 3    , 15 )           ,
    ( 3    , 16 )           ,
    ( 3    , 17 )           ,
    -- squarem
    ( 4    , 11 )           ,
    ( 4    , 12 )           ,
    ( 4    , 13 )           ,
    ( 4    , 14 )           ,
    ( 4    , 15 )           ,
    ( 4    , 16 )           ,
    ( 4    , 17 )           ,
    -- rounds
    ( 5    , 11 )           ,
    ( 5    , 12 )           ,
    ( 5    , 13 )           ,
    ( 5    , 14 )           ,
    ( 5    , 15 )           ,
    ( 5    , 16 )           ,
    ( 5    , 17 )           ,
    -- roundm
    ( 6    , 11 )           ,
    ( 6    , 12 )           ,
    ( 6    , 13 )           ,
    ( 6    , 14 )           ,
    ( 6    , 15 )           ,
    ( 6    , 16 )           ,
    ( 6    , 17 )           ,
    -- esse
    ( 7    , 11 )           ,
    ( 7    , 12 )           ,
    ( 7    , 13 )           ,
    ( 7    , 14 )           ,
    ( 7    , 15 )           ,
    ( 7    , 16 )           ,
    ( 7    , 17 )           ,
    -- separe
    ( 8    , 11 )           ,
    ( 8    , 12 )           ,
    ( 8    , 13 )           ,
    ( 8    , 14 )           ,
    ( 8    , 15 )           ,
    ( 8    , 16 )           ,
    ( 8    , 17 )           ,
    -- modulo205
    ( 9    , 11 )           ,
    ( 9    , 12 )           ,
    ( 9    , 13 )           ,
    ( 9    , 14 )           ,
    ( 9    , 15 )           ,
    ( 9    , 16 )           ,
    -- modulo105
    (10    , 11 )           ,
    ( 10   , 12 )           ,
    ( 10   , 13 )           ,
    ( 10   , 14 )           ,
    ( 10   , 15 )           ,
    ( 10   , 16 )           ,
    -- draft
    -- a se completa cu materiale reale
    -- materiale cu manopera
    ( 19   , 11 )           ,
    ( 19   , 12 )           ,
    ( 19   , 13 )           ,
    ( 19   , 14 )           ,
    ( 19   , 15 )           ,
    ( 19   , 16 )           ,
    ( 19   , 17 )           ,
    ( 19   , 18 )           ,
    --
    ( 20   , 11 )           ,
    ( 20   , 12 )           ,
    ( 20   , 13 )           ,
    ( 20   , 14 )           ,
    ( 20   , 15 )           ,
    ( 20   , 16 )           ,
    ( 20   , 17 )           ,
    ( 20   , 18 )           ,
    -- draft
    -- a se completa cu materiale reale
    -- materiale cu sisteme
    ( 19   , 1 )            ,
    ( 19   , 2 )            ,
    ( 19   , 3 )            ,
    ( 19   , 4 )            ,
    ( 19   , 5 )            ,
    ( 19   , 6 )            ,
    ( 19   , 7 )            ,
    ( 19   , 8 )            ,
    ( 19   , 9 )            ,
    ( 19   , 10 )           ,
    --
    ( 20   , 1 )            ,
    ( 20   , 2 )            ,
    ( 20   , 3 )            ,
    ( 20   , 4 )            ,
    ( 20   , 5 )            ,
    ( 20   , 6 )            ,
    ( 20   , 7 )            ,
    ( 20   , 8 )            ,
    ( 20   , 9 )            ,
    ( 20   , 10 )
    ;

-- migrate:down
drop table "product_relationship";
