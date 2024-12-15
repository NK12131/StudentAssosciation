if not exists (select * from sys.databases where name = 'student_jobs')
    create database student_jobs
go

use student_jobs

go=

-- Down

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_students_majors_student_id')
    alter table students_majors drop constraint if exists fk_students_majors_student_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_students_majors_major_id')
    alter table students_majors drop constraint fk_students_majors_major_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_assosiation_member_student_id')
    alter table association_members drop constraint fk_assosiation_member_student_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_students_events_student_id')
    alter table students_events drop constraint fk_students_events_student_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_students_events_event_id')
    alter table students_events drop constraint fk_students_events_event_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_employers_events_employer_id')
    alter table employers_events drop constraint fk_employers_events_employer_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_employers_events_event_id')
    alter table employers_events drop constraint fk_employers_events_event_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_employers_industries_employer_id')
    alter table employers_industries drop constraint fk_employers_industries_employer_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_employers_industries_industry_id')
    alter table employers_industries drop constraint fk_employers_industries_industry_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_job_employer_id')
    alter table jobs drop constraint fk_job_employer_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_application_job_id')
    alter table applications drop constraint fk_application_job_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_application_employer_id')
    alter table applications drop constraint fk_application_employer_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_application_student_id')
    alter table applications drop constraint fk_application_student_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_feedback_student_id')
    alter table feedbacks drop constraint fk_feedback_student_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    where constraint_name = 'fk_feedback_event_id')
    alter table feedbacks drop constraint fk_feedback_event_id

drop table if exists students
drop table if exists majors
drop table if exists students_majors
drop table if exists association_members
drop table if exists events
drop table if exists employers
drop table if exists students_events
drop table if exists employers_events
drop table if exists industries
drop table if exists employers_industries
drop table if exists jobs
drop table if exists applications
drop table if exists feedbacks

go

--Up Metadata

create table students (
    student_id int identity not null,
    student_firstname varchar(25) not null,
    student_lastname varchar(25) not null,
    student_mobile char(10) not null,
    student_email varchar(30) not null,
    constraint pk_student_id primary key (student_id),
    constraint u_student_mobile unique (student_mobile),
    constraint u_student_email unique (student_email)
)

create table majors (
    major_id int identity not null,
    major_name varchar(25) not null,
    constraint pk_major_id primary key (major_id),
    constraint u_major_name unique (major_name)
)

create table students_majors(
    student_id int not null,
    major_id int not null,
    student_major_graduation_year date null,
    constraint pk_student_id_major_id primary key (student_id,major_id),
    constraint fk_students_majors_student_id foreign key (student_id) 
    references students(student_id),
    constraint fk_students_majors_major_id foreign key (major_id)
    references majors(major_id)
)

create table association_members(
    association_member_id int identity not null,
    association_member_position varchar(30) not null,
    association_member_responsibilities varchar(100) not null,
    association_member_student_id int not null,
    constraint pk_association_member_id primary key (association_member_id),
    constraint fk_assosiation_member_student_id foreign key (association_member_student_id)
    references students (student_id)
)

create table events(
    event_id int identity not null,
    event_title varchar(30) not null,
    event_datetime datetime not null,
    event_location varchar(100) not null,
    event_description varchar(200) null,
    constraint pk_event_id primary key (event_id),
    constraint u_event_title_datetime_location unique (event_title,event_location,event_datetime)
)

create table students_events(
    student_id int not null,
    event_id int not null,
    constraint pk_student_id_event_id primary key (student_id,event_id),
    constraint fk_students_events_student_id foreign key (student_id)
    references students(student_id),
    constraint fk_students_events_event_id foreign key (event_id)
    references events(event_id)
)

create table employers(
    employer_id int identity not null,
    employer_company_name varchar(30) not null,
    employer_email varchar(30) not null,
    employer_contact char(10) not null,
    constraint pk_employer_id primary key (employer_id),
    constraint u_employer_email unique (employer_email)
)

create table employers_events(
    employer_id int not null,
    event_id int not null,
    constraint pk_employer_id_event_id primary key (employer_id,event_id),
    constraint fk_employers_events_employer_id foreign key (employer_id)
    references employers(employer_id),
    constraint fk_employers_events_event_id foreign key (event_id)
    references events(event_id) 
)

