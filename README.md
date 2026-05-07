# MUST Hostel Room Booking System
### Malawi University of Science and Technology

---

## 📋 Overview
A web-based hostel room allocation and booking system for MUST students, built with PHP, MySQL, HTML, CSS, and JavaScript.

---

## ⚙️ System Requirements
- PHP 7.4+ (with mysqli)
- MySQL 5.7+ or MariaDB 10+
- Apache / XAMPP / WAMP
- A web server (Apache recommended)
- Optional: PHP mail() configured for email sending

## 📊 Capacity & Fees

- **Total Student Applications:** atleast 100
- **Available Hostel Spaces:** atleast 90 but less that number of student applications 
- **Accommodation Fee:** MWK 80,000 per student

---

## 🚀 Installation Steps

### 1. Copy Project
Place the `NEWROOM` folder inside your web root:
- XAMPP: `C:/xampp/htdocs/NEWROOM`
- WAMP: `C:/wamp64/www/NEWROOM`
- Linux: `/var/www/html/NEWROOM`

### 2. Create the Database
- Open phpMyAdmin → Create database: `must_hostel`
- Import the file: `database.sql`

### 3. Configure the System
Edit `includes/config.php`:
```php
define('DB_HOST', 'localhost');
define('DB_USER', 'root');       // your DB username
define('DB_PASS', '');           // your DB password
define('DB_NAME', 'must_hostel');
define('SITE_URL', 'http://localhost/NEWROOM');
```

### 4. Set Folder Permissions
Make the uploads folder writable:
```bash
chmod 755 uploads/payslips/
```

### 5. Access the System
Open: `http://localhost/NEWROOM`

---

## 🔐 Default Login Credentials

| Role     | Username   | Password   |
|----------|------------|------------|
| Admin    | ADMIN001   | password   |
| Operator | OPR001     | password   |

**Students** must register at: `http://localhost/NEWROOM/register.php`

> **Note:** Students don't select a role. After registration and payment verification, they access the student dashboard automatically.

---

## 👥 User Roles

### 🔑 Admin
- Full system access
- Run batch random allocation
- Manually allocate specific rooms
- View all students and their rooms
- See paid / unpaid reports
- View and print receipts
- Handle inquiries
- Export full PDF report

### 👨‍💼 Operator
- Issue and view invoices
- Verify/reject payment uploads
- Generate and print receipts
- Handle student inquiries
- View students list

### 🎓 Student
- Register with registration number
- Apply for hostel room (with special needs option)
- **Receive invoice for MWK 80,000**
- Upload payment proof (bank transfer, mobile money, or cash)
- Get payment verified by operator
- Receive receipt and confirmation
- Check room allocation status
- View allocation details and instructions

---

## 🏨 Allocation Rules

| Year         | Location                              |
|--------------|---------------------------------------|
| Year 1       | Extension Blocks A–K (Male), L–N (Female) |
| Year 2 & 3   | Halls 1–4 (Male), 5–7 (Female) — 1st Floor |
| Year 4 & 5   | Hall 8 (Senior Male), 5–7 (Female) — 2nd Floor |

- **Total Capacity:** 500 students
- **Allocation:** Random (RAND() in MySQL)
- Students exceeding capacity are notified of rejection by email
- Admin can manually override allocations (e.g. for wheelchair users → ground floor)

---

## � Student Payment & Allocation Workflow

### Step-by-Step Process

1. **Register:** Student creates account with registration number
2. **Apply:** Submit application for hostel room
   - Auto-generated invoice for **MWK 80,000** is created
3. **Payment:** Upload payment proof
   - Supported methods: Bank transfer, Mobile money (Airtel/TNM), Cash
   - Proof: Screenshot, bank slip, or transaction confirmation
4. **Verification:** Operator verifies payment
   - Payment status: Pending → Verified
   - Receipt generated automatically
5. **Allocation:** Run batch allocation to assign rooms
   - 90 available spaces for 100 students
   - Failed applicants notified by email
   - Allocated students receive room details
6. **Access:** Student can view room assignment and payment receipt

---
Emails are generated for:
1. Invoice on application submission
2. Allocation success / rejection notification
3. Receipt after payment verification
4. Response to inquiry

Email format: `regnumber@must.ac.mw`

> **Note:** For local development, configure PHP `mail()` or use SMTP via PHPMailer for real sending.

---

## 📁 Project Structure
```
NEWROOM/
├── index.php              # Login page
├── register.php           # Student registration
├── logout.php
├── database.sql           # Database schema + seed data
├── includes/
│   ├── config.php         # DB + helpers
│   ├── email.php          # Email templates
│   ├── pdf.php            # Invoice/Receipt HTML generators
│   ├── allocation.php     # Allocation engine
│   ├── header.php         # Layout header + sidebar
│   └── footer.php         # Layout footer
├── admin/
│   ├── dashboard.php
│   ├── applications.php
│   ├── allocations.php
│   ├── manual_allocate.php
│   ├── run_allocation.php
│   ├── students.php
│   ├── payments.php
│   ├── invoices.php
│   ├── receipts.php (uses operator/)
│   ├── inquiries.php
│   ├── reports.php
│   ├── rooms.php
│   ├── export_report.php
│   ├── view_application.php
│   ├── view_invoice.php
│   └── view_receipt.php
├── operator/
│   ├── dashboard.php
│   ├── invoices.php
│   ├── view_invoice.php
│   ├── payments.php
│   ├── receipts.php
│   ├── inquiries.php
│   └── students.php
├── student/
│   ├── dashboard.php
│   ├── apply.php
│   ├── status.php
│   ├── invoice.php
│   ├── payment.php
│   ├── receipt.php
│   └── inquiry.php
├── assets/
│   ├── css/style.css
│   └── js/main.js
└── uploads/
    └── payslips/
```

---

## 🎓 Academic Note
This system was built as a university assignment demonstrating:
- **Role-based access control**
- **CRUD operations** (Create, Read, Update, Delete) on all entities
- **Random allocation algorithm** with business rules
- **Email notifications** (invoice, receipt, allocation, rejection)
- **PDF report generation** (printable via browser)
- **File uploads** (payment slips)
- **Responsive design** with modern UI

Built with: HTML5, CSS3, JavaScript, PHP 7+, MySQL
