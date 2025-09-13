# JM-Animal-Feeds
JM Animal Feeds is a growing animal feed production company based in Dar es Salaam, Tanzania, with a central production facility and multiple retail outlets nationwide. The company requires a comprehensive Enterprise Resource Planning (ERP) system to streamline operations, Production Management, enhance inventory management, Point Of Sale, ensure product traceability, and provide real-time visibility across all business functions.

# JM Animal Feeds ERP System
## Complete Enterprise Resource Planning Solution

---

## Executive Summary

JM Animal Feeds is a comprehensive Enterprise Resource Planning (ERP) system designed specifically for animal feed manufacturing and distribution businesses operating in Tanzania. This fully integrated solution manages the entire business lifecycle from raw material procurement through production, inventory management, distribution, and sales to both B2B and B2C customers across multiple branch locations.

### Company Overview
- **Company Name:** JM Animal Feeds
- **Location:** Headquarters in Dar Es Salaam, Tanzania
- **Business Model:** B2B and B2C animal feed production and distribution
- **Operations:** Manufacturing plant at HQ with multiple retail branches across Tanzania
- **Core Business:** Production of animal feeds, distribution of raw materials, and retail of veterinary products

---

## System Architecture & Technical Stack

### Technology Stack
- **Backend:** PHP (Pure PHP architecture with direct file structure)
- **Database:** MySQL (Database: feedsjm)
- **Frontend:** HTML5, CSS3, JavaScript, Bootstrap (Mobile-first responsive design)
- **Server Environment:** WAMP Server
- **Additional Libraries:**
  - PHP QR Code (for QR code generation)
  - Picqer/Barcode (for barcode generation via Composer)
  - Bootstrap Framework (for UI/UX)

### Design Philosophy
- Mobile-first responsive design
- Modular architecture with separated concerns
- Direct file structure (no MVC controllers)
- Separate CSS and JavaScript files for each module
- Comprehensive commenting and documentation
- User-friendly interface optimized for both desktop and mobile devices

---

## User Roles & Access Control

### 1. **Administrator**
- **Access Level:** Full system access
- **Primary Location:** HQ and all branches
- **Responsibilities:** Complete system management, user management, financial oversight

### 2. **Branch Operator**
- **Access Level:** Branch-specific operations
- **Primary Location:** Assigned branch
- **Responsibilities:** Daily sales, customer management, local inventory

### 3. **Supervisor**
- **Access Level:** Production and order oversight
- **Primary Location:** HQ
- **Responsibilities:** Production planning, order approval, quality control

### 4. **Production Operator**
- **Access Level:** Production module only
- **Primary Location:** HQ Manufacturing Plant
- **Responsibilities:** Production execution, batch management

### 5. **Transport Officer/Driver**
- **Access Level:** Fleet and delivery management
- **Primary Location:** HQ with field operations
- **Responsibilities:** Vehicle management, delivery coordination

---

## Module Specifications

### 1. **Authentication & Security Module**

#### Features:
- Secure login system with email/password authentication
- Session management and automatic logout
- Password encryption and security protocols
- Role-based access control (RBAC)
- Activity logging for all user actions
- IP tracking and login history

#### Components:
- `login.php` - User authentication interface
- `logout.php` - Session termination
- `config.php` - System configuration and database connections
- `index.php` - Application entry point

#### Access: All users (with role-specific redirections)

---

### 2. **Dashboard Module**

#### Features:
- Role-specific dashboard views
- Real-time activity logs
- Quick access navigation to authorized modules
- Performance metrics and KPIs
- Notification center
- Recent transactions overview
- Branch-specific or system-wide view (based on role)

#### Key Metrics Displayed:
- Daily/Monthly sales figures
- Inventory alerts
- Pending orders
- Production status
- Outstanding payments
- System notifications

#### Access:
- **Administrators:** System-wide dashboard with all metrics
- **Branch Operators:** Branch-specific metrics
- **Supervisors:** Production and order metrics
- **Production Operators:** Production-specific metrics
- **Transport Officers:** Fleet and delivery metrics