create table industries(
    industry_id int identity not null,
    industry_name varchar(30) not null,
    constraint pk_industry_id primary key (industry_id),
    constraint u_industry_name unique (industry_name)
)

create table employers_industries(
    employer_id int not null,
    industry_id int not null,
    constraint pk_employer_id_industry_id primary key (employer_id,industry_id),
    constraint fk_employers_industries_employer_id foreign key (employer_id)
    references employers(employer_id),
    constraint fk_employers_industries_industry_id foreign key (industry_id)
    references industries(industry_id) 
)

create table jobs(
    job_id int identity not null,
    job_title varchar(50) not null,
    job_description varchar(2000) not null,
    job_type varchar(30) not null,
    job_duration varchar(30) null,
    job_hours_per_week int not null,
    job_salary varchar(40) not null,  -- varchar because few jobs salaries just have range
    job_employer_id int not null,
    constraint pk_job_id primary key (job_id),
    constraint u_job_title_type_employer_id unique (job_title,job_type,job_employer_id),
    constraint fk_job_employer_id foreign key (job_employer_id)
    references employers(employer_id) 
)

create table applications(
    application_id int identity not null,
    application_job_id int not null,
    application_student_id int not null,
    application_employer_id int not null,
    application_resume_link varchar(100) not null,
    application_cover_letter_link varchar(100) null,
    application_status varchar(30) not null,
    constraint pk_application_id primary key (application_id),
    constraint u_application_job_id_student_id_employer_id 
    unique(application_job_id,application_employer_id,application_student_id),
    constraint fk_application_job_id foreign key (application_job_id)
    references jobs(job_id),
    constraint fk_application_employer_id foreign key (application_employer_id)
    references employers(employer_id),
    constraint fk_application_student_id foreign key (application_student_id)
    references students(student_id)    
)

create table feedbacks(
    feedback_id int identity not null,
    feedback_rating int not null,
    feedback_comments varchar(200) null,
    feedback_student_id int not null,
    feedback_event_id int not null,
    constraint pk_feedback_id primary key (feedback_id),
    constraint u_feedback_student_id_event_id unique (feedback_student_id,feedback_event_id),
    constraint fk_feedback_student_id foreign key (feedback_student_id)
    references students(student_id),
    constraint fk_feedback_event_id foreign key (feedback_event_id)
    references events(event_id),
    constraint ck_feedback_rating_range check 
    (feedback_rating >= 1 and feedback_rating <= 5)
)

go

INSERT INTO students (student_firstname, student_lastname, student_mobile, student_email)
VALUES
    ('John', 'Doe', '1234567801', 'john.doe@gmail.com'),
    ('Jane', 'Smith', '2345678902', 'jane.smith@gmail.com'),
    ('Michael', 'Johnson', '3456789013', 'michael.johnson@gmail.com'),
    ('Emily', 'Williams', '4567890124', 'emily.williams@gmail.com'),
    ('Christopher', 'Brown', '5678901235', 'christopher.brown@gmail.com'),
    ('Jessica', 'Jones', '6789012346', 'jessica.jones@gmail.com'),
    ('Matthew', 'Garcia', '7890123457', 'matthew.garcia@gmail.com'),
    ('Sarah', 'Martinez', '8901234568', 'sarah.martinez@gmail.com'),
    ('Daniel', 'Robinson', '9012345679', 'daniel.robinson@gmail.com'),
    ('Ashley', 'Clark', '0123456780', 'ashley.clark@gmail.com'),
    ('David', 'Lee', '1122334456', 'david.lee@gmail.com'),
    ('Amanda', 'Scott', '2233445567', 'amanda.scott@gmail.com'),
    ('James', 'Taylor', '3344556678', 'james.taylor@gmail.com'),
    ('Jennifer', 'Hernandez', '4455667789', 'jennifer.hernandez@gmail.com'),
    ('Andrew', 'Nguyen', '5566778890', 'andrew.nguyen@gmail.com'),
    ('Nicole', 'Lewis', '6677889901', 'nicole.lewis@gmail.com'),
    ('Justin', 'Walker', '7788990012', 'justin.walker@gmail.com'),
    ('Samantha', 'King', '8899001123', 'samantha.king@gmail.com'),
    ('NK', 'King', '9380178700', 'nithin.king@gmail.com'),
    ('Brandon', 'Hall', '9900112234', 'brandon.hall@gmail.com');


