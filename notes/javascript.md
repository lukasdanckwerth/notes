# JavaScript

## Script usages

- If `async` is present: The script is downloaded in parallel to parsing the page, and executed as soon as it is available (before parsing completes)
- If `defer` is present (and not async): The script is downloaded in parallel to parsing the page, and executed after the page has finished parsing
- If neither `async` or `defer` is present: The script is downloaded and executed immediately, blocking parsing until the script is completed

## Variables

- `var` is globally or function scoped; `let` and `const` are block scoped.
- `var`can be updated and re-declared. `let` can be updated, `const` can't both.
- `var` is initialized with `undefined`, `let` and `const` are not initialized.
- `var` and `let` can be declared without being initialized, `const` must be initialized during declaration.

## [`Console`](https://developer.mozilla.org/de/docs/Web/API/Console)

### Timing

|Function|Description|
| - | - |
|`time(label)`| Starts a timer with the given label. |
|`timeLog(label)`| Logs the elapsed time for the given label. |
|`timeEnd(label)`| Stops the time with the given label. |
