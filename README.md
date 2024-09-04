# Wec_Nemoh-speedup

## Introduction
This repository manage and automate the workflow required to generate the analysis data used by [Wec-Sim](https://github.com/WEC-Sim/WEC-Sim). The code generate as results a folder "input_data" used in Web-Sim. The data inside this folder comes from the [Nemoh](https://gitlab.com/lheea/Nemoh) software. In general the aim of this code is to initialise the repository for the new project and run automatically all the Nemoh's binaries and the required function of [meshmagick](https://github.com/LHEEA/meshmagick/tree/master) to modify the meshes.
All the program needs is the name of the repository to initialise it and the meshes.
As what I personally need is to speed-up the process to generate analysis of an Wec-RMX3 simulation (two bodies connected with a linear PTO), the first code proposed is basically for that.
