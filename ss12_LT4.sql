create table orders(
    order_id serial primary key ,
    product_id int references products(product_id),
    quantity int,
    total_amount numeric
);

create or replace function fn_total_amount_order()
returns trigger
language plpgsql
as $$
    declare product_price numeric;
    begin
    select price into product_price from products
        where product_id = new.product_id;

    if product_price is null then
        raise exception 'San Pham Khong ton tai';
    end if;
    new.total_amount = new.quantity * product_price;
    return new;
    end;
    $$;

create or replace trigger trg_total_order
    before insert on orders
    for each row
    execute function fn_total_amount_order();

insert into orders(product_id, quantity)
values
    (1, 2),   -- 2 cái iPhone 15
    (2, 1),   -- 1 cái Samsung S24
    (3, 3);   -- 3 cái Oppo Reno 11
select * from orders;
