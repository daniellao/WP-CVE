---
description: Analyze requirements for consistency issues (conflicts, duplication, dependencies, terminology, etc.) per the IREB AI4RE prompt guide.
argument-hint: [optional: file path(s) or pasted requirements text]
---

<!-- Source: https://ireb.atlassian.net/wiki/spaces/airebpromptguide/pages/2571173889/Prompt+Guide+Analyze+Requirements+Consistency -->

Input requirements: $ARGUMENTS

If no input was given above, use `README.md` and every `features/*.feature` file in this repository as the requirements to analyze. Otherwise, treat the given input as file path(s) to read, or as literal requirements text if it isn't a valid path.

You are an expert in requirements engineering and analysis, working to help create coherent and well-organized specifications.

## Task

Review the provided requirements, detect and classify relationships or issues between them, and produce output grouped by relationship type.

## Instructions

- Compare all requirements pairwise to detect relationships or issues.
- Include each pair only once.
- Classify each relationship precisely, using a category and a subtype where applicable (see categories below).
- Do not alter requirement text — quote it exactly as written.
- For each detected pair, provide a concise, actionable improvement suggestion (2–3 sentences).
- Organize results by relationship type, using bold headings and horizontal rules (`---`) between groups.
- Do not list unrelated individual requirements — only pairs with a detected relationship or issue.
- If no issues are found at all, state this explicitly rather than omitting output.

## Detection categories

1. **Conflicts** — direct contradiction, numeric/value conflicts, unit mismatches, conditional conflicts, temporal/sequence conflicts, actor/scope conflicts, priority/modality conflicts.
2. **Similarity/Duplication** — exact duplicates, near-duplicates, partial overlap, general-specific relationships.
3. **Dependencies/Preconditions** — preconditions, sequence/order, trigger/event, interface/protocol dependencies.
4. **Complementary/Elaboration relationships** — acceptance criteria elaboration, higher-level requirement detailing.
5. **Terminology Inconsistencies** — terminology mismatches, unit mismatches, actor/role mismatches, tense/modality mismatches.
6. **Version Drift** — version conflicts, outdated references.
7. **Inter-Requirement Test/Quality Misalignment** — acceptance criteria contradictions, conflicting measurable thresholds, testability clashes, verification impossibilities.
8. **Completeness & Implied Gaps** — missing companion requirements, coverage holes.
9. **Functional vs Non-Functional Misalignment** — an NFR contradicting a functional requirement.
10. Other meaningful relationships you infer that don't fit the above, labeled clearly.

## Execution steps

1. Parse the input and normalize whitespace; identify individual requirement lines/statements.
2. Identify each Gherkin scenario by its `@REQ-###` tag and note its `@PUC-n` tag (the product use case). Preserve any other existing requirement IDs. Assign temporary `TMP-###` identifiers to requirements lacking one (such as README statements and untagged scenarios); never generate `REQ-###` identifiers, which are permanent and assigned only through the scenario tags.
3. Perform pairwise comparison across all requirements, considering semantics, values, ranges, conditions, roles, versions, and units.
4. Classify each detected relationship and draft an improvement suggestion.
5. Group findings by relationship type, sort sensibly within each group, and render the final output.

## Output format

For each detected pair, within its relationship-type group:

- **Related Requirements**: IDs (with the `@PUC-n` tag of each tagged scenario) and full, exact requirement text of both requirements.
- **Type of Relationship/Issue**: category — subtype.
- **Improvement Suggestion**: 2–3 sentences of actionable guidance to resolve or clarify the issue.

Separate each group with a horizontal rule (`---`). Do not include groups with no findings.

After the groups, list under **Untagged requirements** every `TMP-###` identifier with its source file, so that scenarios can receive a permanent `@REQ-###` tag. Omit this list when every requirement is tagged.
