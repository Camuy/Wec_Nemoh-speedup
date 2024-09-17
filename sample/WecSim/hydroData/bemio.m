hydro = struct();

hydro = readNEMOH(hydro, "/Users/riccardo/Documents/Cartella/Progetti/Origami/v0.3/WecSim/input_data");
hydro = radiationIRF(hydro,60,[],[],[],[]);
hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,157,[],[],[],[]);
writeBEMIOH5(hydro)
plotBEMIO(hydro)