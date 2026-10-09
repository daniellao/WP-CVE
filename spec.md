# WP CVE

A CVE monitoring app that sends notifications about publicly disclosed vulnerabilities in WordPress.

## The app

WP CVE notifies relevant stakeholders when vulnerabilities in WordPress are publicly disclosed. Application managers manage the recipients of these notifications, and the information of recipients is stored in a GDPR friendly way.

Dedicated email and SMS services deliver the notifications. A lightweight database keeps track of message delivery for human inspection in the form of an audit log.

## CVE API

The CVE API retrieves information on a single CVE or a collection of CVE from the NVD, which contains CVE records. Large collections are returned as a series of smaller "chunked" responses, controlled by an offset `startIndex` and a page limit `resultsPerPage`. This is offset-based pagination.

## CPE name

A CPE name identifies the product a CVE feed watches. It is a string of colon separated values that describe a product. In CPE 2.3, the first two values are "cpe" and "2.3", and the values that follow are the CPE components.

**Request the CVE associated with a specific CPE**

`https://services.nvd.nist.gov/rest/json/cves/2.0?cpeName=cpe:2.3:o:microsoft:windows_10:1607:*:*:*:*:*:*:*`

The values of that example, in order: `cpe` and `2.3` (the CPE 2.3 prefix), then part `o`, vendor `microsoft`, product `windows_10` and version `1607`, followed by the remaining seven components, left as "*".

## CVE feeds

A CVE feed is a configured connection to the CVE API for one product, identified by its CPE name. WP CVE polls each CVE feed and pages through its results.

## Recipient profiles

A recipient profile is the stored record of a single recipient, with their contact details and the channels they are subscribed to. Assigning a recipient profile to a CVE feed makes the recipient receive the vulnerability notifications of that feed.

## Sending a test message

A test message is sent to a recipient profile to confirm its contact details and CVE feed assignments before a real CVE arrives.
