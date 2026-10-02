# WP CVE Glossary

**API (Application Programming Interface)**
"A system access point or library function that has a well-defined syntax and is accessible from application programs or user code to provide well-defined functionality."
*Source:* [NIST CSRC Glossary, citing NISTIR 5153](https://csrc.nist.gov/glossary/term/application_programming_interface)

**Application manager**
A person who is authorised to log in to WP CVE to manage recipient profiles and CVE feeds, inspect the audit log and send test messages. Anyone who is not logged in as an application manager is denied these actions.
*Source:* project definition ([recipient_management.feature](features/recipient_management.feature), [cve_feeds.feature](features/cve_feeds.feature))

**Audit log**
"A chronological record of system activities, including records of system accesses and operations performed in a given period."
*Source:* [NIST CSRC Glossary, from CNSSI 4009-2022 (as used in NIST SP 800-53 Rev. 5)](https://csrc.nist.gov/glossary/term/audit_log)

**Channel**
A way of delivering a message to a recipient. WP CVE has two channels: **email** and **SMS**. A recipient profile records which channels its recipient is subscribed to.
*Source:* project definition ([README](README.md))

**CPE (Common Platform Enumeration)**
"A SCAP specification that provides a standard naming convention for operating systems, hardware, and applications for the purpose of providing consistent, easily parsed names that can be shared by multiple parties and solutions to refer to the same specific platform type."
*Source:* [NIST CSRC Glossary, from NIST SP 800-128](https://csrc.nist.gov/glossary/term/common_platform_enumeration)

**CPE component**
One of the 11 attributes of a CPE name: part, vendor, product, version, update, edition, language, sw_edition, target_sw, target_hw and other. The CPE specification calls these "attributes". The README calls them "components". If an attribute is not used, its value "SHALL default to the logical value ANY".
*Source:* [NISTIR 7695, CPE Naming Specification 2.3, §5.2](https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7695.pdf)

**CPE name**
A string that identifies a product, written in the CPE 2.3 *formatted string binding*: "a colon-delimited list of fields prefixed with the string "cpe:2.3:"" in which "all eleven (11) attribute values MUST appear". The underlying abstract form is the *well-formed CPE name (WFN)*.
*Source:* [NISTIR 7695, §6.2](https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7695.pdf)

**CPE part**
"The part attribute SHALL have one of these three string values: The value "a", when the WFN is for a class of applications. The value "o", when the WFN is for a class of operating systems. The value "h", when the WFN is for a class of hardware devices."
*Source:* [NISTIR 7695, §5.3.3.1](https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7695.pdf)

**CPE product**
"Values for this attribute SHOULD describe or identify the most common and recognizable title or name of the product."
*Source:* [NISTIR 7695, §5.3.3.3](https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7695.pdf)

**CPE vendor**
"Values for this attribute SHOULD describe or identify the person or organization that manufactured or created the product."
*Source:* [NISTIR 7695, §5.3.3.2](https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7695.pdf)

**CPE version**
"Values for this attribute SHOULD be vendor-specific alphanumeric strings characterizing the particular release version of the product."
*Source:* [NISTIR 7695, §5.3.3.4](https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7695.pdf)

**CVE (Common Vulnerabilities and Exposures)**
"The CVE trademark and the name Common Vulnerabilities and Exposures." CVE is the public catalogue of known security vulnerabilities, in which each vulnerability has a unique ID such as `CVE-2024-12345`. In this project, "a CVE" (plural "CVE") means one entry in that catalogue: a single publicly disclosed vulnerability and its data, retrieved through the CVE API. Officially, such an entry is a **CVE Record**.
*Source:* [CVE Program Glossary](https://www.cve.org/ResourcesSupport/Glossary?activeTerm=glossaryCVE)

**CVE API**
The NVD's REST API for vulnerability information. In the README's words, it is used "to easily retrieve information on a single CVE or a collection of CVE from the NVD". Base URL: `https://services.nvd.nist.gov/rest/json/cves/2.0`.
*Source:* [NVD Developers – Vulnerabilities API](https://nvd.nist.gov/developers/vulnerabilities)

**CVE feed**
A configured connection to the CVE API. It holds exactly one CPE name and has at least one and at most two recipient profiles assigned to it. WP CVE polls each CVE feed and pages through the results.
*Source:* project definition ([README](README.md), [cve_feeds.feature](features/cve_feeds.feature))

**CVE ID (CVE Identifier)**
"An alphanumeric string that identifies a Publicly Disclosed vulnerability. The format of the CVE ID is defined in the CVE Record Format."
*Source:* [CVE Program Glossary](https://www.cve.org/ResourcesSupport/Glossary?activeTerm=glossaryCVEID)

**CVE Record**
"Structured data about a Vulnerability associated with a CVE ID. CVE Records are authored by CNAs." A record is in one of three states: *Reserved*, *Published* or *Rejected*.
*Source:* [CVE Program Glossary](https://www.cve.org/ResourcesSupport/Glossary?activeTerm=glossaryRecord)

**Delivery record**
One entry in the audit log describing a single attempt to deliver a vulnerability notification or test message to a recipient profile over one channel. It shows whether delivery was successful or failed, and it is marked when the message was a test message.
*Source:* project definition ([audit_log.feature](features/audit_log.feature), [delivery.feature](features/delivery.feature), [test_message.feature](features/test_message.feature))

**Delivery status**
The outcome recorded in a delivery record: **successful** or **failed**.
*Source:* project definition ([audit_log.feature](features/audit_log.feature))

**Duplicate notification**
A second vulnerability notification about the same CVE (same CVE ID) to the same recipient profiles of the same CVE feed. WP CVE must not send one.
*Source:* project definition ([cve_notifications.feature](features/cve_notifications.feature))

**Email address**
"An addr-spec is a specific Internet identifier that contains a locally interpreted string followed by the at-sign character ("@", ASCII value 64) followed by an Internet domain."
*Source:* [RFC 5322, §3.4.1](https://www.rfc-editor.org/rfc/rfc5322.html)

**Email service**
The external, dedicated service WP CVE uses to submit emails for delivery.

**GDPR (General Data Protection Regulation)**
Regulation (EU) 2016/679 of the European Parliament and of the Council of 27 April 2016 on the protection of natural persons with regard to the processing of personal data and on the free movement of such data.
*Source:* [EUR-Lex](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng)

**NVD (National Vulnerability Database)**
"The U.S. government repository of standards based vulnerability management data represented using the Security Content Automation Protocol (SCAP). This data informs automation of vulnerability management, security measurement, and compliance."
*Source:* [NIST CSRC Glossary, from NISTIR 7511 Rev. 4](https://csrc.nist.gov/glossary/term/national_vulnerability_database)

**Offset-based pagination**
Retrieving a large collection as a series of smaller responses. Each request names a starting offset (`startIndex`) and a page size (`resultsPerPage`).
*Source:* [NVD Developers – Vulnerabilities API](https://nvd.nist.gov/developers/vulnerabilities); [README](README.md)

**Personal data**
"Any information relating to an identified or identifiable natural person ('data subject'); an identifiable natural person is one who can be identified, directly or indirectly, in particular by reference to an identifier such as a name, an identification number, location data, an online identifier…"
*Source:* [GDPR, Article 4(1)](https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng)

**Phone number**
A telephone number structured according to ITU-T Recommendation E.164, *The international public telecommunication numbering plan*.
*Source:* [ITU-T E.164](https://www.itu.int/rec/T-REC-E.164)

**Poll / re-poll**
To query the CVE API for a CVE feed's CPE name, paging through every result. "Re-poll" means a later poll of the same CVE feed.
*Source:* project definition ([cve_feeds.feature](features/cve_feeds.feature), [cve_notifications.feature](features/cve_notifications.feature))

**Publicly disclosed**
"The state in which non-trivial information about a vulnerability is publicly available."
*Source:* [CVE Program Glossary](https://www.cve.org/ResourcesSupport/Glossary?activeTerm=glossaryPubliclyDisclosed)

**Recipient**
A person who receives vulnerability notifications and test messages from WP CVE.
*Source:* project definition ([README](README.md))

**Recipient profile**
The stored record for a single recipient, one per recipient. It holds their phone number, email address and the channels they are subscribed to. A recipient receives notifications only when their profile is assigned to a CVE feed. A profile cannot be removed while it is the only profile assigned to a CVE feed.
*Source:* project definition ([README](README.md), [recipient_management.feature](features/recipient_management.feature))

**SMS service**
The external, dedicated service WP CVE uses to send SMS messages.
*Source:* project definition ([README](README.md))

**Stakeholder**
"Individual or organization having a right, share, claim, or interest in a system or in its possession of characteristics that meet their needs and expectations."
*Source:* [NIST CSRC Glossary, from NIST SP 800-160v1r1 / ISO/IEC/IEEE 15288:2015](https://csrc.nist.gov/glossary/term/stakeholder)

**Test message**
A message an application manager sends to a recipient profile to check its contact details and feed assignments. It is delivered over the same email and SMS services as a vulnerability notification, lists the CVE feeds the profile is currently assigned to, and is written to the audit log marked as a test.
*Source:* project definition ([test_message.feature](features/test_message.feature))

**Vulnerability**
"An instance of one or more weaknesses in a Product that can be exploited, causing a negative impact to confidentiality, integrity, or availability; a set of conditions or behaviors that allows the violation of an explicit or implicit security policy."
*Source:* [CVE Program Glossary](https://www.cve.org/ResourcesSupport/Glossary?activeTerm=glossaryVulnerability)

**Vulnerability notification**
A message sent to every recipient profile assigned to a CVE feed when a poll of that feed finds a CVE that has not been reported to them before. It is delivered over each channel the profile is subscribed to and recorded in the audit log.
*Source:* project definition ([cve_notifications.feature](features/cve_notifications.feature), [delivery.feature](features/delivery.feature))

**Wildcard (`*`)**
In the CPE formatted string binding, "when used alone, the asterisk ("*") represents the logical value ANY". ANY "SHOULD be assigned to an attribute when there are no restrictions on acceptable values for that attribute".
*Source:* [NISTIR 7695, §5.3.1 and §6.2](https://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir7695.pdf)

**WordPress**
Open source publishing software, "built on PHP and MariaDB, and licensed under the GPLv2".
*Source:* [WordPress.org – About](https://wordpress.org/about/)
