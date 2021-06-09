# todoism


برنامه ای  برای ثبت
کار های روز
با ساعت انجام
زمان صرف شده

دسته بندی کارها
برنامه فردا



## views

### dashboard
- [x] not compelete old tasks
- [x] today tasks
- [x] upcomming tasks - order by near task and remain time

### todos
show all todos

- [x] add task freely
- [x] delete task
- [x] filter

### date
filter by day date

- [x] add task to day list
- [x] add exist task to day list
- [ ] delete task from day lsit
- [ ] 

### tag
filter by tags

- [ ] add tag
- [x] delete tag
- [ ] list of task on tag

### flag
this is todo that can mark on any day

- [ ] add flag
- [ ] check on day




task
id
title
create
update

task_data
id
key
value

* start_time
* end_time
* time
* type
* done
* tag


tag
id
title



task hello tomarrow




today
all list
todo list
list to done







-------------
ایده جدید

برای هر روز یه لیست وجوود داره
میشه درصد انجام کار ها رو نمایش داد
اگر کاری نداشته باشه چیزی نشون نمیده
اگر ایتم داشته باشه با توجه به کار های انجام شده درصد کارهای انجام شده و تعداد کارهای انجام شده به کارهای تمام کار ها رو نشون میده


با وارد کردن کارها یه ایتم ساخته میشه برای همون کار
اگر یه کار توی روزی که هست انجام نشه فردا یا هر موقع دیگه میشه به لیست اضافه کرد
یا اگر دیگه لازم نبود خط زده بشه

اگر لیست تمام کار ها رو نمایش بدیم هر کار منحصر به فرد هست


## برای دیتا بیس

task table
برای کار
id
title
descript
state

day list table
ساخت لیست برای کارهای روز
id
date


task todo relation table
برای ارتباط کارها با لیست
id
list_id
task_id


tag table
برای موضوع بندی کارها
id
tag_parent_id
title
descript


task tag relation table
ارتباط کار و تگ
id
task_id
tag_id


کار ها به طور کلی ساخته میشوند
اگر کار در روز مورد نظر ساخته شود در لیست روز قرار میگیرد
میتوان کار ها را با استفاده از برچسب ها مدیریت کرد



نمایش کارها

نمایش تمام کارها
نمایش کارها در روز
نمایش کارها در روز و برچسب
نمایش کارها بر اساس برچسب



وقتی یه کار درست میکنم در همون روزی که درست شده ثبت میشه
اگر بخوام جا به جاش کنم تاریخش هم عوض میشه

اگر یه کار در یک روز انجام نشه ولی اهمیتش در حدی باشه که نیاز به انجام حتمی باشه
نیازه که اون کار در روز های آینده هم در لیست روز قرار بگیره

راحل
یک راحل ایجاد جدولی برای درست کردن لیست هایی که کار های روز در اون ذخیره میشه
و دیگه نیاز به ساخت کار جدید نیست و از همون کار ثبت شده میشه استفاده کرد

راحل بعدی ساخت امکان ارث بری از وظیفه دیگه هست یعنی وظیفه ای جدید ثبت بشه و از اطلاعات وظیفه قبلی استفاده کنه

هر دو امکان پذیر هستند


## Concept

### task

کار
جزئیات کار یا وظیفه 

### project

پروژه
شاید همون پرچم باشه؟!
یه تعداد تگ تایین میشه و به هرچی کار برای این پروژه ساخته بشه چسبانده میشه