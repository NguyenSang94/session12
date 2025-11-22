create table customers(
    id serial primary key ,
    name varchar(50),
    email varchar(50)
);

create table customer_log(
    log_id serial primary key,
    customer_name varchar(50),
    action_time timestamp
);

create or replace function insert_customers()
returns trigger
language plpgsql
as $$
    begin
        insert into customer_log( customer_name, action_time) values
        (new.name, now() );
        return new;
    end;
    $$;

create or replace trigger trg_insert_customers
    after insert on customers
    for each row
    execute function insert_customers();


insert into customers(name, email)
values
    ('Nguyen Van A', 'a@gmail.com'),
    ('Tran Thi B', 'b@gmail.com'),
    ('Le Van C', 'c@gmail.com');
select * from customer_log;