---

### 3. **Inventory Management Module**

#### Features:

##### Product Categories:
1. **Raw Materials**
   - Tracked in KG or Litres
   - Special handling for "Pumba" (Sado/Debe/Gunia conversions)
   - Cost price based on purchase price
   - Automatic deduction during production

2. **Packaging Materials**
   - Bags/sacks (50kg, 25kg, 20kg, 10kg, 5kg)
   - Consumption tracking during production
   - Reorder level alerts

3. **Finished Products**
   - Our manufactured products in various package sizes
   - Serial number tracking
   - QR/Barcode integration
   - Cost calculation based on formula

4. **Third-Party Products**
   - Veterinary medicines and supplies
   - Various packaging types
   - Direct cost and selling price management

##### Core Functionalities:
- Multi-branch inventory tracking
- Real-time stock levels
- Automatic stock adjustments from sales/production
- Transfer between branches
- Stock valuation reports
- Low stock alerts
- Batch and serial number tracking
- Expiry date management
- CRUD operations for all inventory items
- Advanced filtering (by branch, category, status)

#### Access: Administrators only

---

### 4. **Formula Management Module**

#### Features:
- Recipe creation for production batches
- Raw material quantity specification
- Cost calculation per formula
- Version control for formula modifications
- Formula templates library
- Yield calculations
- Multi-product output from single formula
- Historical formula performance tracking

#### Formula Components:
- Raw material selection and quantities
- Expected output calculations
- Cost per KG/per bag analysis
- Nutritional information management
- Production notes and instructions

#### Example Formula:
```
Dog Meal Formula v1.0
- Maize Bran: 9 KG
- Cooking Oil: 5 Litres
- Shells: 20 KG
- Mifupa: 5 KG
Total Input: 39 KG
Expected Output: 38 KG (accounting for moisture loss)
```

#### Access: Administrators only

---

### 5. **Production Module**

#### Features:

##### Production Workflow:
1. **Formula Selection**
   - Browse available formulas
   - Preview ingredients and quantities
   - Check raw material availability

2. **Production Initiation**
   - Assign production operator
   - Set production batch size
   - Generate batch number

3. **Production Monitoring**
   - Start/Pause/Resume functionality
   - Real-time status updates
   - Machine failure logging
   - Power interruption handling

4. **Production Completion**
   - Select output products
   - Specify packaging sizes and quantities
   - Automatic inventory updates
   - Raw material deduction
   - Packaging material consumption

5. **Quality Control**
   - Serial number generation for each bag
   - QR code generation with:
     - Production date
     - Operator details
     - Ingredients list
     - Expiry date
     - Usage instructions
   - Barcode generation for POS scanning

##### Additional Features:
- Production cost analysis
- Efficiency tracking
- Waste management
- Batch history and traceability

#### Access: Production Operators, Supervisors, Administrators

---

### 6. **Orders Management Module**

#### Features:

##### Order Types:

1. **Branch to Customer Orders**
   - Customer details capture
   - Product selection and quantities
   - Delivery address specification
   - Driver assignment
   - Direct HQ fulfillment option

2. **Branch Stock Requests**
   - Inter-branch transfers
   - Stock replenishment requests
   - Automatic low-stock triggers

##### Order Workflow:
1. Order creation by branch operator
2. Supervisor review and approval
3. Stock verification
4. Driver assignment
5. Order processing
6. Transit tracking
7. Delivery confirmation
8. Automatic inventory adjustments

##### Order Status Tracking:
- Pending
- Approved
- Processing
- In Transit
- Delivered
- Cancelled

##### Additional Features:
- Real-time notifications
- Order history
- Delivery tracking
- Customer communication logs
- Return handling

#### Access: Branch Operators, Supervisors, Transport Officers, Administrators

---

### 7. **Point of Sale (POS) Module**

