create or replace function fn_check_product()
    returns trigger
    language plpgsql
as
$$
declare
    cruuent_stock int;
begin
    select stock
    into cruuent_stock
    from products
    where product_id = new.product_id;
    if cruuent_stock is null then
        raise exception 'San Pham khong ton tai';
    end if;
    if cruuent_stock - new.quantiy < 0 then
        raise exception 'So luong vươt qua';

    end if;
    return new;
end;
$$;

create or replace function fn_update_stock()
returns trigger
language plpgsql
as $$
    begin
        update products
        set stock = stock - new.quantiy
        where product_id = new.product_id;
    end;
    $$;
create or replace trigger trig_fn_update_stock
    after insert on sales
    for each row
    execute function fn_update_stock();

insert into products(name, stock)
values
    ('iPhone 15', 5),
    ('Samsung S24', 10),
    ('Oppo Reno 11', 3);
select * from products;
