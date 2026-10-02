---
description: Build or update the product scope (Scope.md and its use case diagram) from the requirements, per the Volere template's product scope section and the UML use case diagram notation.
argument-hint: [optional: file path(s) to use as the specification, or use cases to add/change]
---

<!-- Sources: https://www.volere.org/wp-content/uploads/2018/12/template13_nl.pdf, sectie 8 "De scope van het product"; https://www.omg.org/cgi-bin/doc?formal/03-03-10.pdf, topic 6 "Use Case Diagrams" -->

Input: $ARGUMENTS

Without input, the specification is `README.md` and every `features/*.feature` file, and the full product scope is built. Otherwise, the input is a file path to read as the specification or, if it is not a valid path, a description of product use cases to add or change.

The role is that of a requirements engineer defining the scope of the product.

## Sources

The rules below summarize two sources, which are the authority for content and notation. Where this command is more specific, this command applies. The sources are not part of the repository. To consult one, download the PDF to a temporary directory outside the repository and extract the text with `pdftotext -layout`.

1. **[Volere Requirements Specification Template, edition 13 (Dutch)](https://www.volere.org/wp-content/uploads/2018/12/template13_nl.pdf), sectie 8 "De scope van het product".**
   - 8a, product boundary: a use case diagram shows the boundary between the actors and the product. For each business use case, the stakeholders decide which part the product automates (or another product supports) and which part the user performs, considering the users (sectie 3), the constraints (sectie 4), the project goals (sectie 1) and the work and technology involved. Actors are outside the boundary (the rectangle), product use cases are ellipses inside it, and lines indicate usage. Actors are people or automated systems.
   - 8b, list of product use cases: the diagram summarizes the product use cases. Above 15 to 20 product use cases, a list with individual descriptions is preferred.
   - 8c, individual product use cases: the details of each listed product use case, optionally with a scenario.
2. **[OMG UML 1.5 Notation Guide](https://www.omg.org/cgi-bin/doc?formal/03-03-10.pdf), Topic 6 "Use Case Diagrams", sectie 3.54 to 3.58** (reference layout: Figure 3-52).
   - A use case is an ellipse containing its name (3.55.2).
   - An actor is a stick man figure with its name below it (3.56.2).
   - An association between an actor and a use case is a solid line (3.57.2, 3.58.2). It is the only relationship between actors and use cases; actors relate to each other only by generalization.
   - A rectangle with the system name may enclose the use cases as the system boundary (3.54.2, Figure 3-52).
   - Use case names follow the capitalization of classifiers (3.55.4), actor names that of types and classes (3.56.4). This project uses sentence case for both use case and actor names ("Check status", "Application manager"); title case is not used.

## Task

Produce `Scope.md` (the product scope) and `images/product-scope-diagram.svg` (the use case diagram it displays).

Existing files are updated in place; their current state, including manual edits, is intended. Existing identifiers (`PUC-1`, `PUC-2`, …), names and wording are kept unless wrong, outdated or unsupported by the specification. A new product use case receives the next free identifier; existing identifiers are never renumbered.

The `features/*.feature` files also receive the scenario tags (see Scenario tags); tags are the only edit made to feature files.

## Rules

- **Specification only.** Every actor, product use case, trigger, precondition and outcome is derived from the README and feature files. Behavior is not invented; gaps are reported (see Report).
- **One product use case per actor goal.** A product use case is a complete unit of functionality that delivers a result to an actor. Scenarios are grouped by goal, not by feature file, and each scenario belongs to exactly one product use case.
- **Scenario tags.** Each scenario carries two tags on the line above `Scenario`, at the same indentation: `@REQ-### @PUC-n` (for example `@REQ-009 @PUC-3`). `@REQ-###` is the permanent requirement identifier: three digits, unique across all feature files, never renumbered or reused; the number of a deleted scenario is retired. `@PUC-n` is the product use case the scenario belongs to and is the stored mapping between scenarios and product use cases. Existing tags are kept unless wrong. An untagged scenario is grouped by the rules above and receives the next free `@REQ-###` (one above the highest number in use) and its `@PUC-n`.
- **Actors.** An actor is a person or system outside the product that takes part in a product use case: a user who starts it, a system the product calls on, or time for a scheduled use case. A party reached only through another actor (for example, a recipient reached through the email service) is not an actor.
- **Formal, concise tone.** `Scope.md` is read by stakeholders and developers. Statements are formal, factual and in the present tense, in the passive or third person, with no more words than required. No contractions, filler, repetition, conversational voice ("you", "we"), emphasis words ("simply", "just", "easily"), marketing language or informal phrasing. Terms follow `Glossary.md` and the specification.
- **Content only.** No introduction, section numbers, references to the Volere template or UML, explanation of the diagram, open questions or links to individual Gherkin scenarios.

## Execution steps

1. Read the specification, `Glossary.md`, `Scope.md` and `images/product-scope-diagram.svg` (if present).
2. List the actors and the actor goal of each scenario; group the scenarios into product use cases, starting from the existing `@PUC-n` tags.
3. Determine the actors, trigger, precondition and outcome of each product use case.
4. Tag untagged scenarios and correct wrong `@PUC-n` tags; write `Scope.md` and draw `images/product-scope-diagram.svg`.
5. Verify that each scenario has exactly one `@REQ-###` and one `@PUC-n` tag, that no `@REQ-###` number occurs twice, that every `@PUC-n` exists in `Scope.md` and the "Requirements" column matches the tags, that the diagram, table and entries list the same actors and use cases, and that the diagram renders without overlapping labels.

## Output format

All headings, names and labels in `Scope.md` and the diagram are in sentence case, never title case: only the first word, names and acronyms are capitalized ("Application manager", "Email service", "CVE API").

### `Scope.md`

```
# WP CVE product scope

## Product boundary

![product-scope-diagram](images/product-scope-diagram.svg)

## Product use cases

| Use case | Name | Actors | Requirements | Feature files |
|---|---|---|---|---|
| PUC-1 | <name> | <actors> | <REQ-### identifiers> | [<file>.feature](features/<file>.feature) |

### PUC-1 <name>

- **Trigger:** <the event that starts the use case>.
- **Actors:** <actors>.
- **Precondition:** <what holds before the use case starts>.
- **Outcome:** <the result, including the rules that constrain it>.
```

- The table lists all product use cases in identifier order; "Requirements" lists, as plain text in ascending order, every `@REQ-###` identifier of the scenarios tagged with the use case, separated by commas and without ranges ("REQ-001, REQ-002, REQ-009, REQ-010"); "Feature files" links each feature file with a scenario of the use case.
- Each use case has a `###` entry with the four fields in this order; the precondition is omitted only when none applies.
- Actors in the table are in sentence case ("Application manager, email service, SMS service"); in the entries, lowercase except names and acronyms ("application manager, email service, SMS service").

### `images/product-scope-diagram.svg`

A standalone SVG in UML 1.5 notation, laid out as in Figure 3-52:

- **Canvas:** black on white, no border, no other colors.
- **System boundary:** one rectangle, 1px black stroke, no fill, enclosing all use cases, with `WP CVE` centered at the top inside it in bold.
- **Use cases:** white ellipses, 1px black stroke, stacked vertically and centered in the rectangle, each sized to fit only the use case name in bold (two lines where needed). No identifiers.
- **Actors:** stick man figures (head, body, arms, two legs), 1px black stroke, with the name in bold sentence case centered below (as in the table: "Application manager", "Email service"). Actors that start a use case are on the left; systems the product calls on are on the right. No label touches another figure.
- **Associations:** thin solid black lines between each actor and its use cases, ending a few pixels short of both symbols. No arrowheads, dashed lines or lines between actors.
- **Text:** `Helvetica, Arial, sans-serif`, bold. The `<svg>` element has a `viewBox`, `width`, `height`, `role="img"` and `aria-label="product-scope-diagram"`, and its first child is `<title>product-scope-diagram</title>`. The file name, the image title and the alt text in `Scope.md` are always `product-scope-diagram`.
- **Layout:** use cases are ordered to minimize crossing lines. The SVG is rendered (for example with `msedge --headless --screenshot`) and inspected before finishing.