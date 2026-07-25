# Aeon - Showcase

Aeon must carry at least 2 real showcase images before it is reported shipped or
released. This file reserves the slot and lists what is needed. Images are
supplied or approved by the user; they are not captured unsolicited.

Note: the code module is temporarily named `Khac` and is renamed to `Aeon` at
Phase 1 integration. Showcase content uses the final product name, Aeon.

## Required (at least 2)

1. Usage - Aeon parsing natural language in both launch locales in one shot:
   English (e.g. "next Friday at 5pm") and Vietnamese (e.g. "hop luc 3 gio chieu mai"),
   showing the resolved Date / DateInterval. A code + output screenshot.
2. Test suite green - a terminal showing the EN and VI oracle suites passing,
   with the final pass counts (`swift test`).

## Optional / nice to have

3. Corrections over chrono - a small table image of the cases where Aeon is more
   correct than chrono for Vietnamese (the KHAC-FIX set: nay handling, dem
   boundary, mai compounds).
4. Architecture - a diagram of the data-driven locale model (one shared engine,
   locales as vocabulary data).

## Status

- [ ] 0 / 2 required images present. Blocked on user-supplied or user-approved images.