#### Features:

##### Mobile-Optimized Interface:
- Touch-friendly design
- Quick product cards
- Search functionality
- Barcode scanning support

##### Sales Management:
- Full bag sales
- Opened bag tracking via serial numbers
- KG-based sales from opened bags
- Automatic bag completion alerts
- Multi-payment method support:
  - Cash
  - Mobile Money (with reference number)
  - Bank Transfer (with reference number)

##### Customer Management:
- Quick customer search
- New customer registration
- Walk-in customer support
- Credit sales management
- Payment due date tracking

##### Pricing Features:
- Default pricing display
- Custom discount application
- Price override capabilities
- Promotional pricing support

##### Receipt Generation:
- Thermal receipt printing
- Digital receipt option
- Transaction history
- Return/refund processing

##### Inventory Integration:
- Real-time stock updates
- Serial number validation
- Opened bag tracking
- Stock alerts

#### Access: Branch Operators, Administrators

---

### 8. **Customer Management Module**

#### Features:

##### Customer Profiles:
- Personal/Business information
- Contact details
- Credit limit setting
- Purchase history
- Payment history
- Outstanding balances

##### Credit Management:
- Credit application workflow
- Credit limit monitoring
- Payment reminders
- Aging analysis
- Collection tracking

##### Customer Engagement:
- Loyalty program integration
- Promotional campaigns
- SMS/Email notifications
- Birthday/anniversary tracking
- Feedback collection

##### Payment Processing:
- Payment recording
- Partial payment handling
- Payment method tracking
- Receipt generation
- Account reconciliation

#### Access: Branch Operators, Administrators

---

### 9. **Supplier Management Module**

#### Features:

##### Supplier Profiles:
- Company information
- Contact persons
- Product catalogs
- Pricing agreements
- Payment terms

##### Purchase Management:
- Purchase order creation
- Order tracking
- Delivery confirmation
- Quality inspection records
- Return/dispute handling

##### Financial Management:
- Invoice processing
- Payment scheduling
- Outstanding balance tracking
- Payment history
- Supplier performance metrics

#### Access: Administrators only

---

### 10. **Fleet Management Module**

#### Features:

##### Vehicle Registry:
- Vehicle types (Trucks, Motorcycles, Vans, Tricycles)
- Registration details
- Insurance information
- Primary driver assignment
- Vehicle specifications

##### Operational Tracking:
- Fuel consumption records
- Maintenance schedules
- Service history
- Repair logs
- Fine/violation tracking
- Emergency incident reports

##### Driver Management:
- Driver profiles
- License tracking
- Performance metrics
- Route assignments
- Training records

##### Cost Analysis:
- Vehicle-wise expense tracking
- Fuel efficiency monitoring
- Maintenance cost analysis
- Total cost of ownership
- ROI calculations

#### Access: Branch Operators, Transport Officers, Administrators

---

### 11. **Expense Management Module**

#### Features:

##### Expense Request Workflow:
1. Employee expense request submission
2. Category selection:
   - Fuel
   - Food allowance
   - Transport allowance
   - Salaries/Wages
   - Per diem
   - Other (with description)
3. Justification/notes requirement
4. Administrator review
5. Approval/Rejection with reasons
6. Fund disbursement tracking
7. Expense recording

##### Expense Tracking:
- User-wise expense history
- Category-wise analysis
- Budget vs. actual comparison
- Approval rate metrics
- Reimbursement tracking

#### Access: All users (request), Administrators (approval)

---

### 12. **Reports Module**

#### Features:

##### Sales Reports:
- Daily/Weekly/Monthly/Yearly sales
- Product-wise performance
- Customer-wise analysis
- Branch comparison
- Sales trends and forecasts
- Top-selling products
- Sales team performance

##### Inventory Reports:
- Stock levels (branch-wise/consolidated)
- Stock movement analysis
- Aging reports
- Dead stock identification
- Reorder level reports
- Stock valuation

