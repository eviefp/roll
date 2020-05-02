-- migrate:up
create table "quote"
    ( "qid" serial primary key
    , "text" text not null
    );

insert into quote ("text") values
    ( 'Jon Skeet''s addition operator doesn''t commute; it teleports to where he needs it to be.' ),
    ( 'Anonymous methods and anonymous types are really all called Jon Skeet. They just don''t like to boast.' ),
    ( 'Jon Skeet''s code doesn''t follow a coding convention. It is the coding convention.' ),
    ( 'Jon Skeet doesn''t have performance bottlenecks. He just makes the universe wait its turn.' ),
    ( 'Users don''t mark Jon Skeet''s answers as accepted. The universe accepts them out of a sense of truth and justice.' ),
    ( 'Jon Skeet can divide by zero.' ),
    ( 'When Jon Skeet''s code fails to compile the compiler apologises.' ),
    ( 'Jon Skeet can recite π. Backwards' );

-- migrate:down
drop table "quote"

