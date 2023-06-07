import argparse
import os
import time
import sys


# Setup

if not os.path.isdir("params"):
	os.system("mkdir params")
	# send param download into background
	os.system("wget https://storage.googleapis.com/alphafold/alphafold_params_2022-12-06.tar")
	os.system("tar -xf alphafold_params_2022-12-06.tar -C params") 
	os.system("touch params/done.txt) &")


if not os.path.isdir("colabdesign"):
	print("installing ColabDesign...")
	os.system("git clone https://github.com/sokrypton/ColabDesign.git")
	os.system("ln -s /home/mirudhum/aether/ColabDesign/colabdesign colabdesign")

# sys.path.append('/home/mirudhum/aether/colabdesign/')
os.system("export PYTHONPATH='/home/mirudhum/aether/colabdesign'")
# os.system("export PYTHONPATH='/home/mirudhum/aether/colabdesign/mpnn'")


# Initialize the argument parser
parser = argparse.ArgumentParser(description='Process input file')
parser.add_argument('-num_seqs', '--num_seqs', type=int, default=2, help='Number of sequences to predict per backbone')
parser.add_argument('-initial_guess', '--initial_guess', type=bool, default=False)
parser.add_argument('-num_recycles', '--num_recycles', type=int, default=1)
parser.add_argument('-use_multimer', '--use_multimer', type=bool, default=False)
parser.add_argument('-rm_aa', '--rm_aa', type=str, default="C")

parser.add_argument('-name', '--name', type=str, required=True)
parser.add_argument('-pdb', '--pdb', type=str, required=True)
parser.add_argument('-trb', '--trb', type=str, required=True)
parser.add_argument('-loc', '--loc', type=str, required=True)

parser.add_argument('-num_designs', '--num_designs', type=int, default=10)
parser.add_argument('-copies', '--copies', type=int, default=1)
parser.add_argument('-contig', '--contig', type=str, default='')


# Parse the arguments
args = parser.parse_args()
print("mpnn: ",args)

num_seqs = args.num_seqs
initial_guess = args.initial_guess
num_recycles = args.num_recycles
use_multimer = args.use_multimer
rm_aa = args.rm_aa

name = args.name
pdb = args.pdb
trb = args.trb
loc = args.loc

num_designs = args.num_designs
copies = args.copies
contig = args.contig


# if not os.path.isfile("params/done.txt"):
#   print("downloading AlphaFold params...")
#   while not os.path.isfile("params/done.txt"):
#     time.sleep(5)

opts = [f"--pdb={pdb}",
		f"--trb={trb}",
        f"--loc={loc}",
        f"--contigs={contig}",
        f"--copies={copies}",
        f"--num_seqs={num_seqs}",
        f"--num_recycles={num_recycles}",
        f"--rm_aa={rm_aa}",
        f"--num_designs={num_designs}"]
if initial_guess: opts.append("--initial_guess")
if use_multimer: opts.append("--use_multimer")
opts = ' '.join(opts)
print(opts)
os.system(f"python colabdesign/rf/designability_test.py {opts}")
# !python colabdesign/rf/designability_test.py {opts}