insert into majors (major_name) 
values
    ('Computer Science'),
    ('Electrical Engineering'),
    ('Applied Data Science'),
    ('Computer Engineering'),
    ('Information systems'),
    ('English Literature'),
    ('History'),
    ('Mathematics'),
    ('Chemistry'),
    ('Physics');

insert into association_members (association_member_position, association_member_responsibilities, association_member_student_id) 
values
    ('President', 'Organize and oversee association activities, represent the association in official events.', 1),
    ('Vice President', 'Assist the president, take over responsibilities in their absence.', 2),
    ('Vice President', 'Assist the president, take over responsibilities in their absence.', 6),
    ('Treasurer', 'Manage the associations finances, budgeting, and financial records.', 3),
    ('Secretary', 'Maintain meeting minutes, handle correspondence, and keep records.', 4),
    ('Event Coordinator', 'Plan and coordinate events, including logistics and scheduling.', 5),
    ('Social Media Manager', 'Manage the associations social media accounts, engage with members and followers.', 8)

insert into students_majors (student_id, major_id, student_major_graduation_year) 
values 
(1, 1, '2023-06-15'),
(2, 1, '2023-06-15'),
(3, 1, '2023-06-15'),
(4, 3, '2023-12-30'),
(5, 2, '2023-12-30'),
(6, 1, '2023-12-30'),
(7, 3, '2023-12-30'),
(8, 1, '2023-12-30'),
(9, 2, '2023-12-30'),
(10, 3, '2023-12-30'),
(11, 1, '2023-06-15'),
(12, 2, '2023-06-15'),
(13, 3, '2023-06-15'),
(13, 2, '2023-06-15'),
(14, 7, NULL),
(15, 2, NULL),
(16, 3, NULL),
(17, 5, NULL),
(18, 4, NULL),
(19, 3, NULL)


insert into events (event_title, event_datetime, event_location, event_description)
values
    ('spring Students Job Fair 1', '2023-04-07 09:00:00', 'Shine Hall Room 128', 'Jobs for students who need H1B Visa'),
    ('spring Students Job Fair 2', '2023-04-10 14:00:00', 'Hall of Languages', 'Jobs for resident students'),
    ('Fall Students Job Fair 1', '2023-10-15 10:30:00', 'Goldstein Auditorium', 'Jobs for students who need H1B Visa'),
    ('Fall Students Job Fair 2', '2023-11-20 08:00:00', 'Skybarn', 'Jobs for students who need H1B Visa'),
    ('Fall Students Job Fair 3', '2023-12-25 13:00:00', 'Meeting Room C', 'Jobs for resident students')

INSERT INTO employers (employer_company_name, employer_email, employer_contact)
VALUES 
    ('Google', 'contact@google.com', '1234567890'),
    ('Microsoft', 'contact@microsoft.com', '0987654321'),
    ('Apple', 'contact@apple.com', '1112223333'),
    ('Amazon', 'contact@amazon.com', '1234567890'),
    ('Tesla', 'contact@tesla.com', '0987654321'),
    ('Facebook', 'contact@facebook.com', '1112223333'),
    ('Alphabet Inc.', 'contact@alphabet.com', '4445556666'),
    ('Netflix', 'contact@netflix.com', '7778889999'),
    ('Samsung Electronics', 'contact@samsung.com', '1011121314'),
    ('Toyota Motor Corporation', 'contact@toyota.com', '1516171819'),
    ('IBM', 'contact@ibm.com', '2021222324'),
    ('Intel Corporation', 'contact@intel.com', '2526272829'),
    ('Cisco Systems', 'contact@cisco.com', '3031323334');

INSERT INTO industries (industry_name)
VALUES 
    ('Technology'),
    ('Automotive'),
    ('Social Media'),
    ('E-commerce'),
    ('Entertainment'),
    ('Consumer Electronics'),
    ('Software'),
    ('Telecommunications'),
    ('Manufacturing'),
    ('Finance');

