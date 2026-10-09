# Requirements specification rules

This repository contains the requirements specification of WP CVE. There is no application code yet; the code-style, lint, test and dev-server rules apply once there is.

## Repository layout

| Path | Content | Maintained by |
|---|---|---|
| `features/*.feature` | Binding rules and their scenarios (Gherkin) | Hand; tags also by `/scope` |
| `spec.md` | Explanation of the app and its concepts; no binding rules | Hand |
| `glossary.md` | Definitions of all terms, acronyms and abbreviations | `/glossary` |
| `scope.md`, `images/product-scope-diagram.svg` | Product boundary and product use cases | `/scope` |
| `.claude/commands/` | `/analyze`, `/glossary`, `/scope` | Hand |

## Writing style

- **Tone.** Documents and command output are read by stakeholders and developers: formal, factual, concise, present tense, third person or passive. No contractions, conversational voice ("you", "we"), emphasis words ("simply", "just", "easily") or marketing language.
- **Sentence case.** Headings, names and labels use sentence case ("Application manager", "Check CVE feeds and notify recipients"); only the first word, names and acronyms are capitalized. Title case is not used.

## Verification

Before a change is committed:

1. All feature files parse with the Gherkin parser (`@cucumber/gherkin`), with every scenario inside a `Rule`.
2. Every scenario has exactly one `@REQ-###` and one `@PUC-n` tag, and no `@REQ` number occurs twice.
3. The `scope.md` Requirements column matches the tags for every use case.
4. Glossary entries are in alphabetical order (case-insensitive) and each has a source.

Temporary files, such as parser scripts and downloaded sources, go outside the repository.
