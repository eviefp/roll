-- migrate:up
alter table "product_variant"
    add column price_formula text not null default 'todo = 42; out todo';

update "product_variant"
  set price_formula =
--    'in lungime'
'
in latime
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
in foo
bar = foo * 2
out bar

result = 123
out result
'
    where slug = '1pliu-economicsimplu';

update "product_variant"
  set price_formula =
'
in bar
in foo
foobar = foo + bar

out foobar
result = 456
out result
'
    where slug = 'material1-alb';


-- migrate:down
alter table "product_variant" drop column price_formula

