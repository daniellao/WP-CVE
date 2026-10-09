# Scope rules

- **Product use cases.** One product use case per actor goal, identified `PUC-1`, `PUC-2`, …; identifiers are never renumbered. Each scenario belongs to exactly one product use case.
- **Actors.** People or systems outside the product that take part in a use case (application manager, time, CVE API, email service, SMS service). A party reached only through another actor, such as a recipient reached through the email service, is not an actor.
- **Requirements column.** The `scope.md` table lists every `REQ-###` identifier of a use case, comma separated and in ascending order, without ranges.
- **Diagram.** UML 1.5 use case notation, black on white, as specified in `.claude/commands/scope.md`. After a change the SVG is rendered (for example with `msedge --headless --screenshot`) and inspected.
- **Consistency.** After a change to scenarios, tags or `scope.md`, the tags, the table and the diagram list the same use cases and requirements.
