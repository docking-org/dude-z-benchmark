
# Tools for the DUDE-Z benchmark dataset

This repository contains the scripts needed to obtain the DUDE-Z benchmark dataset and use it to evaluate the performance of drug discovery algorithms.

## Requirements

- [pydock3>=0.1.0rc](https://github.com/docking-org/pydock3)

## Installation

To install the requirements, you can use `pip`:

```bash
pip install 'pydock3>=0.1.0rc'
```

## Usage: DockOpt

To run `dockopt` on the DUDE-Z benchmark, first clone this repository and download the dataset:

```bash
git clone https://github.com/docking-org/dude-z-benchmark
cd dude-z-benchmark/
bash make_dataset.sh
````

To run a single target (e.g., AMPC), specify its name as an argument:

```bash
bash benchmark_dockopt.sh AMPC
```

To run on all DUDE-Z targets, run with no arguments:

```bash
bash benchmark_dockopt.sh
```
