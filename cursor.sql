set serveroutput on;
begin
  update emp_20190509 set sal=sal+200 where empno = 7788;
  IF SQL%FOUND THEN 
  DBMS_OUTPUT.PUT_LINE('成功修改雇员工资');
  COMMIT;
  ELSE
  DBMS_OUTPUT.PUT_LINE('修改雇员工资失败');
  END IF;
end;
declare 
  v_ename varchar2(10);
  v_job varchar2(10);
  cursor emp_cursor is 
    select ename,job from emp_20190509 where empno = 7788;
  begin
    open emp_cursor;
    fetch emp_cursor into v_ename,v_job;
    dbms_output.put_line(v_ename || ',' || v_job);
    close emp_cursor;
  end;
  select *from emp_20190509 where empno=7788;
update emp_20190509 set job='ANALYST' where empno=7788;
commit;
declare 
  cursor emp_cursor is select ename,job,sal from emp /*where 
  empno=7788*/;
  emp_record emp_cursor%rowtype;
  begin
    open emp_cursor;
    fetch emp_cursor into emp_record;
    dbms_output.put_line(emp_record.ename || ',' || emp_record.job || ',' 
    || emp_record.sal);
    close emp_cursor;
    
  end;
declare 
  v_ename varchar2(20);
  v_sal number(5);
  cursor emp_cursor is select ename,sal from emp order by sal desc;
  begin
    open emp_cursor;
    for i in 1..3 loop
      fetch emp_cursor into v_ename,v_sal;
      dbms_output.put_line(v_ename || ',' || v_sal);
     
    end loop;
     close emp_cursor;
  end;
declare 
  cursor emp_cursor is 
  select empno,ename from emp;
  begin
    for emp_record in emp_cursor loop 
      dbms_output.put_line(emp_record.empno || emp_record.ename);
    end loop;
  end;
begin 
  for re in (select ename from emp) loop 
    dbms_output.put_line(re.ename);
  end loop;
end;
declare 
  v_ename varchar2(20);
  cursor emp_cursor is 
  select ename from emp;
begin
  /*open emp_cursor;*/
  if emp_cursor%isopen then 
  loop
    fetch emp_cursor into v_ename;
    exit when emp_cursor%notfound;
    dbms_output.put_line(to_char(emp_cursor%rowcount) || '-' || v_ename);
  end loop;
  else
  dbms_output.put_line('用户信息：游标没有打开');
  end if;
  close emp_cursor;
end;
--------带参数的游标----------
declare 
  v_empno number(5);
  v_ename varchar2(10);
  cursor emp_cursor(p_deptno number,p_job varchar2) is 
  select empno,ename from emp where deptno = p_deptno and job = p_job;
begin
  open emp_cursor(20,'CLERK');
  loop
    fetch emp_cursor into v_empno,v_ename;
    exit when emp_cursor%notfound;
    dbms_output.put_line(v_empno || ',' || v_ename);
  end loop;
  close emp_cursor;
end;
declare 
  v_empno number(5);
  v_ename varchar2(20);
  v_deptno number(5);
  v_job varchar2(10);
  cursor emp_cursor is select empno,ename from emp where deptno = v_deptno 
  and job = v_job;
begin
  v_deptno := 10;
  v_job := 'CLERK';
  open emp_cursor;
  loop
    fetch emp_cursor into v_empno,v_ename;
    exit when emp_cursor%notfound;
    dbms_output.put_line(v_empno || ',' || v_ename);
  end loop;
  close emp_cursor;
end;
----------动态select和动态游标---------------
declare 
  str varchar2(100);
  v_ename varchar2(10);
begin
  str := 'select ename from emp where empno = 7788';
  execute immediate str into v_ename;
  dbms_output.put_line(v_ename);
end;
declare 
  type cur_type is ref cursor;
  cur cur_type;
  rec emp%rowtype;
  str varchar2(50);
  letter char:='A';
begin
  loop
    str:= 'select ename from emp where ename like ''%' 
    || 
    letter
    ||
    '%''';
    open cur for str;
    dbms_output.put_line('包含字母' || letter || '的名字:');
    loop
      fetch cur into rec.ename;
      exit when cur%notfound;
      dbms_output.put_line(rec.ename);
    end loop;
    exit when letter = 'Z';
    letter := chr(ascii(letter)+1);
  end loop;
end;
select chr(65) from dual;
declare 
  v_name varchar2(10);
begin
  select ename into v_name from emp where empno=1234;
  dbms_output.put_line('该雇员的名字为：'||v_name);
  exception when no_data_found then 
  dbms_output.put_line('编号错误，没有找到相应的雇员');
  when others then 
  dbms_output.put_line('发生其它错误');
end;
declare 
  v_temp number(5):=1;
begin
  v_temp := v_temp/0;
  exception when others then
  dbms_output.put_line('发生系统错误');
  dbms_output.put_line('错误代码：'||SQLCODE());
  dbms_output.put_line('错误信息：'||SQLERRM());
end;
declare 
  v_ename varchar2(20);
  NULL_INSERT_ERROR exception;
  pragma exception_init(NULL_INSERT_ERROR,-1400); 