##### Production Reports:
- Production efficiency
- Cost per unit/batch
- Formula performance
- Operator productivity
- Waste analysis
- Quality metrics

##### Financial Reports:
- Profit & Loss statements
- Cash flow analysis
- Expense summaries
- Revenue breakdowns
- Outstanding receivables/payables
- Budget variance analysis
- ROI calculations

##### Customer Reports:
- Customer purchase patterns
- Credit aging
- Payment performance
- Loyalty program metrics
- Customer lifetime value

##### Supplier Reports:
- Purchase analysis
- Supplier performance
- Payment schedules
- Price comparison

##### Fleet Reports:
- Vehicle utilization
- Fuel consumption analysis
- Maintenance costs
- Driver performance
- Route efficiency

##### Advanced Features:
- Custom date range selection
- Multiple filter options
- Export to Excel/PDF
- Graphical representations
- Drill-down capabilities
- Scheduled report generation
- Email distribution

#### Access: Administrators only

---

### 13. **Notifications Module**

#### Features:
- Real-time notifications
- Role-based alert system
- Email/SMS integration
- Notification categories:
  - Order updates
  - Approval requests
  - Stock alerts
  - Payment reminders
  - System announcements
  - Production updates
- Notification preferences
- Read/Unread status
- Notification history
- Priority levels

#### Access: All users (personalized notifications)

---

### 14. **Settings Module**

#### Features:

##### User Settings:
- Password change
- Profile updates
- Notification preferences
- Language selection
- Theme customization

##### System Settings (Admin only):
- Company information
- Branch management
- Tax configuration
- Currency settings
- Backup configuration
- System parameters
- Integration settings

#### Access: All users (personal settings), Administrators (system settings)

---

### 15. **User & Branch Management Module**

#### Features:

##### User Management:
- User registration
- Role assignment
- Permission management
- Account activation/deactivation
- Password reset
- Activity monitoring
- Access logs

##### Branch Management:
- Branch creation
- Location mapping
- Inventory allocation
- Staff assignment
- Performance tracking
- Branch transfers

#### Access: Administrators only

---

## System Outputs & Deliverables

### 1. **Operational Outputs**
- Real-time inventory status
- Production batch records
- Sales transactions
- Order fulfillment tracking
- Customer account statements
- Supplier statements

### 2. **Financial Outputs**
- Daily cash reports
- Profit & Loss statements
- Balance sheets
- Cash flow statements
- Budget reports
- Tax reports

### 3. **Analytical Outputs**
- Sales trend analysis
- Customer behavior patterns
- Product performance metrics
- Production efficiency reports
- Inventory turnover analysis
- Fleet utilization reports

### 4. **Compliance Outputs**
- Regulatory reports
- Quality certificates
- Batch traceability reports
- Expiry tracking reports
- Audit trails

### 5. **Communication Outputs**
- Customer receipts
- Supplier purchase orders
- Delivery notes
- Payment reminders
- System notifications
- Performance reports

---

## Developer Pitch

### Project Overview

We are developing a comprehensive ERP solution for JM Animal Feeds, a growing animal feed manufacturing and distribution company in Tanzania. This system will digitize and streamline all business operations from production to point of sale, providing real-time visibility and control across multiple branches.

### Technical Implementation Strategy

#### Phase 1: Foundation (Weeks 1-2)
- Database architecture design and implementation
- User authentication and authorization system
- Core configuration files and project structure
- Basic UI/UX framework setup

#### Phase 2: Core Modules (Weeks 3-6)
- Inventory Management System
- Formula Management for production recipes
- Production Module with QR/Barcode integration
- Real-time stock tracking and updates

#### Phase 3: Operations (Weeks 7-10)
- Order Management System
- Point of Sale with mobile optimization
- Customer and Supplier Management
- Fleet Management System

#### Phase 4: Financial & Reporting (Weeks 11-13)
- Expense Management workflow
- Comprehensive Reports Module
- Financial analytics and dashboards
- Data visualization implementation

