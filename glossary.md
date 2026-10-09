# WP CVE Glossary

**API (Application Programming Interface)**
"A system access point or library function that has a well-defined syntax and is accessible from application programs or user code to provide well-defined functionality."
*Source:* [NIST CSRC Glossary, from NISTIR 5153](https://csrc.nist.gov/glossary/term/application_programming_interface)

**Application manager**
A person who is authorized to log in to WP CVE to manage recipient profiles and CVE feeds, inspect the audit log and send test messages. A person who is not logged in as an application manager is denied these actions.
*Source:* project definition ([recipient_management.feature](features/recipient_management.feature), [cve_feeds.feature](features/cve_feeds.feature), [audit_log.feature](features/audit_log.feature), [test_message.feature](features/test_message.feature))

**Audit log**
"A chronological record of system activities, including records of system accesses and operations performed in a given period." Here, "audit log" is not used to refer to a record of all system activities: it holds only delivery records, which application managers inspect to check whether vulnerability notifications and test messages reached their recipients.
*Source:* [NIST CSRC Glossary, from CNSSI 4009-2022 (as used in NIST SP 800-53 Rev. 5)](https://csrc.nist.gov/glossary/term/audit_log); project definition ([spec.md](spec.md), [audit_log.feature](features/audit_log.feature))

**Channel**
A way of delivering a message to a recipient. WP CVE has two channels: email and SMS. A recipient profile records which channels its recipient is subscribed to.
*Source:* project definition ([spec.md](spec.md), [delivery.feature](features/delivery.feature), [recipient_management.feature](features/recipient_management.feature))

**CPE (Common Platform Enumeration)**
"A SCAP specification that provides a standard naming convention for operating systems, hardware, and applications for the purpose of providing consistent, easily parsed names that can be shared by multiple parties and solutions to refer to the same specific platform type." SCAP stands for Security Content Automation Protocol.
*Source:* [NIST CSRC Glossary, from NIST SP 800-128](https://csrc.nist.gov/glossary/term/common_platform_enumeration)

**CPE 2.3**
Version 2.3 of CPE, defined in National Institute of Standards and Technology Interagency Report (NISTIR) 7695, *Common Platform Enumeration: Naming Specification Version 2.3*. Every CPE name in WP CVE uses this version.
*Source:* [NISTIR 7695](https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7695.pdf)

**CPE component**
One of the 11 values in a CPE name that follow the `cpe:2.3` prefix: "The 11 values that follow are referred to as the CPE components." In order, they are part, vendor, product, version, update, edition, language, sw_edition, target_sw, target_hw and other. The CPE 2.3 specification calls these values "attributes".
*Source:* [NVD Developers – Vulnerabilities API](https://nvd.nist.gov/developers/vulnerabilities); [NISTIR 7695, §5.2](https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7695.pdf)

**CPE name**
"A CPE Name is a string of characters comprised of 13 colon separated values that describe a product." The first two values are always `cpe` and `2.3`. Example: `cpe:2.3:a:wordpress:wordpress:6.4.2:*:*:*:*:*:*:*`. In WP CVE, each CVE feed holds exactly one CPE name, and the part, vendor, product and version components must not be the wildcard `*`.
*Source:* [NVD Developers – Vulnerabilities API](https://nvd.nist.gov/developers/vulnerabilities); project definition ([cve_feeds.feature](features/cve_feeds.feature))

**CPE part**
"The part attribute SHALL have one of these three string values: The value "a", when the WFN is for a class of applications. The value "o", when the WFN is for a class of operating systems. The value "h", when the WFN is for a class of hardware devices." WFN stands for well-formed CPE name. Example: `a` for WordPress.
*Source:* [NISTIR 7695, §5.3.3.1](https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7695.pdf)

**CPE product**
"Values for this attribute SHOULD describe or identify the most common and recognizable title or name of the product." Example: `wordpress`.
*Source:* [NISTIR 7695, §5.3.3.3](https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7695.pdf)

**CPE vendor**
"Values for this attribute SHOULD describe or identify the person or organization that manufactured or created the product." Example: `wordpress`.
*Source:* [NISTIR 7695, §5.3.3.2](https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7695.pdf)

**CPE version**
"Values for this attribute SHOULD be vendor-specific alphanumeric strings characterizing the particular release version of the product." Example: `6.4.2`.
*Source:* [NISTIR 7695, §5.3.3.4](https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7695.pdf)

**cpeName**
The CVE API request parameter that holds a CPE name: "This parameter returns all CVE associated with a specific CPE."
*Source:* [NVD Developers – Vulnerabilities API](https://nvd.nist.gov/developers/vulnerabilities)

**CVE (Common Vulnerabilities and Exposures)**
"The CVE trademark and the name Common Vulnerabilities and Exposures." Here, "a CVE" is not used to refer to the trademark or the program: it means one CVE Record, that is, one publicly disclosed vulnerability and its data as returned by the CVE API. The plural is also written "CVE".
*Source:* [CVE Program Glossary](https://www.cve.org/ResourcesSupport/Glossary?activeTerm=glossaryCVE); project definition ([spec.md](spec.md))

**CVE API**
The NVD web service that WP CVE queries for CVE: "The CVE API is used to easily retrieve information on a single CVE or a collection of CVE from the NVD." Base URL (Uniform Resource Locator): `https://services.nvd.nist.gov/rest/json/cves/2.0`. Here, "CVE API" is not used to refer to the services of the CVE Program at cve.org.
*Source:* [NVD Developers – Vulnerabilities API](https://nvd.nist.gov/developers/vulnerabilities)

**CVE feed**
A configured connection to the CVE API. A CVE feed holds exactly one CPE name, which is the only place a product is configured, and has at least one and at most two recipient profiles assigned to it. WP CVE polls each CVE feed and pages through all results. Here, "CVE feed" is not used to refer to the data feeds published by the NVD.
*Source:* project definition ([cve_feeds.feature](features/cve_feeds.feature))

**CVE ID (CVE Identifier)**
"An alphanumeric string that identifies a Publicly Disclosed vulnerability. The format of the CVE ID is defined in the CVE Record Format." Example: `CVE-2024-12345`.
*Source:* [CVE Program Glossary](https://www.cve.org/ResourcesSupport/Glossary?activeTerm=glossaryCVEID)

**CVE Record**
"Structured data about a Vulnerability associated with a CVE ID. CVE Records are authored by CNAs [CVE Numbering Authorities]." A CVE Record is in one of three states: Reserved, Published or Rejected.
*Source:* [CVE Program Glossary](https://www.cve.org/ResourcesSupport/Glossary?activeTerm=glossaryRecord)

**Delivery record**
An entry in the audit log for one attempt to deliver a vulnerability notification or test message to a recipient profile over one channel. It shows the delivery status and, for a test message, is marked as a test.
*Source:* project definition ([audit_log.feature](features/audit_log.feature), [delivery.feature](features/delivery.feature), [test_message.feature](features/test_message.feature))

**Delivery status**
The outcome shown in a delivery record: successful or failed.
*Source:* project definition ([audit_log.feature](features/audit_log.feature))

**Duplicate notification**
A second vulnerability notification about the same CVE to the same recipient profiles of the same CVE feed. WP CVE does not send duplicate notifications.
*Source:* project definition ([cve_notifications.feature](features/cve_notifications.feature))

**Email address**
"An addr-spec is a specific Internet identifier that contains a locally interpreted string followed by the at-sign character ("@", ASCII value 64) followed by an Internet domain." ASCII stands for American Standard Code for Information Interchange. Example: `name@example.com`.
*Source:* [RFC 5322, §3.4.1](https://www.rfc-editor.org/rfc/rfc5322.html)

**Email service**
The external, dedicated service that WP CVE uses to deliver email messages.
*Source:* project definition ([spec.md](spec.md), [delivery.feature](features/delivery.feature))

**GDPR (General Data Protection Regulation)**
Regulation (EU) 2016/679 of the European Parliament and of the Council of 27 April 2016 on the protection of natural persons with regard to the processing of personal data and on the free movement of such data. WP CVE stores and removes recipient information in line with this regulation.
*Source:* [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng); project definition ([recipient_management.feature](features/recipient_management.feature))

**NVD (National Vulnerability Database)**
"The U.S. government repository of standards based vulnerability management data represented using the Security Content Automation Protocol (SCAP). This data informs automation of vulnerability management, security measurement, and compliance."
*Source:* [NIST CSRC Glossary, from NISTIR 7511 Rev. 4](https://csrc.nist.gov/glossary/term/national_vulnerability_database)

**Offset-based pagination**
The method the CVE API uses to return large collections in parts: "Through a series of smaller “chunked” responses controlled by an offset startIndex and a page limit resultsPerPage users may page through all the CVE in the NVD."
*Source:* [NVD Developers – Vulnerabilities API](https://nvd.nist.gov/developers/vulnerabilities)

**Phone number**
The telephone number stored in a recipient profile, to which the SMS service delivers SMS messages.
*Source:* project definition ([delivery.feature](features/delivery.feature), [recipient_management.feature](features/recipient_management.feature))

**Poll / re-poll**
To request all CVE for a CVE feed's CPE name from the CVE API, using offset-based pagination until every result has been retrieved. A re-poll is a later poll of the same CVE feed.
*Source:* project definition ([cve_feeds.feature](features/cve_feeds.feature), [cve_notifications.feature](features/cve_notifications.feature))

**Publicly disclosed**
"The state in which non-trivial information about a vulnerability is publicly available."
*Source:* [CVE Program Glossary](https://www.cve.org/ResourcesSupport/Glossary?activeTerm=glossaryPubliclyDisclosed)

**PUC (Product use case)**
The identifier prefix of a product use case: a complete unit of functionality that delivers a result to an actor. Each scenario carries the identifier of its product use case as a `@PUC-n` tag. Example: `PUC-3`.
*Source:* project definition ([scope.md](scope.md), [cve_feeds.feature](features/cve_feeds.feature))

**Recipient**
A person who receives vulnerability notifications and test messages from WP CVE.
*Source:* project definition ([spec.md](spec.md), [delivery.feature](features/delivery.feature))

**Recipient profile**
The stored record for one recipient, holding their phone number, email address and subscribed channels, and no CPE name. Each recipient has one recipient profile.
*Source:* project definition ([spec.md](spec.md), [recipient_management.feature](features/recipient_management.feature))

**REQ (Requirement)**
The identifier prefix of a requirement. Each scenario carries a permanent three-digit identifier as a `@REQ-###` tag, which is never renumbered or reused. Example: `REQ-009`.
*Source:* project definition ([cve_feeds.feature](features/cve_feeds.feature))

**resultsPerPage**
The CVE API request parameter that sets the page size: "This parameter specifies the maximum number of CVE records to be returned in a single API response."
*Source:* [NVD Developers – Vulnerabilities API](https://nvd.nist.gov/developers/vulnerabilities)

**SMS (Short Message Service)**
"A cellular network facility that allows users to send and receive text messages of up to 160 alphanumeric characters on their handset."
*Source:* [NIST CSRC Glossary, from NIST SP 800-101 Rev. 1](https://csrc.nist.gov/glossary/term/short_message_service)

**SMS service**
The external, dedicated service that WP CVE uses to deliver SMS messages.
*Source:* project definition ([spec.md](spec.md), [delivery.feature](features/delivery.feature))

**Stakeholder**
"Individual or organization having a right, share, claim, or interest in a system or in its possession of characteristics that meet their needs and expectations." Here, "stakeholder" is not used to refer to recipients.
*Source:* [NIST CSRC Glossary, from NIST SP 800-160v1r1 / ISO/IEC/IEEE 15288:2015](https://csrc.nist.gov/glossary/term/stakeholder)

**startIndex**
The CVE API request parameter that sets the offset: "This parameter specifies the index of the first CVE to be returned in the response data. The index is zero-based, meaning the first CVE is at index zero."
*Source:* [NVD Developers – Vulnerabilities API](https://nvd.nist.gov/developers/vulnerabilities)

**Test message**
A message that an application manager sends to a recipient profile to confirm its contact details and CVE feed assignments. It lists the CVE feeds the recipient profile is assigned to and is recorded in the audit log marked as a test.
*Source:* project definition ([spec.md](spec.md), [test_message.feature](features/test_message.feature))

**Vulnerability**
"An instance of one or more weaknesses in a Product that can be exploited, causing a negative impact to confidentiality, integrity, or availability; a set of conditions or behaviors that allows the violation of an explicit or implicit security policy."
*Source:* [CVE Program Glossary](https://www.cve.org/ResourcesSupport/Glossary?activeTerm=glossaryVulnerability)

**Vulnerability notification**
A message about a CVE, sent to every recipient profile assigned to a CVE feed when a poll of that CVE feed finds a CVE that has not been reported to those recipient profiles before. It is delivered over each channel the recipient profile is subscribed to and recorded in the audit log.
*Source:* project definition ([cve_notifications.feature](features/cve_notifications.feature), [delivery.feature](features/delivery.feature))

**Wildcard (`*`)**
In a CPE name: "When used alone, the asterisk ("*") represents the logical value ANY." "The logical value ANY SHOULD be assigned to an attribute when there are no restrictions on acceptable values for that attribute."
*Source:* [NISTIR 7695, §5.3.1 and §6.2](https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7695.pdf)

**WordPress**
"WordPress is open source software." It is the product whose publicly disclosed vulnerabilities WP CVE reports.
*Source:* [WordPress.org – About](https://wordpress.org/about/); project definition ([spec.md](spec.md))

**WP CVE (WordPress CVE)**
The application described in this specification. It polls the CVE API and sends vulnerability notifications about publicly disclosed vulnerabilities in WordPress.
*Source:* project definition ([spec.md](spec.md))