BEGIN
  INSERT INTO EMP(EMPNO) VALUES (NULL);
  EXCEPTION WHEN NULL_INSERT_ERROR THEN 
  DBMS_OUTPUT.PUT_LINE('无法插入NULL值');
  WHEN OTHERS THEN 
  DBMS_OUTPUT.PUT_LINE('发生其它系统错误');
END;
----自定义异常-----
DECLARE 
  NEW_NO NUMBER(10);
  NEW_EXCP1 EXCEPTION;
  NEW_EXCP2 EXCEPTION;
BEGIN
  NEW_NO := 6789;
  INSERT INTO EMP_20190509(EMPNO,ENAME) VALUES (NEW_NO,'小郑');
  IF new_no < 7000 then
    raise new_excp1;
  end IF;
  IF NEW_NO > 8000 THEN 
    RAISE NEW_EXCP2;
  END IF;
  COMMIT;
  EXCEPTION WHEN NEW_EXCP1 THEN 
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('雇员编号小于7000的下限');
    WHEN NEW_EXCP2 THEN 
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('雇员编号超过8000的上限');
END;
declare 
  new_no number(10);
begin 
  new_no:=8005;
  insert into emp_20190509(empno,ename) values (new_no,'JAMES');
  if new_no < 7000 then 
    rollback;
    raise_application_error(-20001,'编号小于7000下限');
  end if;
  if new_no > 8000 then
    rollback;
    raise_application_error(-20002,'编号大于8000上限');
  end if;
end;
declare 
  v_empno number(5) := 7895;
  emp_rec emp_20190509%rowtype;
begin
  select *from emp_20190509;
  
  select * into emp_rec from emp_20190509 where empno=v_empno;
  /*delete from emp_20190509 where empno = v_empno;*/
  insert into emp5 values emp_rec;
  if sql%found then 
    commit;
    dbms_output.put_line('雇员复制成功');
  else
    rollback;
    dbms_output.put_line('雇员复制失败');
  end if;
end;
create table emp5 as  select *from emp where 1 = 2;
select *from emp5;
select *from emp_20190509;
desc emp5;
begin 
  for re in (select ename,sal from emp_20190509) loop
    dbms_output.put_line(rpad(re.ename,12,' ') || rpad('*',re.sal/100,'*'));
  end loop;
end;
declare 
  v_count number:=0;
  cursor dept_cursor is select *from dept;
begin
  dbms_output.put_line('部门列表');
  dbms_output.put_line('-------------------');
  for dept_record in dept_cursor loop 
  dbms_output.put_line('部门编号：'||dept_record.deptno);
  dbms_output.put_line('部门名称：'||dept_record.dname);
  dbms_output.put_line('部门所在城市：'||dept_record.loc);
  dbms_output.put_line('--------------------');
  v_count := v_count+1;
  end loop;
  dbms_output.put_line('共有'|| to_char(v_count)||'个部门');
end;
declare 
  v_deptno number(8);
  v_count number(3);
  v_sumsal number(6);
  v_dname varchar2(15);
  v_manager varchar2(15);
  cursor list_cursor is select deptno,count(*),sum(sal) from emp group by deptno;
begin
  open list_cursor;
  dbms_output.put_line('-----------部门统计表-----------');
  dbms_output.put_line('部门名称  总人数   总工资   部门经理');
  fetch list_cursor into v_deptno,v_count,v_sumsal;
  while list_cursor%found loop
  select dname into v_dname from dept where deptno = v_deptno;
  select ename into v_manager from emp where deptno=v_deptno and job = 'MANAGER';
  dbms_output.put_line(rpad(v_dname,13)||rpad(to_char(v_count),8)||rpad(to_char(v_sumsal),9)
  ||v_manager);
  fetch list_cursor into v_deptno,v_count,v_sumsal;
  end loop;
  dbms_output.put_line('---------------------------');
  close list_cursor;
end;
select rpad('abc',13) from dual;
select *from emp where deptno=20;
declare 
  v_name char(10);
  v_empno number(5);
  v_sal number(8);
  v_sal1 number(8);
  v_total number(8):=800;
  v_num number(5):=0;
  cursor emp_cursor is select empno,ename,sal from emp_20190509 order by sal asc;
begin
  open emp_cursor;
  dbms_output.put_line('姓名  原工资   新工资');
  dbms_output.put_line('------------------------');
  loop
    fetch emp_cursor into v_empno,v_name,v_sal;
    exit when emp_cursor%notfound;
    v_sal1 := v_sal * 0.1;
    if v_total > v_sal1 then 
    v_total := v_total - v_sal1;
    v_num := v_num + 1;
    dbms_output.put_line(v_name || to_char(v_sal,'99999')||to_char(v_sal+v_sal1,'99999'));
    update emp_20190509 set sal=sal+v_sal1 where empno = v_empno;
    else
    dbms_output.put_line(v_name||to_char(v_sal,'99999')||to_char(v_sal,'99999'));
    end if;
    
  end loop;
  dbms_output.put_line('------------------------');
  dbms_output.put_line('新增工资人数：'||v_num||'剩余工资：'||v_total);
  close emp_cursor;
  commit;
end;
