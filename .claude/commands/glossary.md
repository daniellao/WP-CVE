---
description: Build or update the project glossary (Glossary.md) from the requirements, per the Volere template's naming conventions and definitions section.
argument-hint: [optional: file path(s) or terms to add/redefine]
---

<!-- Source: https://www.volere.org/wp-content/uploads/2018/12/template13_nl.pdf, sectie 5 "Naamgevingsconventies en definities" -->

Input: $ARGUMENTS

Without input, the specification is `README.md` and every `features/*.feature` file, and the full glossary is built. Otherwise, the input is a file path to read as the specification or, if it is not a valid path, a list of terms to add or redefine.

The role is that of a requirements engineer maintaining the glossary of a requirements specification.

## Task

Produce `Glossary.md`: the meanings of all names, acronyms and abbreviations in the specification, reflecting the terminology of the work environment and the standard names of the sector (vulnerability management, CVE, NVD, CPE, GDPR, messaging).

An existing `Glossary.md` is updated in place; its current state, including manual edits, is intended. Existing entries and wording are kept unless wrong, outdated or no longer used.

## Rules

- **Cover every term.** Every domain name, role, data item, acronym and abbreviation in the specification has an entry. General English words in their ordinary sense do not.
- **Concise definitions.** One short definition per term. A term used in a narrower sense than usual states so (as in: "Truck: a vehicle used for spreading de-icing products on roads. Here, 'truck' is not used to refer to vehicles that transport goods.").
- **Official sources only.** Sector terms use the verbatim definition of an official source, never a paraphrase. Sources, in order of preference:
  1. The owning standard or program: CVE Program glossary (cve.org), NVD developer documentation (nvd.nist.gov), NISTIR 7695 for CPE 2.3, GDPR (EUR-Lex), IETF RFCs, ITU-T and 3GPP recommendations, wordpress.org.
  2. The NIST CSRC glossary (csrc.nist.gov/glossary), citing the underlying publication.
  Blogs, vendor marketing, Wikipedia and forums are excluded. Without an official definition, a project definition is written and marked as such.
- **Project definitions.** Project-specific terms (roles, records, services, behaviors) are defined only from what the README and feature files state. Behavior is not invented.
- **Acronyms.** An acronym is defined in full, with the heading `Acronym (Full Name)`. An acronym inside a definition is expanded inline or has its own entry.
- **No abbreviations.** No abbreviations are introduced. Abbreviations in the specification are reported for replacement (see Output).
- **One name per concept.** No synonyms or homonyms. Where the specification uses two names for one concept or one name for two concepts, the most used term is defined and the conflict reported.
- **Choose names carefully.** Names that may suggest an unintended meaning to readers outside the project are flagged.
- **Formal, concise tone.** The glossary is read by stakeholders and developers. Statements are formal, factual and in the present tense, in the third person, with no more words than a definition requires. No contractions, filler, marketing language, opinions, emphasis words ("simply", "just", "easily", "powerful"), humor or conversational voice ("you", "we"). Project definitions assume no technical knowledge but keep technical precision: exact formats and identifiers, with a short example (for example `CVE-2024-12345`) where it clarifies. All entries share one sentence structure and level of detail. Quoted official definitions stay verbatim.

## Execution steps

1. Read the specification and `Glossary.md` (if present).
2. List each candidate term with the files it appears in.
3. Classify each term as a sector term (official source) or a project term (specification).
4. Look up sector terms in the official sources. Where a site renders on the client or blocks fetching, use its published raw data (for example, the CVE website's `glossaryEntries.json` on GitHub) or a search restricted to the official domain. Quotes are never written from memory; unverified wording is reported.
5. Write or update the entries, sorted alphabetically (case-insensitive).
6. Verify that every acronym is expanded, every entry has a source, every link resolves to the official source, and no two entries define the same concept.

## Output format

`Glossary.md` contains the heading `# WP CVE Glossary` followed by the entries only: no introduction and no reference to the Volere template. Entry format:

```
**Term (Full Name, if an acronym)**
Definition, with official wording in "double quotes".
*Source:* [Publication or page, §section](https://official.url)
```

Source line for project terms:

```
*Source:* project definition ([file](path), [file](path))
```

Entries are separated by one blank line.

### Examples

The Volere template gives two examples: a term used in a narrower sense than usual, and an acronym defined in full.

> **Truck:** a vehicle used for spreading de-icing products on roads. Here, "truck" is not used to refer to vehicles that transport goods.
>
> **BIS:** Business Intelligence Service. The department led by Steven Peters that provides business intelligence to the rest of the organization.
