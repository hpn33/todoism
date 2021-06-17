# todoism

برنامه ای برای ثبت کار ها با دسته بندی و قابل حساب 

کارهای آینده و کارهای انجام نشده گذشته نشون داده میشه

دسته بندی و یکپارچه سازی کارها با پرچسب صورت میگیره
حتی ایجاد هدف و پروژه هم همین طور
هر کار یه زمان بیشتر نمیگیره

اگر میخوای یک حالت روتین هم داشته باشیم باید برای هر کدوم یک کار جداگانه بسازیم و با برچسب به هم ارتباط بدیم

یا یه بخش روتین بسازیم
یه جدول در دیتابیس



## Concept

### task

کار
جزئیات کار یا وظیفه 
عنوان
توضیحات
لیست
برچسب

### project

پروژه
میشه برجسب پیش فرض تایین کرد
داخل پروژه میشه کار و پرچم ساخت





## ideas

### Order

which task is importent

HOW
> make a order table for dayLists
> 
> or
> 
> add order in task dayList relation 

---

### Goal

different goal for make life easier
some time we make many task but which is improtant

some time we make a decition to our life and make a goal but also we to other stuff that not push us to our goal so we need to categoraiz this

HOW
> simple way is making task for it
> 
> make a table for goals

----

### Projects

a project that happend by tasks

HOW
> easy wah organaize with tags
> 
> make a table for projects
> 
> or use tag as a project ( any tasks is use some tag is under projct )

----

### هدفمند بودن
وقتی یک هدف انتخاب میشه به صورت مداوم کاری در اون راستا انجام میشه
باید به نحوی این کار ها را در یک راستا قرار داد و قابل محاسبه باشد

نمایش میزان تگها در روز



### روتین
بعضی کار های به صورت تکراری هستند
نیاز 




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
- [x] delete task from day lsit
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




## برای دیتا بیس

task table
> برای کار
* id
* title
* descript
* state

day list table
> ساخت لیست برای کارهای روز
* id
* date


task todo relation table
> برای ارتباط کارها با لیست
* id
* list_id
* task_id


tag table
> برای موضوع بندی کارها
* id
* tag_parent_id
* title
* descript


task tag relation table
> ارتباط کار و تگ
* id
* task_id
* tag_id

