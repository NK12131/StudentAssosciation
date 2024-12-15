## Student Association Database Management System Proposal

# Business Description

The Student Association at Syracuse University is committed to enhancing the academic and professional
development of its students. To support this mission, we aim to implement a robust and integrated
Database Management System (DBMS) specifically designed to manage internships, part-time jobs, and
co-op opportunities. This system will streamline the management of student profiles, employer
partnerships, opportunity listings, applications, event coordination, feedback collection, and association
member roles, thereby facilitating better connectivity between students and potential employers while
promoting a hands-on learning experience through various work opportunities.

# Problem Statement

The lack of a centralized system to manage the multitude of internships, part-time jobs, and co-op
opportunities presents a significant challenge to both students and employers. Students face difficulties
in finding relevant opportunities and managing applications, while employers struggle to reach qualified
candidates. Furthermore, the current manual processes for event management, feedback collection, and
association member coordination are inefficient and prone to errors.

# Proposed Solution

The implementation of a tailored DBMS will address these challenges by providing a centralized platform
for all stakeholders. It will offer students easy access to opportunities, streamline the application process,
facilitate efficient event organization, enable systematic feedback collection, and manage association
member responsibilities effectively. Employers will benefit from a streamlined process to post
opportunities and access a wider pool of qualified candidates. The system will also offer robust reporting
and analytics tools to track engagement and outcomes.

# Users

Primary users of the system will include students, employers, association members, and system
administrators. Each user group will have tailored access and functionalities to meet their specific needs
and roles within the ecosystem.

# System Components

1. Student
   
• Attributes:
Student ID (Primary key),
First Name,
Last Name,
Contact Information,
Major,
Graduation Year

2. Employer
   
• Attributes:
Employer ID (Primary key),
Company Name,
Contact Information,
Industry

3. Opportunity
   
• Attributes:
Opportunity ID (Primary key),
Title,
Description,
Type (Internship, Part-time Job, Co-op),
Duration,
Stipend/Salary


4. Application
   
• Attributes:
Application ID (Primary key),
Student ID (Foreign Key),
Opportunity ID (Foreign Key),
Resume,
Cover Letter,
Application Status (Pending, Accepted, Rejected)

5. Event
   
• Attributes:
Event ID (Primary key),
Title,
Date and Time,
Location,
Description

6. Feedback
   
• Attributes:
Feedback ID (Primary key),
Student ID (Foreign Key),
Opportunity ID (Foreign Key),
Rating,
Comments

7. Association Member
   
• Attributes:
Member ID (Primary key),
Student ID (Foreign Key),
Position,
Responsibilities

# Conclusion

The proposed Student Association DBMS is a strategic investment in the academic and professional
development of students at Syracuse University. By fostering a more connected, efficient, and supportive
environment for internships, part-time jobs, and co-ops, the system will enhance the overall student
experience and better prepare them for their future careers.
