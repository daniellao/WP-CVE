# WP CVE

A CVE monitoring app that sends notifications about publicly disclosed vulnerabilities in WordPress.

## The app

WP CVE notifies relevant stakeholders when vulnerabilities are discovered in WordPress. Application managers manage recipients, and recipient information is stored in a GDPR friendly way.

Dedicated email and SMS services are used to ensure timely delivery. A lightweight database keeps track of message delivery for human inspection in the form of an audit log.

The product boundary and the product use cases are described in [Scope.md](Scope.md).

## CVE API

The CVE API is used to easily retrieve information on a single CVE or a collection of CVE from the NVD. The NVD contains CVE records. Because of this, its APIs enforce offset-based pagination to answer requests for large collections. Through a series of smaller “chunked” responses controlled by an offset `startIndex` and a page limit `resultsPerPage` users may page through all the CVE in the NVD.

## CPE name

A CPE name identifies the product a CVE feed watches. A CPE Name is a string of characters comprised of 13 colon separated values that describe a product. In CPEv2.3 the first two values are always “cpe” and “2.3”. The 11 values that follow are referred to as the CPE components. When filtering by `cpeName` the part, vendor, product, and version components are required to contain values other than "*".

**Request the CVE associated a specific CPE**

`https://services.nvd.nist.gov/rest/json/cves/2.0?cpeName=cpe:2.3:o:microsoft:windows_10:1607:*:*:*:*:*:*:*`

The components of that example, in order: `cpe` and `2.3` (the fixed CPEv2.3 prefix), then part `o`, vendor `microsoft`, product `windows_10`, and version `1607` — the four that may not be "*" — followed by the remaining seven components, left as "*".

## CVE feeds

A CVE feed is a configured connection to the CVE API. Each feed holds exactly one CPE name, and that CPE name is the only place a product is configured — recipient profiles do not carry CPE names of their own. WP CVE polls each feed and pages through its results using `startIndex` and `resultsPerPage` until the whole collection has been retrieved.

Each CVE feed must be assigned at least one recipient profile and at most two.

## Recipient profiles

A recipient profile is the stored record for a single recipient — one profile per recipient, holding their phone number, email address, and which channels they are subscribed to. Assigning a profile to a CVE feed is what makes that recipient's notifications happen.

A CVE is relevant to a recipient profile when it arrives on a CVE feed that profile is assigned to. Because a feed always has at least one profile, every CVE that matches a configured feed reaches a recipient; a disclosed CVE that matches no configured feed's CPE name reaches nobody.

## Sending a test message

Once you have a recipient profile, you can send it a test message. A test message is delivered over the same email and SMS services as a vulnerability notification, and lists the CVE feeds the profile is currently assigned to. Test messages are written to the audit log and marked as tests so they are distinguishable from vulnerability notifications.




