# yieldfsm-icfp2022

[YieldFSM](https://github.com/tilk/yieldfsm) is a proof of concept DSL for [Clash](https://clash-lang.org/) designed for specifying (Mealy)
finite state machines using imperative, procedural code.
This repository is a supplement to the ICFP 2022 paper "Generating Circuits with Generators".
It contains various examples present in the paper.

## Structure

* The module `FSM.ICFP2022.Examples` contains examples from the paper.
  There are comments present which link the examples to appropriate sections or figures in the paper.

* The module `FSM.ICFP2022.Updn` contains the top-level definitions for the up-down counter example from Section 5.4, which allow synthesizing the example.

* The `synth` directory contains scripts needed to generate the data in Table 2.

## Generating data in Table 2

First, the package needs to be built using `stack` (use `stack build`).

Then, run `make` in the `synth` directory to synthesize the `Updn` example.
This step requires `yosys` and `nextpnr-ice40`.

Then run `extract_perf.pl` (requires Perl) to extract performance numbers (number of used LCs and maximum frequency Fmax) to JSON files `lc.json` and `fmax.json`.

Please note that the exact results might slightly differ depending on the versions of `yosys` and `nextpnr-ice40` used.
The figure in the paper was generated using packages from Debian 11 "Bullseye".
