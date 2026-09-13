# Contributing

Thank you for contributing to this project.

Before making changes, read the documentation and check existing Issues and Pull Requests to avoid duplicating work.

## Development

Clone the repository and install the project dependencies using the tooling defined by the repository.

Use the repository-local versions of tools whenever possible.

Do not commit generated files, local configuration, credentials, or editor-specific files unless they are explicitly required by the project.

## Code style

Follow the existing code style and architecture.

For Luau code:

* Use `--!strict` where strict typing is expected.
* Follow the naming conventions already used by the project. (snake_case and PascalCase)
* Prefer explicit types and clear names over implicit behavior.
* Do not introduce global state unless the architecture explicitly requires it.
* Keep APIs consistent with existing modules.
* Avoid unrelated refactoring in feature or bug-fix pull requests.

Do not reformat unrelated files.

## Tests

Changes that affect behavior should include appropriate tests.

Before opening a pull request, run:

```text
Tests
Type checking
Linting
Build validation
```

All existing tests must pass.

When fixing a bug, add a regression test when practical.

## Commits

Keep commits focused and logically separated.

A commit should represent one coherent change.

Avoid commits that mix:

* Feature changes
* Unrelated refactoring
* Formatting changes
* Dependency updates

Use clear commit messages describing the change.

## Pull Requests

Create a pull request from a dedicated branch.

The pull request description should explain:

* What changed
* Why it changed
* How it was implemented
* How it was tested
* Any breaking changes

Use the repository's pull request template.

Keep pull requests focused. Large architectural changes should be discussed before implementation when practical.

## API changes

Changes to public APIs require additional care.

When changing an existing API:

* Explain the reason for the change
* Update affected tests
* Update documentation and examples
* Clearly identify breaking changes
* Prefer backwards-compatible changes when practical

Do not remove or rename public APIs without documenting the migration path.

## Roblox-specific changes

When changing Roblox-facing behavior, test the change in Roblox Studio.

Changes involving replication, networking, physics, character controllers, constraints, or engine APIs should be tested in an environment that reproduces the intended runtime behavior.

Do not assume Studio-only behavior is identical to a live server.

## Dependencies

New dependencies should have a clear justification.

Do not add a dependency when the required functionality can reasonably be implemented using the existing project infrastructure.

Dependency updates should be isolated from unrelated changes.

## Issues

Before opening an Issue, search existing Issues and Discussions.

Use:

* Bug Report for reproducible bugs
* Feature Request for proposed functionality
* Discussions for questions and general design discussion

Security vulnerabilities must not be reported through public Issues. Check SECURITY

## Review

Pull requests may be requested to change implementation details, tests, naming, architecture, or documentation.

Passing CI does not by itself imply that a contribution is ready to merge.

Maintainers may reject changes that conflict with the project's architecture, goals, or maintenance requirements.