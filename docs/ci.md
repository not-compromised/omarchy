# Continuous integration

CI runs `test/all`, the existing CLI and shell fixture suites, inside a disposable Arch Linux container. Build and run the same environment with:

```sh
docker build -f .github/ci.Dockerfile -t omarchy-ci:fixtures .
docker run --rm --network none --cap-drop ALL --security-opt no-new-privileges omarchy-ci:fixtures
```

The image contains the test dependencies and pinned `omarchy-pkgs` and `omarchy-iso` source checkouts for packaging assertions. It runs as an unprivileged test user, with `OMARCHY_PATH` and the command path pointing only at the copied source. Tests cannot see the host desktop, system bus, Docker socket or user configuration. Arch packages follow the rolling repository; update the sibling commit pins deliberately when packaging contracts change.

The fixture runner already omits its compositor-dependent runtime portions when no Wayland session is reachable. Those omissions remain visible in its output and are not GUI acceptance. The suite also reports exclusions when unprivileged namespaces, HID devices or the en_US.UTF-8 locale are unavailable; report those alongside the file count rather than treating skipped runtime portions as tested. `test/acceptance`, a real installation/upgrade, hardware behavior and desktop screenshots still need a separate owned test system. This job validates the runnable CLI/source/fixture portions, not a complete desktop installation.

The final `CI gate` fails when the fixture job fails or skips. Configure repository protections to require it separately. The workflow does not deploy, update the user's desktop or publish images.