#### Phase 5: Integration & Polish (Weeks 14-15)
- Notifications system
- Settings and preferences
- System integration testing
- Performance optimization
- User training materials

### Key Technical Features

1. **Mobile-First Design:** Optimized for branch operators using mobile devices
2. **Real-Time Updates:** Instant inventory adjustments across all branches
3. **Barcode/QR Integration:** Complete product traceability from production to customer
4. **Role-Based Access:** Secure, granular permission system
5. **Offline Capability:** Critical POS functions work offline with sync
6. **Scalable Architecture:** Designed to grow with the business

### Business Value Proposition

1. **Operational Efficiency:** 60% reduction in manual processes
2. **Inventory Accuracy:** 99.9% stock accuracy with real-time tracking
3. **Financial Visibility:** Complete financial oversight with instant reports
4. **Customer Satisfaction:** Faster service, accurate billing, better tracking
5. **Cost Reduction:** 40% reduction in operational costs through automation
6. **Compliance:** Full traceability and regulatory compliance

### Development Methodology

- **Agile Approach:** Iterative development with continuous testing
- **Module-Based Development:** Complete one module before moving to next
- **User-Centric Design:** Regular user feedback and testing
- **Documentation:** Comprehensive code comments and user guides
- **Version Control:** GitHub repository for code management
- **Quality Assurance:** Unit testing for each module

### Risk Mitigation

1. **Data Security:** Encrypted passwords, secure sessions, activity logs
2. **System Reliability:** Regular backups, error handling, fallback procedures
3. **User Adoption:** Intuitive interface, comprehensive training
4. **Scalability:** Modular architecture for easy expansion
5. **Maintenance:** Clean code, documentation, standardized structure

### Project Timeline

- **Total Duration:** 15 weeks
- **Development Team:** 2-3 developers
- **Testing Phase:** Continuous with dedicated UAT
- **Training Period:** 1 week
- **Go-Live:** Phased rollout starting with HQ

### Success Metrics

1. **System Uptime:** 99.9% availability
2. **User Adoption:** 100% within 30 days
3. **Process Efficiency:** 60% time reduction
4. **Error Rate:** <0.1% in transactions
5. **ROI:** Positive within 6 months

### Conclusion

This ERP system will transform JM Animal Feeds from a traditional operation into a digitally-enabled enterprise. With comprehensive modules covering every aspect of the business, real-time data visibility, and mobile-first design, this solution will provide the foundation for sustainable growth and operational excellence.

The modular approach ensures that each component can be developed, tested, and deployed independently, reducing risk and allowing for continuous improvement. The system's scalability ensures it will grow with the business, making it a long-term investment in the company's future.

---

## Contact Information

**Project Manager:** [Your Name]  
**Technical Lead:** [Technical Lead Name]  
**Email:** [contact@email.com]  
**Phone:** [+255 XXX XXX XXX]  
**GitHub Repository:** https://github.com/AriellaRoger/JM-Animal-Feeds.git  
**Project Documentation:** https://drive.google.com/drive/folders/1KPWPcgfPO4kGefIM9wpwBDAxSMUM3vxk

---

*This document represents a comprehensive ERP solution tailored specifically for JM Animal Feeds' unique business requirements and operational environment.*

