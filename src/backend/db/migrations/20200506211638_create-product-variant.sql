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

insert into product_variant 
    ("pid", "slug"                     , "name"                                      , "code"         , "price" , "description") values
    -- 1
    (1    , 'nexty-alb'                , 'Nexty Alb'                                 , 'nexty-1'      , 100     , null )               ,
    -- 2
    (1    , 'nexty-gri'                , 'Nexty Gri'                                 , 'nexty-2'      , 100     , null )               ,
    -- 3
    (1    , 'nexty-bronz'              , 'Nexty Bronz'                               , 'nexty-3'      , 100     , null )               ,
    -- 4
    (2    , 'legato-alb'               , 'Legato Alb'                                , 'legato-1'     , 100     , null )               ,
    -- 5
    (2    , 'legato-gri'               , 'Legato Gri'                                , 'legato-2'     , 100     , null )               ,
    -- 6
    (2    , 'legato-bronz'             , 'Legato Bronz'                              , 'legato-3'     , 100     , null )               ,
    -- 7
    (3    , 'squares-albmat'           , 'Square S Alb Mat'                          , 'squares-1'    , 100     , null )               ,
    -- 8
    (3    , 'squares-champagne'        , 'Square S Champagne'                        , 'squares-2'    , 100     , null )               ,
    -- 9
    (3    , 'squares-bronz'            , 'Square S Bronz'                            , 'squares-3'    , 100     , null )               ,
    -- 10
    (3    , 'squares-auriumat'         , 'Square S Auriu Mat'                        , 'squares-4'    , 100     , null )               ,
    -- 11
    (3    , 'squares-grisatinat'       , 'Square S Gri Satinat'                      , 'squares-5'    , 100     , null )               ,
    -- 12
    (4    , 'squarem-albmat'           , 'Square M Alb Mat'                          , 'squarem-1'    , 100     , null )               ,
    -- 13
    (4    , 'squarem-champagne'        , 'Square M Champagne'                        , 'squarem-2'    , 100     , null )               ,
    -- 14
    (4    , 'squarem-bronz'            , 'Square M Bronz'                            , 'squarem-3'    , 100     , null )               ,
    -- 15
    (4    , 'squarem-auriumat'         , 'Square M Auriu Mat'                        , 'squarem-4'    , 100     , null )               ,
    -- 16
    (4    , 'squarem-grisatinat'       , 'Square M Gri Satinat'                      , 'squarem-5'    , 100     , null )               ,
    -- 17
    (5    , 'rounds-albmat'            , 'Round S Alb Mat'                           , 'rounds-1'     , 100     , null )               ,
    -- 18
    (5    , 'rounds-champagne'         , 'Round S Champagne'                         , 'rounds-2'     , 100     , null )               ,
    -- 19
    (5    , 'rounds-bronz'             , 'Round S Bronz'                             , 'rounds-3'     , 100     , null )               ,
    -- 20
    (5    , 'rounds-auriumat'          , 'Round S Auriu Mat'                         , 'rounds-4'     , 100     , null )               ,
    -- 21
    (5    , 'rounds-grisatinat'        , 'Round S Gri Satinat'                       , 'rounds-5'     , 100     , null )               ,
    -- 22
    (6    , 'roundm-albmat'            , 'Round M Alb Mat'                           , 'roundm-1'     , 100     , null )               ,
    -- 23
    (6    , 'roundm-champagne'         , 'Round M Champagne'                         , 'roundm-2'     , 100     , null )               ,
    -- 24
    (6    , 'roundm-bronz'             , 'Round M Bronz'                             , 'roundm-3'     , 100     , null )               ,
    -- 25
    (6    , 'roundm-auriumat'          , 'Round M Auriu Mat'                         , 'roundm-4'     , 100     , null )               ,
    -- 26
    (6    , 'roundm-grisatinat'        , 'Round M Gri Satinat'                       , 'roundm-5'     , 100     , null )               ,
    -- 27
    (7    , 'esse-albmat'              , 'Esse Alb Mat'                              , 'esse-1'       , 100     , null )               ,
    -- 28
    (7    , 'esse-grisatinat'          , 'Esse Gri Satinat'                          , 'esse-2'       , 100     , null )               ,
    -- 29
    (7    , 'esse-negrumat'            , 'Esse Negru Mat'                            , 'esse-3'       , 100     , null )               ,
    -- 30
    (7    , 'esse-crom'                , 'Esse Crom'                                 , 'esse-4'       , 100     , null )               ,
    -- 31
    (8    , 'separe-alb'               , 'Separe Alb'                                , 'separe-1'     , 100     , null )               ,
    -- 32
    (8    , 'separe-crom'              , 'Separe Crom'                               , 'separe-2'     , 100     , null )               ,
    -- 33
    (9    , 'modulo205-alb'            , 'Modulo 205 Alb'                            , 'modulo205-1'  , 100     , null )               ,
    -- 34
    (10   , 'modulo105-alb'            , 'Modulo 105 Alb'                            , 'modulo105-1'  , 100     , null )               ,
    -- 35
    (11   , '1pliu-economicsimplu'     , '1 Pliu Incretire Economica Nedublata'      , '1pliu18s'     , 100     , null )               ,
    -- 36
    (11   , '1pliu-economicdublat'     , '1 Pliu Incretire Economica Dublata'        , '1pliu18d'     , 100     , null )               ,
    -- 37
    (12   , '2pliuri-mediusimplu'      , '2 Pliuri Incretire Medie Nedublata'        , '2pliuri22s'   , 100     , null )               ,
    -- 38
    (12   , '2pliuri-mediudublat'      , '2 Pliuri Incretire Medie Dublata'          , '2pliuri22d'   , 100     , null )               ,
    -- 39
    (13   , '3pliuri-maresimplu'       , '3 Pliuri Incretire Mare Nedublata'         , '3pliuri26s'   , 100     , null )               ,
    -- 40
    (13   , '3pliuri-mareudublat'      , '3 Pliuri Incretire Mare Dublata'           , '3pliuri26d'   , 100     , null )               ,
    -- 41
    (14   , 'pliuascuns-economicsimplu', 'Pliu Ascuns Incretire Economica Nedublata' , 'pliuascuns18s', 100     , null )               ,
    -- 42
    (14   , 'pliuascuns-economicdublat', 'Pliu Ascuns Incretire Economica Dublata'   , 'pliuascuns18d', 100     , null )               ,
    -- 43
    (14   , 'pliuascuns-mediusimplu'   , 'Pliu Ascuns Incretire Medie Nedublata'     , 'pliuascuns22s', 100     , null )               ,
    -- 44
    (14   , 'pliuascuns-mediudublat'   , 'Pliu Ascuns Incretire Medie Dublata'       , 'pliuascuns22d', 100     , null )               ,
    -- 45
    (14   , 'pliuascuns-maresimplu'    , 'Pliu Ascuns Incretire Mare Nedublata'      , 'pliuascuns26s', 100     , null )               ,
    -- 46
    (14   , 'pliuascuns-mareudublat'   , 'Pliu Ascuns Incretire Mare Dublata'        , 'pliuascuns26d', 100     , null )               ,
    -- 47
    (15   , 'farapliuri-economicsimplu', 'Fara Pliuri Incretire Economica Nedublata' , 'farapliuri18s', 100     , null )               ,
    -- 48
    (15   , 'farapliuri-economicdublat', 'Fara Pliuri Incretire Economica Dublata'   , 'farapliuri18d', 100     , null )               ,
    -- 49
    (16   , 'creion-mediusimplu'       , 'Rejansa Creion Incretire Medie Nedublata'  , 'creion22s'    , 100     , null )               ,
    -- 50 
    (16   , 'creion-mediudublat'       , 'Rejansa Creion Incretire Medie Dublata'    , 'creion22d'    , 100     , null )               ,
    -- 51
    (16   , 'creion-maresimplu'        , 'Rejansa Creion Incretire Mare Nedublata'   , 'creion26s'    , 100     , null )               ,
    -- 52
    (16   , 'creion-mareudublat'       , 'Rejansa Creion Incretire Mare Dublata'     , 'creion26d'    , 100     , null )               ,
    -- 53
    (17   , 'wave-mediusimplu'         , 'Wave Incretire Medie Nedublata'            , 'wave22s'      , 100     , null )               ,
    -- 54
    (17   , 'wave-mediudublat'         , 'Wave Incretire Medie Dublata'              , 'wave22d'      , 100     , null )               ,
    -- 55
    (18   , 'inele-economicsimplu'     , 'Inele Incretire Economica Nedublata'       , 'inele18s'     , 100     , null )               ,
    -- 56
    (18   , 'inele-economicdublat'     , 'Inele Incretire Economica Dublata'         , 'inele18d'     , 100     , null )               ,
    -- 57
    (18   , 'inele-mediusimplu'        , 'Incretire Medie Nedublata'                 , 'inele22s'     , 100     , null )               ,
    -- 58
    (18   , 'inele-mediudublat'        , 'Incretire Medie Dublata'                   , 'inele22d'     , 100     , null )               ,
    -- 59
    (19   , 'material1-alb'            , 'Material 1 Alb'                            , 'material1-1'  , 100     , null )               ,
    -- 60
    (19   , 'material1-bej'            , 'Material 1 Bej'                            , 'material1-2'  , 100     , null )               ,
    -- 61
    (19   , 'material1-roz'            , 'Material 1 Roz'                            , 'material1-3'  , 100     , null )               ,
    -- 62
    (20   , 'material2-alb'            , 'Material 2 Alb'                            , 'material2-1'  , 100     , null )               ,
    -- 63
    (20   , 'material2-bej'            , 'Material 2 Bej'                            , 'material2-2'  , 100     , null )               ,
    -- 64
    (20   , 'material2-roz'            , 'Material 2 Roz Prafuit'                    , 'material2-3'  , 100     , null )               ,
    -- 65
    (20   , 'material2-negru'          , 'Material 2 Negru'                          , 'material2-4'  , 100     , null )
    ;

-- migrate:down
drop table "product_variant"