INSERT INTO employers_industries (employer_id, industry_id)
VALUES 
    (1, 1),  -- Google - Technology
    (1, 3),  -- Google - Social Media
    (2, 2),  -- Microsoft - Automotive
    (2, 7),  -- Microsoft - Software
    (3, 1),  -- Apple - Technology
    (3, 6),  -- Apple - Consumer Electronics
    (4, 4),  -- Amazon - E-commerce
    (5, 5),  -- Tesla - Entertainment
    (6, 6),  -- Facebook - Consumer Electronics
    (6, 3),  -- Facebook - Social Media
    (7, 9),  -- Alphabet Inc. - Manufacturing
    (8, 7),  -- Netflix - Software
    (9, 8),  -- Samsung Electronics - Telecommunications
    (9, 6),  -- Samsung Electronics - Consumer Electronics
    (10, 10), -- Toyota Motor Corporation - Finance
    (11, 3),  -- IBM - Social Media
    (11, 7),  -- IBM - Software
    (12, 7),  -- Intel Corporation - Software
    (13, 8),  -- Cisco Systems - Telecommunications
    (13, 1);  -- Cisco Systems - Technology

INSERT INTO employers_events (employer_id, event_id)
VALUES 
    (1, 1),  -- Google - spring Students Job Fair 1
    (1, 2),  -- Google - spring Students Job Fair 2
    (2, 3),  -- Microsoft - Fall Students Job Fair 1
    (3, 3),  -- Apple - Fall Students Job Fair 1
    (4, 4),  -- Amazon - Fall Students Job Fair 2
    (5, 4),  -- Tesla - Fall Students Job Fair 2
    (6, 1),  -- Facebook - spring Students Job Fair 1
    (6, 2),  -- Facebook - spring Students Job Fair 2
    (7, 3),  -- Alphabet Inc. - Fall Students Job Fair 1
    (8, 5),  -- Netflix - Fall Students Job Fair 3
    (9, 4),  -- Samsung Electronics - Fall Students Job Fair 2
    (9, 5),  -- Samsung Electronics - Fall Students Job Fair 3
    (10, 3), -- Toyota Motor Corporation - Fall Students Job Fair 1
    (11, 1), -- IBM - spring Students Job Fair 1
    (11, 2); -- IBM - spring Students Job Fair 2

INSERT INTO students_events (student_id, event_id)
VALUES 
    (8, 1),    -- Sarah Martinez - spring Students Job Fair 1
    (9, 1),    -- Daniel Robinson - spring Students Job Fair 1
    (10, 1),   -- Ashley Clark - spring Students Job Fair 1
    (11, 2),   -- David Lee - spring Students Job Fair 2
    (12, 2),   -- Amanda Scott - spring Students Job Fair 2
    (13, 2),   -- James Taylor - spring Students Job Fair 2
    (14, 3),   -- Jennifer Hernandez - Fall Students Job Fair 1
    (15, 3),   -- Andrew Nguyen - Fall Students Job Fair 1
    (16, 3),   -- Nicole Lewis - Fall Students Job Fair 1
    (17, 4),   -- Justin Walker - Fall Students Job Fair 2
    (18, 4),   -- Samantha King - Fall Students Job Fair 2
    (19, 4),   -- Brandon Hall - Fall Students Job Fair 2
    (8, 5),    -- Sarah Martinez - Fall Students Job Fair 3
    (9, 5),    -- Daniel Robinson - Fall Students Job Fair 3
    (10, 5),   -- Ashley Clark - Fall Students Job Fair 3
    (11, 1),   -- David Lee - spring Students Job Fair 1 (Repeated)
    (12, 1),   -- Amanda Scott - spring Students Job Fair 1 (Repeated)
    (13, 1),   -- James Taylor - spring Students Job Fair 1 (Repeated)
    (14, 2),   -- Jennifer Hernandez - spring Students Job Fair 2
    (15, 2),   -- Andrew Nguyen - spring Students Job Fair 2
    (16, 2),   -- Nicole Lewis - spring Students Job Fair 2
    (17, 3),   -- Justin Walker - Fall Students Job Fair 1
    (18, 3),   -- Samantha King - Fall Students Job Fair 1
    (19, 3);   -- Brandon Hall - Fall Students Job Fair 1


