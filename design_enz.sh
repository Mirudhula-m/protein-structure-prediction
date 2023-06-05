#!/bin/bash
#SBATCH --job-name=enz      ## Name of the job
#SBATCH --output=logger.out    ## Output file
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mirudhum@andrew.cmu.edu

## Run on a GPU
#SBATCH --ntasks=1    

#SBATCH --partition=gpu
#SBATCH --gres=gpu:2


## Job memory request
#SBATCH --mem=60gb
## Time limit days-hrs:min:sec
#SBATCH --time 00-10:00:00

source activate SE3nv

PYTHON_PATH=$(which python)

export num_designs=10
export contig='103-103/A104-104/23-23/A128-128/142-142/A271-271/32-32'
export num_seqs=2
export name='design_enzyme'

RFdiffusion/scripts/run_inference.py inference.output_prefix=/user_data/mirudhum/aether/outputs/des3/design_enzyme \
							inference.input_pdb=/user_data/mirudhum/aether/input_pdb/enzyme_sub.pdb \
							'contigmap.contigs=['$contig']' \
							potentials.guide_scale=1 \
							'potentials.guiding_potentials=["type:substrate_contacts,s:1,r_0:8,rep_r_0:5.0,rep_s:2,rep_r_min:1"]' \
							potentials.substrate=UNL \
							inference.ckpt_override_path=./models/ActiveSite_ckpt.pt \
							inference.num_designs=$num_designs



export name='mpnn_output'
export pdb='/user_data/mirudhum/aether/outputs/des3/design_enzyme_0.pdb'
export loc='/user_data/mirudhum/aether/outputs/des3/mpnn_output'

$PYTHON_PATH run_MPNN_AF.py -name $name -pdb $pdb -loc $loc -num_designs $num_designs -contig $contig

