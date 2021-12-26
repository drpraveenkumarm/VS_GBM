#!/bin/bash
#This script will run a virtual screen with iDock
mkdir -p Results
cd ./Ligands
for f in ligand*.pdbqt; do grep -n "Name" $f > $f.txt; done
for f in ligand*.txt; do sed -i 1i"$f" $f; done
for f in ligand*.txt; do paste -s $f >> ZINC_IDs.txt; done
for f in ligand*.txt; do rm $f; done
mv ZINC_IDs.txt ../Results/
cd ../
./idock --config idock.conf
cd Results/
awk '{print $1" "$5}' ZINC_IDs.txt | column -t >> id.txt
awk -F "\"*,\"*" '{print $1,$3}' log.csv > energy.txt
sed -i '1d' energy.txt
awk '$1=$1".pdbqt"' energy.txt > energy2.txt
sort -n -k1 energy2.txt > energy_sort.txt
sort -n -k1 id.txt > id_sort.txt
paste energy_sort.txt id_sort.txt > final.txt
sort -n -k2 final.txt | column -t > Summary_Final.txt
cp Summary_Final.txt ../
rm energy*.txt id*.txt final*.txt
for f in *.pdbqt; do cut -c-66 $f > $f.pdb; done
for f in *.pdb; do mv "$f" "${f%.pdbqt.pdb}_OUTPUT.pdb"; done
for f in ligand*.pdbqt; do rm $f; done
#results