create table accounts
(
    id       serial primary key,
    acc_name varchar(50),
    balance  numeric
);
insert into accounts(acc_name, balance)
values ('Nguyen Van A', 5000),
       ('Tran Van B', 2000);
begin;

-- Kiểm tra số dư tài khoản gửi (id = 1)
do
$$
    declare
        sender_balance numeric;
    begin
        select balance into sender_balance from accounts where id = 1;

        if sender_balance < 1000 then
            raise exception 'Not enough balance!';
        end if;
    end
$$;

-- Trừ tiền người gửi
update accounts
set balance = balance - 1000
where id = 1;

-- Cộng tiền người nhận
update accounts
set balance = balance + 1000
where id = 2;

commit;
select *
from accounts;
begin;

do
$$
    declare
        sender_balance numeric;
    begin
        select balance into sender_balance from accounts where id = 1;

        if sender_balance < 10000 then
            raise exception 'Not enough balance!';
        end if;
    end
$$;

-- Nếu Exception xảy ra → PostgreSQL sẽ tự động rollback
-- Các lệnh dưới sẽ KHÔNG chạy
update accounts
set balance = balance - 10000
where id = 1;

update accounts
set balance = balance + 10000
where id = 2;

commit;
select *
from accounts;
