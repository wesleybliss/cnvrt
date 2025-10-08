# Task

Spot is a minimal dependency injection (DI) framework implemented in Dart.
Actually, it's more of a service locator pattern than a full DI framework.
While it serves basic DI needs, there are several areas where it could be improved
to enhance usability, performance, and maintainability.

The goal of this task is to implement the suggestions below to make Spot a more robust,
but maintain it's lightweight nature and simplicity.

The long term goal will be to break Spot out into its own package, so it can be reused
across multiple projects. But first, we want to ensure it's solid and production-ready
by using it within this project.

Implement the suggestions below as you see fit, one at a time, and stop to ask before starting the next.
Keep a running list of changes made and why, so we can document them later.
Keep the checklist below up to date as you progress.
Each suggestion should be done in it's own git branch, with a descriptive commit message.

# Checklist

## Critical Improvements
- [x] Make singleton initialization thread-safe using `synchronized` locks
- [x] Add circular dependency detection with resolution stack tracking
- [x] Add custom `SpotException` for clearer and consistent error handling

## Usability Enhancements
- [x] Improve error messages to include registered types and registration hints
- [x] Add `printRegistry()` and `isRegistered<T>()` utilities for inspection/debugging
- [x] Support asynchronous initialization via `SpotAsyncGetter` and `spotAsync<T>()`
- [x] Enforce type-safe registration using `R extends T` constraint

## Advanced Features
- [x] Add lifecycle hooks with a `Disposable` interface for resource cleanup
- [ ] Support named instances / qualifiers (e.g. `Spot.spot<HttpClient>(name: 'public')`)
- [ ] Implement scoped containers (child scopes for tests or feature modules)

## Testing Support
- [x] Add `SpotTestHelper` with:
    - [x] `saveState()` and `restoreState()` for isolated DI state
    - [x] `registerMock<T>()` for mock injection
    - [x] `runIsolated()` helper for temporary test scopes
    - [x] `resetDI()` and `getRegistrationInfo<T>()` utilities

## Performance Optimizations
- [x] Cache singleton instances for faster lookup (`_singletonCache`)
- [x] Optimize registry lookups and clear cache on disposal

## Documentation & DX
- [ ] Add full dartdoc documentation with usage examples
- [ ] Provide IntelliSense-friendly comments for all public APIs

---

# Suggestions

## Overview

The Spot DI framework is a lightweight, minimal service locator implementation that
serves the app well for basic dependency injection needs. However, there are several
areas where improvements could enhance performance, type safety, developer experience,
and maintainability. The suggestions below are organized by priority and category.

## Suggestions by Category

1. Critical Improvements: [critical-improvements.md](./01-critical-improvements.md)
2. Usability Enhancements: [usability-enhancements.md](./02-usability-enhancements.md)
3. Advanced Features: [advanced-features.md](./03-advanced-features.md)
4. Testing Support: [testing-support.md](./04-testing-support.md)
5. Performance Optimizations: [performance-optimizations.md](./05-performance-optimizations.md)
6. Documentation and Developer Experience: [06-docs-and-dx.md](./06-docs-and-dx.md)

---

## Summary

The Spot DI framework is elegant and minimal, which is valuable. The suggested improvements fall into three tiers:

**Must-Have (Production Safety):**
1. Thread-safe singleton initialization
2. Circular dependency detection
3. Better error messages

**Should-Have (Developer Experience):**
4. Type-safe registration (`R extends T`)
5. Async initialization support
6. Enhanced test utilities
7. Disposable lifecycle hooks

**Nice-to-Have (Advanced Use Cases):**
8. Named instances/qualifiers
9. Scoped containers
10. Performance optimizations
11. Comprehensive documentation

Implementing even just the "Must-Have" improvements would significantly increase the robustness and maintainability of the Spot framework while preserving its lightweight philosophy.
