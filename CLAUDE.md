# WP CVE

This repository contains the requirements specification of WP CVE. There is no application code yet.

## Repository layout

| Path | Content | Maintained by |
|---|---|---|
| `features/*.feature` | Binding rules and their scenarios (Gherkin) | Hand; tags also by `/scope` |
| `README.md` | Explanation of the app and its concepts; no binding rules | Hand |
| `Glossary.md` | Definitions of all terms, acronyms and abbreviations | `/glossary` |
| `Scope.md`, `images/product-scope-diagram.svg` | Product boundary and product use cases | `/scope` |
| `.claude/commands/` | `/analyze`, `/glossary`, `/scope` | Hand |

The specification is `README.md` together with every `features/*.feature` file. The commands are the authority for the content and format of the files they produce; the rules below apply to all work in the repository.

## Specification rules

- **Rules live in feature files.** Every binding rule is a Gherkin `Rule` in a feature file. The README explains concepts only and contains no binding wording ("must", "exactly", "at least", "at most", "required").
- **No invented behavior.** Rules, scenarios, glossary entries and use cases are derived from the specification. Gaps are reported, not filled.
- **Terminology.** Terms follow `Glossary.md`. A new term receives a glossary entry through `/glossary`.

## Gherkin conventions

- **Keywords.** Documentation writes Gherkin keywords as the [Gherkin reference](https://cucumber.io/docs/gherkin/reference/#keywords) lists them, without a colon (`Feature`, `Rule`, `Background`, `Scenario`, `Given`). In feature files, `Feature`, `Rule`, `Background` and `Scenario` are followed by a colon; steps are not.
- **Structure.** Each feature file contains one `Feature` with an "As a / I want / So that" narrative, an optional `Background`, and one or more `Rule` blocks. Every scenario belongs to a `Rule`; no scenario stands outside one.
- **Rules.** A `Rule` name is one declarative statement of the rule, in the present tense. Each rule has at least one scenario that illustrates it.
- **Indentation.** Two spaces per level: `Rule` at 2, tags and `Scenario` at 4, steps at 6.
- **Steps.** `Given`, `When`, `Then` and `And`; steps by an application manager are in the first person ("I am logged in as an application manager").
- **Tags.** Each scenario carries exactly two tags on the line above `Scenario`: `@REQ-### @PUC-n` (for example `@REQ-009 @PUC-3`). No tags on features or rules.
  - `@REQ-###` is the permanent requirement identifier: three digits, unique across all feature files. A new scenario receives one above the highest number in use. Numbers are never renumbered or reused; the number of a deleted scenario is retired.
  - `@PUC-n` is the product use case in `Scope.md` that the scenario belongs to, and is the stored mapping between scenarios and use cases.

## Scope conventions

- **Product use cases.** One product use case per actor goal, identified `PUC-1`, `PUC-2`, …; identifiers are never renumbered. Each scenario belongs to exactly one product use case.
- **Actors.** People or systems outside the product that take part in a use case (application manager, time, CVE API, email service, SMS service). A party reached only through another actor, such as a recipient reached through the email service, is not an actor.
- **Requirements column.** The `Scope.md` table lists every `REQ-###` identifier of a use case, comma separated and in ascending order, without ranges.
- **Diagram.** UML 1.5 use case notation, black on white, as specified in `.claude/commands/scope.md`. After a change the SVG is rendered (for example with `msedge --headless --screenshot`) and inspected.
- **Consistency.** After a change to scenarios, tags or `Scope.md`, the tags, the table and the diagram list the same use cases and requirements.

## Writing style

- **Tone.** Documents and command output are read by stakeholders and developers: formal, factual, concise, present tense, third person or passive. No contractions, conversational voice ("you", "we"), emphasis words ("simply", "just", "easily") or marketing language.
- **Sentence case.** Headings, names and labels use sentence case ("Application manager", "Check CVE feeds and notify recipients"); only the first word, names and acronyms are capitalized. Title case is not used.

## Verification

Before a change is committed:

1. All feature files parse with the Gherkin parser (`@cucumber/gherkin`), with every scenario inside a `Rule`.
2. Every scenario has exactly one `@REQ-###` and one `@PUC-n` tag, and no `@REQ` number occurs twice.
3. The `Scope.md` Requirements column matches the tags for every use case.
4. Glossary entries are in alphabetical order (case-insensitive) and each has a source.

Temporary files, such as parser scripts and downloaded sources, go outside the repository.

## Git

- Work happens on a feature branch; `main` is the main branch.
- Commit messages are short and concise in sentence case ("Tag scenarios with stable REQ and PUC identifiers").
- Git stores LF line endings; `core.autocrlf` converts them on Windows.