The Company is called JM Animal Feeds, in Dar Es Salaam Tanzania producing animal food and distributing to customers and other businesses and has branches/shops outlets across Tanzania. The first thing is to create a config file, login page, logout page, index.php - app entry point, includes files header and footer, assets files js and style.css and sample users with first name last name, phone number, role (Branch Operator- manage branch, Supervisor - belong to hq, Production operator- belong to hq, Transport Officer or Driver- Belong to HQ and Administrators - manage everything everywhere), email and password for logon and give each user password "jmfeeds2025" and populate with 6 branches including HQ which is default branch for administrative and production and storage. then build dashboard.php a dashboard after logon with Activity logs section which shows user's individual actions and activities though administrator activity logs will show every user activities and actions across the entire system and links to roles specified modules by access we will build those modules files later (Branch Operators-POS,Expenses, Orders, Customers, Profile, Settings and notifications), (Supervisors - orders, production, Profile, Settings and notifications), (Production operator - Production, Profile, Settings and notifications), (Transport Officer/Driver- Fleet Management module) and (Administrators - Access Everything models mentioned there plus user & Branch operator, suppliers, inventory, Formula Management, Fleet Management and reports modules which are exclusively for administrators) for now create links but odules will be built later. Use direct files a pure php/mysql no controller/model style just a simple php files security is not concern for me right now we will do that later. i have wamp server and created MySQL database named feedsjm and a folder in www called feedsjm,


Now lets build an inventory module for administrators only no one has access rather than admins, a heart beat of the system and company. first you have to know that we are a b2b and b2c company so here we manage Raw Materials, Packaging material, Products from our Plant and other products we sell from other brands. Raw materials - are used during production and we sell raw materials to other businesses who manafacture food for their own use and all raw materials we bought in KG or Litres and its the same UOM we store them and sale them in the same unit of measurement except for one raw material called Pumba, - of which when we sell we measure it in Sado/Debe/Gunia 4 Sado's make a Debe, 6 Debe's make a Gunia. And Gunia is approximately 100KG but the same product when we are in production of which we will discuss later we measure in KG. Then we have Packaging Materials normally are bags/sacks of 50kg/25KG/20KG/10KG and 5KG we use this after production to pack our Products. Then we have our main products We pack products after production in bags of 50kg/25KG/20KG/10KG and 5KG label them put serial numbers ready for market but when we sell them we sell in those full packed bags or sometimes we open the bag and start selling in KG when finished we open another bag and sell in kg. Then We have other brands products we sell in our outlets which most are vertinary medicines packed in different bottles, parket and all other types of packaging. am telling you this because our POs depends on this, our orders, production depends on this so when creating it consider all other factors. The cost Price of raw materials is determined by the purchasing price we pay same goes to packaging materials and other brands products but the cost price of our products bags of 50kg/25KG/20KG/10KG and 5KG will be determined by the actual raw materials quantity and price of which we will create in formula management module when we develop formulas for each product to be used in production batches. but wholesale selling price and retail selling price we will set because we are selling to businesses and customers. remember we sell everything from raw materials, packaging, products and other brands products. so create a comprehensive inventory for CRUD and edit and filtering important thing i forgot to mention, the default storage is HQ, and then each branch  have its own stock . now for example when i want to filter show me stock from which branch and the general stock for all branches. 

formula management for administrators only, formula is simply a batch that will be produced at a time formula consist of raw materials to be used in that batch so we simply calculate the total amount of raw materials (lets use a simple example a dog meal formula=maize bran 9kg+cooking oil 5Litres+shells 20kg+ mifupa 5kg=39kg this will deduct HQ raw materials during production and a formula can be used to create different products or packaging at the same batch so we will specify later but. the aim is to deduct inventory item during production and calculate products cost per kg or per bag). we save formulas to be used in production and we can manage formulas versions.


Production module depends on formula and inventory, This is available to production operators, supervisors and Administrators. When user Start production he must first select a formula and after selecting formula it will be previewed on windows so as to make sure he is mixing the right ammount of ingridients, then select production operator in charge,  then he start production, production can paused or halted due to power cut or machine failure then when production is completed user select final product/products to be packed and their ammount of bags then choose packaging bags for each selected product and the raw materials ammount that are specified in formula will be deducted in inventory together with packaging material, then the system must generate serials for each bag and its qrcodes and barcodes using PHP QR Code i have it on my pc already in root foldr installed in its folder phpqrcode and Picqer/Barcode installed via composer and vendor folder created. we will use to track these bags down to customer level so this qrcodes they must have production date, production operator, ingridients/rawmaterials calculated per bag, exipire date, Notes how to use the product. so this module will update inventory in HQ and raw materials in HQ

