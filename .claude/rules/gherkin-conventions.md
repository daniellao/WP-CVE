# Gherkin conventions

The specification is `spec.md` together with every `features/*.feature` file. The commands are the authority for the content and format of the files they produce; the rules below apply to all work in the repository.

- **Rules live in feature files.** Every binding rule is a Gherkin `Rule` in a feature file. `spec.md` explains concepts only and contains no binding wording ("must", "exactly", "at least", "at most", "required").
- **No invented behavior.** Rules, scenarios, glossary entries and use cases are derived from the specification. Gaps are reported, not filled.
- **Terminology.** Terms follow `glossary.md`. A new term receives a glossary entry through `/glossary`.
- **Keywords.** Documentation writes Gherkin keywords as the [Gherkin reference](https://cucumber.io/docs/gherkin/reference/#keywords) lists them, without a colon (`Feature`, `Rule`, `Background`, `Scenario`, `Given`). In feature files, `Feature`, `Rule`, `Background` and `Scenario` are followed by a colon; steps are not.
- **Structure.** Each feature file contains one `Feature` with an "As a / I want / So that" narrative, an optional `Background`, and one or more `Rule` blocks. Every scenario belongs to a `Rule`; no scenario stands outside one.
- **Rules.** A `Rule` name is one declarative statement of the rule, in the present tense. Each rule has at least one scenario that illustrates it.
- **Indentation.** Two spaces per level: `Rule` at 2, tags and `Scenario` at 4, steps at 6.
- **Steps.** `Given`, `When`, `Then` and `And`; steps by an application manager are in the first person ("I am logged in as an application manager").
- **Tags.** Each scenario carries exactly two tags on the line above `Scenario`: `@REQ-### @PUC-n` (for example `@REQ-009 @PUC-3`). No tags on features or rules.
  - `@REQ-###` is the permanent requirement identifier: three digits, unique across all feature files. A new scenario receives one above the highest number in use. Numbers are never renumbered or reused; the number of a deleted scenario is retired.
  - `@PUC-n` is the product use case in `scope.md` that the scenario belongs to, and is the stored mapping between scenarios and use cases.