INSERT INTO jobs (job_title, job_description, job_type, job_duration, job_hours_per_week, job_salary, job_employer_id)
VALUES 
    ('Software Developer', 'Designing and implementing software solutions for clients', 'Full-time', 'Permanent', 40, '$90,000 - $110,000', 1),
    ('Marketing Manager', 'Leading marketing campaigns and analyzing market trends', 'Full-time', 'Permanent', 40, '$80,000 - $100,000', 2),
    ('Data Scientist', 'Analyzing complex datasets and building predictive models', 'Full-time', 'Permanent', 40, '$100,000 - $120,000', 3),
    ('UI/UX Designer', 'Creating intuitive user interfaces and optimizing user experience', 'Full-time', 'Permanent', 40, '$70,000 - $90,000', 4),
    ('Administrative Assistant', 'Providing administrative support to the management team', 'Part-time', 'Ongoing', 20, '$18 - $22 per hour', 5),
    ('Product Manager', 'Overseeing product development lifecycle and market research', 'Full-time', 'Permanent', 40, '$90,000 - $110,000', 6),
    ('Copywriter', 'Writing persuasive copy for advertisements and marketing materials', 'Freelance', NULL, 15, '$30 - $60 per hour', 7),
    ('Human Resources Manager', 'Managing HR operations including recruitment and employee relations', 'Full-time', 'Permanent', 40, '$80,000 - $100,000', 8),
    ('Retail Manager', 'Managing store operations and optimizing sales strategies', 'Full-time', 'Permanent', 40, '$50,000 - $70,000', 9),
    ('Frontend Developer', 'Developing interactive web interfaces using modern frontend technologies', 'Contract', '9 months', 30, '$50 - $80 per hour', 10),
    ('Database Administrator', 'Maintaining and optimizing database systems for performance and reliability', 'Full-time', 'Permanent', 40, '$90,000 - $110,000', 1),
    ('Digital Marketing Specialist', 'Executing digital marketing campaigns across various channels', 'Full-time', 'Permanent', 40, '$70,000 - $90,000', 2),
    ('Business Analyst', 'Analyzing business processes and identifying opportunities for improvement', 'Full-time', 'Permanent', 40, '$80,000 - $100,000', 3),
    ('Content Editor', 'Editing and proofreading content for accuracy and clarity', 'Part-time', 'Ongoing', 25, '$20 - $30 per hour', 4),
    ('Financial Analyst', 'Conducting financial analysis and preparing reports for decision-making', 'Full-time', 'Permanent', 40, '$85,000 - $105,000', 5),
    ('Project Coordinator', 'Coordinating project activities and ensuring timely delivery', 'Full-time', 'Permanent', 40, '$60,000 - $80,000', 6),
    ('Social Media Manager', 'Developing social media strategies and managing online presence', 'Full-time', 'Permanent', 40, '$65,000 - $85,000', 7),
    ('Training Coordinator', 'Planning and coordinating employee training programs', 'Part-time', 'Ongoing', 20, '$25 - $35 per hour', 8),
    ('Sales Manager', 'Leading sales team and developing sales strategies', 'Full-time', 'Permanent', 40, '$90,000 - $110,000', 9),
    ('Software Tester', 'Testing software applications to ensure quality and functionality', 'Contract', '6 months', 30, '$40 - $60 per hour', 10);

