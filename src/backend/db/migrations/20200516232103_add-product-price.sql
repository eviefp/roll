-- migrate:up
alter table "product_variant"
    add column price_formula text not null default 'todo = 42; out todo';

-- -----------------
-- tests

update "product_variant"
  set price_formula =
--    'in lungime'
'
in latime 150
pretPerCm = 123
pret = floor (pretPerCm * latime)
result = pret

out result
foo = 10
out foo
'
    where slug = 'nexty-alb';

update "product_variant"
  set price_formula =
'
in foo 1
bar = foo * 2
out bar

result = 123
out result
'
    where slug = '1pliu-economicsimplu';

update "product_variant"
  set price_formula =
'
in bar 0
in foo 0
foobar = foo + bar

out foobar
result = 456
out result
'
    where slug = 'material1-alb';

-- -------------
-- real info

update "product_variant"
  set price_formula =
--    'in lungime'
'
in latime 140
pretProfil = 1.3377
pretTerminal = 27.44
pretCarucioare = 1.37
pretClema = 9.95

latimeTrunchiata = max(140, floor(latime/20) * 20)
nrCarucioare = latimeTrunchiata / 10
nrCleme = 2 + ceiling( (latimeTrunchiata - 119) / 80)
pret = round( latimeTrunchiata * pretProfil 
            + pretTerminal 
            + nrCarucioare * pretCarucioare 
            + nrCleme * pretClema)

result = pret

out result
'
    where slug = 'esse-albmat';

-- migrate:down
alter table "product_variant" drop column price_formula

