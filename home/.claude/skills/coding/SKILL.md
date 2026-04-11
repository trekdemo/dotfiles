---
name: coding
description: Load development workflow principles, naming conventions, function design, and TDD standards. Use when the user starts coding, implementing features, fixing bugs, refactoring, or writing tests.
---

# Coding Workflow

## Task Understanding Protocol
Before starting any task, assess your understanding level (1-5 scale):
- If understanding is less than 5/5:
  1. State your current understanding level
  2. Ask clarifying questions to reach full comprehension

## Development Principles

### Naming Conventions
- **Intention-Revealing Names**: Names should clearly express intent
- **Use Verbs for Methods**: Action words for functions that do things
- **Descriptive Over Brief**: Longer, clear names are better than short, cryptic ones
- **Avoid Mental Mapping**: Don't make readers translate names to understand purpose

### Function Design & Structure
- **Small Functions**: Functions should be very short, ideally under 10 lines
- **Single Responsibility**: Functions should do one thing, do it well, and do it only
- **Same Level of Abstraction**: All statements in a function should be at the same level of abstraction
- **Topological Order**: Code should read like a narrative, with functions calling others at the next level down
- **Pure Functions When Possible**: Prefer functions without side effects
- **Command-Query Separation**: Functions should either do something OR answer something, not both
- **Extract When Unclear**: If the "what" isn't immediately obvious, extract it into a well-named function

### Code Organization
- **Clear Abstractions**: Don't mix high-level policy with low-level implementation details
- **Consistent Patterns**: Follow established patterns within the codebase

### Development Strategy
- **Fix root causes, not symptoms** - Fix failing tests instead of deleting them
- **Prefer composition over inheritance** - Use interfaces and unions over complex class hierarchies

## Code Quality Standards
- Follow existing project conventions and patterns
- Run linting and type checking before commits
- Ensure all tests pass before committing

## Workflow Standards
- **Docs Before Code**: Update documentation (README, PROBLEM_STATEMENT, etc.) and commit before writing implementation code
- **Commit Per Step**: In multi-step plans, make a git commit after completing each step
- **Tests With Implementation**: In multi-step plans, write tests alongside the implementation within each step, not as a separate phase

## Hash Access Conventions (Ruby)
- Use `Hash#fetch` and `Hash#fetch_values` for required keys (fails fast on typos/missing data)
- Use bracket access (`h[:key]`) for optional keys

## Test-Driven Development (TDD) Standards
- **TDD**: Follow Red-Green-Refactor TDD cycle to implement code changes
- **Tests First**: Write failing tests before any implementation code
- **Avoid Mocking**: Prefer real test scenarios over mocking. Only mock as a last resort when no real input can trigger the code path, and get explicit approval first
