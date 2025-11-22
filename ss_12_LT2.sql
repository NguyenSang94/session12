create table products(
    product_id serial primary key ,
    name varchar(50),
    stock int
);
create table sales(
    sale_id serial primary key ,
    product_id int references products(product_id),
    quantity int
);

create or replace function check_product()
    returns trigger
    language plpgsql
as $$
declare
    stock_int int;
begin
    -- Lấy tồn kho
    select stock into stock_int
    from products
    where product_id = NEW.product_id;

    -- Kiểm tra sản phẩm có tồn tại
    if stock_int is null then
        raise exception 'San pham khong ton tai';
    end if;

    -- Kiểm tra tồn kho đủ hay không
    if stock_int < NEW.quantity then
        raise exception 'So luong ton kho khong du. Ton kho: %, Dat mua: %',
            stock_int, NEW.quantity;
    end if;

    return NEW;
end;
$$;

create or replace trigger trig_before_insert
    before insert on sales
    for each row
    execute function check_product();
insert into products(name, stock)
values
    ('iPhone 15', 5),
    ('Samsung S24', 10),
    ('Oppo Reno 11', 3);
insert into sales(product_id, quantity)
values (1, 2);