INSERT INTO applications (application_job_id, application_student_id, application_employer_id, application_resume_link, application_cover_letter_link, application_status)
VALUES 
    (1, 1, 1, 'https://example.com/resume1.pdf', 'https://example.com/cover_letter1.pdf', 'Accepted'),
    (2, 2, 2, 'https://example.com/resume2.pdf', NULL, 'Pending'),
    (3, 3, 3, 'https://example.com/resume3.pdf', 'https://example.com/cover_letter3.pdf', 'Rejected'),
    (4, 4, 4, 'https://example.com/resume4.pdf', NULL, 'Accepted'),
    (5, 5, 5, 'https://example.com/resume5.pdf', NULL, 'Pending'),
    (6, 6, 6, 'https://example.com/resume6.pdf', 'https://example.com/cover_letter6.pdf', 'Pending'),
    (7, 7, 7, 'https://example.com/resume7.pdf', NULL, 'Accepted'),
    (8, 8, 8, 'https://example.com/resume8.pdf', 'https://example.com/cover_letter8.pdf', 'Pending'),
    (9, 9, 9, 'https://example.com/resume9.pdf', NULL, 'Rejected'),
    (10, 10, 10, 'https://example.com/resume10.pdf', 'https://example.com/cover_letter10.pdf', 'Pending'),
    (11, 11, 1, 'https://example.com/resume11.pdf', NULL, 'Accepted'),
    (12, 12, 2, 'https://example.com/resume12.pdf', 'https://example.com/cover_letter12.pdf', 'Pending'),
    (13, 13, 3, 'https://example.com/resume13.pdf', NULL, 'Rejected'),
    (14, 14, 4, 'https://example.com/resume14.pdf', 'https://example.com/cover_letter14.pdf', 'Accepted'),
    (15, 15, 5, 'https://example.com/resume15.pdf', NULL, 'Pending'),
    (16, 16, 6, 'https://example.com/resume16.pdf', 'https://example.com/cover_letter16.pdf', 'Pending'),
    (17, 17, 7, 'https://example.com/resume17.pdf', NULL, 'Rejected'),
    (18, 18, 8, 'https://example.com/resume18.pdf', 'https://example.com/cover_letter18.pdf', 'Pending'),
    (19, 19, 9, 'https://example.com/resume19.pdf', NULL, 'Accepted')

INSERT INTO feedbacks (feedback_rating, feedback_comments, feedback_student_id, feedback_event_id)
VALUES 
    (4, 'The event provided a great opportunity to network with employers.', 1, 1),
    (5, 'I found several promising job opportunities at the event.', 2, 2),
    (3, 'The event had a decent range of employers, but I expected more tech companies.', 3, 1),
    (4, 'The event was well-organized, and I received valuable insights into different industries.', 4, 2),
    (5, 'I secured multiple interviews thanks to the connections I made at the event.', 5, 3),
    (4, 'The event exceeded my expectations in terms of the variety of companies present.', 6, 1),
    (3, 'I wish there were more workshops or seminars alongside the event.', 7, 2),
    (4, 'The event provided valuable information about internships and career opportunities.', 8, 3),
    (5, 'Attending the event was instrumental in helping me land a job offer.', 9, 5),
    (4, 'I appreciated the diversity of exhibitors represented at the event.', 10, 2),
    (4, 'The event was informative and provided insights into industry trends.', 11, 3),
    (3, 'I expected more Fortune 500 companies to be present at the event.', 12, 4),
    (4, 'The event workshops provided valuable insights into resume writing and interview skills.', 13, 2),
    (5, 'I received valuable feedback on my portfolio from exhibitors at the event.', 14, 5),
    (4, 'The event networking sessions were well-structured and productive.', 15, 1),
    (3, 'I found the event overcrowded, making it difficult to engage with exhibitors.', 16, 4),
    (4, 'The event presentations were insightful and relevant to my career goals.', 17, 3),
    (4, 'I enjoyed the event activities and found them engaging.', 18, 5),
    (3, 'I expected more hands-on workshops at the event.', 19, 2),
    (4, 'The event panel discussions provided diverse perspectives on industry topics.', 19, 5);

--Verify
select * from students
select * from majors
select * from students_majors
select * from association_members
select * from events
select * from employers
select * from students_events
select * from employers_events
select * from industries
select * from employers_industries
select * from jobs
select * from applications
select * from feedbacks

go

drop view if exists v_applications

go

create view v_applications as 
    select j.*,
        student_firstname + ' ' + student_lastname as student_name,
        employer_company_name    
        from applications
            join jobs j on j.job_id = application_job_id
            join students on student_id = application_student_id 
            join employers on employer_id = application_employer_id
go 

drop view if exists v_feedbacks 

go

create view v_feedbacks as
    select student_firstname + ' ' + student_lastname as student_name,
        event_title, event_datetime,feedback_comments, feedback_rating
        from feedbacks
            join students on student_id = feedback_student_id
            join events on event_id = feedback_event_id