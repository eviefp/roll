-- migrate:up
alter table "product"
    add column price_formula text not null default 'todo = 42; out todo';

update "product"
  set price_formula =
--    'in lungime'
'
pretPerCm = 123
pret = floor (pretPerCm * 2)
result = pret

out result
foo = 10
out foo
'
    where slug = 'nexty';

update "product"
  set price_formula =
'
in foo
bar = foo * 2
out bar

result = 123
out result
'
    where slug = '1pliu';

update "product"
  set price_formula =
'
in bar
in foo
foobar = foo + bar

out foobar
result = 456
out result
'
    where slug = 'material1';


-- migrate:down
alter table "product" drop column price_formula

