create table employees(
    emp_id serial primary key,
    name varchar(50),
    position varchar(50)
);

create table employee_log(
    log_id serial primary key ,
    emp_name varchar(50),
    action_time timestamp
);

create or replace function nv_add_employee()
returns trigger
language plpgsql
as $$
    begin
        insert into employee_log(emp_name, action_time) values
        (new.emp_name, now());
        return new;
    end;
    $$;
create or replace trigger nv_update_employee
    after update on employee_log
    for each row
    execute function nv_add_employee();
update employees
set name = 'Nguyễn Văn B', position = 'Quản lý'
where emp_id = 1;
select * from employee_log;