The next module is Orders, These are orders between branches and to customers, first scenario - lets say branch operator has orders to deliver 30bags of product x to customer but branch stock is low or out of product he can request the delivery from HQ to customer directly by filling order request form and specify customer name, contact and address then assign Driver/Transport Officer responsible then choose products and their respectively quantity and the order will go direct to HQ supervisor who will see the order details from products requested to transporter to customer details and if the stock balance is okay then he can proccess the order and the system must alert branch operator that the order is in proccess the after completion supervisor click order on transit then transporter/admin or branch operator after contacting customer will confirm when order is delivered. Same goes to Branch may be low or out of stock and want to request for additional Stock this time he will send order to supervisor and follow the same steps and when the order is delivered to his branch he confirm the completion order. so branch operators/drivers/supervisors has access to this module

Now The POS Module here is a simple but Mobile friendly POS a very mobile friendly since our branch operators are using mobile phones not computers. since the bags of products are sold in full and sometimes we open them and sell in kg the POS operator who is Branch operator must specify the bag he open by entering bag serials so we can count on inventory module and the remaining products are sold in its unit of measuremnt. Remember our bags ara packed and labelled its serials so the user can not open new bag until the open bag is finished from calculated kgs sold so when he want to declare open bag give warning that you have open bag unless the remaining quantity is not sufficient to fullfill customer ammount. also we sale on cash and credit, users who we sell on credit must acknowledge date of payment so we track the balances and sending payment reminders. also we have three payment methods, Cash, Mobile money (Must enter Reference number) Bank Transfer (Must Enter reference number) for reconciliation. The POS must follow best of UX/UI like search for customers or add new by adding name and phone number also allow walk in customers no details, then search for products or quick products cards so pos operator just selecting products and add them all to cart and edit quantities, also selling price may vary from declared selling price sometimes we offer discounts so operator can enter prices but for new users we can put a default price so he can preview befor initialising a sale, then system must print thermal receipts after sale completion. This Module is accessible for branch operators and administrators only.

Customer Module - Here we create each customer accounts for the purpose of tracking payments, when user pay his due ammount operatos select user and enter payment the system will deduct from his loan to show balances so each customer will have his purchases and payment history tracked also  installation payments, loyality programs and promotionals this is accessible for administrators and Branch operators this module operte in the same way as suppliers when we pay them after deliveries, so we must add suppliers modules now and purchases modules to go along with this.

Fleets Management- Here we track Our Trucks, Motorcycles, vans and Tricycles. Each Vehicle will have its account and responsible / primary driver though drivers can exchange but we must have primary drivers. all the Requests of fuel, maintanance, services, repair, Fines and emergency are recorded in its account so branch operators/transportes and Administrators have access to this.

Another is Expenses Module this is for each user, everybody can request money to spend from administrator and when admin approve he can proceed spend and recorded in database. there are several expenses types like fuel, food allownce, transport allowance, salaries, wages, per diem, or other but each expenses user must write reasons or notes so it can be easy for admin to understand and approve and when admin reject must specify reason so we keep it in db.

Another module is Reports Module. This is Administrators exclusive only. Sales Reports from summary reports to details report to graphical reports, Inventory reports from summary/branchwise/general to details reports and graphical, the Customer reports from summary to frequent customers list of credits due payments and every related reports then Production reports from cost of production per product/ per kg per bag per batch to production managr specific reports of how he perform with his team, purchasase and suppliers reports same as customers, fleet management reports from individual vehicle to overall reports, Financial Reports from Profit and loss/ expenses/ salesvsproduction sales/buying price every financial info this system must capture. Reports should have multiple filters per day/week/month/yearly/all time specific period, also user filetr reports module filtered reportd, branch filtered reports . in shoert i want the owner of the bussiness to have his full bussiness on this system. 

