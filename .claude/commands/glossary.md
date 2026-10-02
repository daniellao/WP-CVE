---
description: Build or update the project glossary (Glossary.md) from the requirements, per the Volere template's naming conventions and definitions section.
argument-hint: [optional: file path(s) or terms to add/redefine]
---

<!-- Source: Volere Requirements Specification Template, edition 13, section 5 "Naming Conventions and Terminology" -->

Input: $ARGUMENTS

If no input was given above, use `README.md` and every `features/*.feature` file in this repository as the requirements specification, and build the full glossary. Otherwise, treat the input as file path(s) to read as the specification, or, if it isn't a valid path, as a list of terms to add to or redefine in the existing glossary.

You are an expert requirements engineer maintaining the glossary of a requirements specification.

## Task

Produce `Glossary.md`: a glossary containing the meanings of all names, acronyms and abbreviations used in the requirements specification. The glossary reflects the terminology currently used in the work environment and builds on the standard names used in the sector (vulnerability management, CVE, NVD, CPE, GDPR, messaging).

If `Glossary.md` already exists, update it in place. Keep existing entries and wording unless they are wrong, out of date or no longer used in the specification. The user may have edited the file by hand; treat its current state as intended.

## Rules

- **Cover every term.** Include every domain name, role, data item, acronym and abbreviation that the specification uses. Do not include general English words used in their ordinary sense.
- **Concise definitions.** Write one short definition per term. Where a term is used in a narrower sense than usual, say so explicitly (as in: "Truck: a vehicle used for spreading de-icing products on roads. Here, 'truck' is not used to refer to vehicles that transport goods.").
- **Official sources only.** For sector terms, use the definition from an official source and quote it verbatim. Do not paraphrase a quoted definition. Preferred sources, in order:
  1. The owning standard or program: CVE Program glossary (cve.org), NVD developer documentation (nvd.nist.gov), NISTIR 7695 for CPE 2.3, GDPR (EUR-Lex), IETF RFCs, ITU-T and 3GPP recommendations, wordpress.org.
  2. The NIST CSRC glossary (csrc.nist.gov/glossary), citing the underlying publication.
  Never use blogs, vendor marketing, Wikipedia or forum posts. If no official definition exists, write a project definition instead and say so.
- **Project definitions.** Terms that are specific to this project (roles, records, services, behaviors) are defined from the specification itself. Base them only on what the README and feature files actually say; do not invent behavior.
- **Acronyms.** An acronym is acceptable only when fully defined. Write the entry heading as `Acronym (Full Name)`, and expand any acronym that appears inside a definition, either with its own entry or inline.
- **No abbreviations.** Do not introduce abbreviations. Report any abbreviation found in the specification so the analysts can replace it with the correct term (see Output).
- **One name per concept.** Avoid synonyms and homonyms. If the specification uses two names for one concept, or one name for two concepts, pick the term the specification uses most, define that one, and report the conflict.
- **Choose names carefully.** Flag any name that could evoke a different, unintended meaning for a reader outside the project.
- **Neutral tone.** The glossary is read by both stakeholders and developers, so write for both. Use plain, factual, present-tense statements. Do not write marketing language, opinions, emphasis words ("simply", "just", "easily", "powerful"), humor or a conversational voice ("you", "we"). Do not assume technical knowledge in project definitions, and do not leave out technical precision either: name formats and identifiers exactly, and add a short example (for example `CVE-2024-12345`) where it makes a definition concrete. Use the same sentence structure and level of detail for all entries. This rule applies to your own wording only; quoted official definitions stay verbatim.

## Execution steps

1. Read the specification and the current `Glossary.md` (if present).
2. List every candidate term with the files it appears in.
3. For each term, decide whether it is a sector term (needs an official source) or a project term (defined from the specification).
4. Look up sector terms in the official sources above. If a site renders on the client or blocks fetching, use the source's published raw data (for example, the CVE website's `glossaryEntries.json` on GitHub) or a search restricted to the official domain. Never fill in a quote from memory; if you cannot verify the exact wording, say so in the report.
5. Write or update the entries, sorted alphabetically (case-insensitive).
6. Check the result: every acronym is expanded, every entry has a source, every link resolves to the official source, and no two entries define the same concept.

## Output format

`Glossary.md` contains a `# WP CVE Glossary` heading followed by the entries only: no introduction and no reference to the Volere template. Each entry uses this format:

```
**Term (Full Name, if an acronym)**
Definition, with official wording in "double quotes".
*Source:* [Publication or page, §section](https://official.url)
```

For project terms, the source line is:

```
*Source:* project definition ([file](path), [file](path))
```

Separate entries with one blank line.

After writing the file, report to the user (not in the file), in the same neutral tone:

- **Added, changed and removed terms**, with a one-line reason for each.
- **Abbreviations to replace** in the specification, with file and line.
- **Synonym/homonym conflicts** and **potentially misleading names**, with a suggested single term.
- **Unverified definitions** whose official wording could not be confirmed.
- A reminder that the relevant stakeholders must agree to each definition before the glossary is final.
