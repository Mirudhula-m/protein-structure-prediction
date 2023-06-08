#!/bin/bash
#SBATCH --job-name=des11      ## Name of the job
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

conda activate SE3nv

PYTHON_PATH=$(which python)

export num_designs=10

#######################
# ALL DESIGN CONTIGS
#######################
# des3: fixed length = same as original
# export contig='103-103/A104-104/23-23/A128-128/142-142/A271-271/32-32'

# des4: variable length
# export contig='50-100/A104-104/15-20/A128-128/130-140/A271-271/20-30'

# des 5: variable length: longer chain between the two active sites
# export contig='50-100/A104-104/20-40/A128-128/140-200/A271-271/20-30'

# des 6: fixing the area around residue 104
# export contig='75-100/A101-107/15-20/A128-128/130-140/A271-271/20-30'

# des 7: fixing the area around residue 128
# export contig='75-100/A104-104/15-20/A125-131/130-140/A271-271/20-30'

# des 8: fixing the area around residue 271
# export contig='75-100/A104-104/15-20/A128-128/130-140/A268-274/20-30'

# des 9: fixing the area around residues 104, 128 and 271 fixed
# export contig='75-100/A101-107/15-20/A125-131/130-140/A268-274/20-30'

# des 10: variable length; may be larger than original; large portions of the protein fixed
# export contig='75-100/A90-140/130-140/A200-290/10-20'

# des 11: same as des 10 but without inference.ckpt_override_path flag
export contig='75-100/A90-140/130-140/A200-290/10-20'

#######################

export num_seqs=2
export name='design_enzyme'
export out_dir_name='des11'

RFdiffusion/scripts/run_inference.py inference.output_prefix=/user_data/mirudhum/aether/outputs/$out_dir_name/design_enzyme \
							inference.input_pdb=/user_data/mirudhum/aether/input_pdb/enzyme_sub.pdb \
							'contigmap.contigs=['$contig']' \
							inference.num_designs=$num_designs \
							potentials.guide_scale=1 \
							'potentials.guiding_potentials=["type:substrate_contacts,s:1,r_0:8,rep_r_0:5.0,rep_s:2,rep_r_min:1"]' \
							potentials.substrate=UNL \
							#inference.ckpt_override_path=./RFdiffusion/models/ActiveSite_ckpt.pt 
							



export name='mpnn_output'
export pdb='/user_data/mirudhum/aether/outputs/'$out_dir_name'/design_enzyme_0.pdb'
export trb='/user_data/mirudhum/aether/outputs/'$out_dir_name
export loc='/user_data/mirudhum/aether/outputs/'$out_dir_name'/mpnn_output_nocontig'

$PYTHON_PATH run_MPNN_AF.py -name $name -pdb $pdb -trb $trb -loc $loc -num_designs $num_designs -contig $contig

$PYTHON_PATHv dl_binder_design/helper_scripts/addFIXEDlabels.py --pdbdir /user_data/mirudhum/aether/outputs/$out_dir_name --trbdir /user_data/mirudhum/aether/outputs/$out_dir_name --verbose


# dl_binder_design/include/silent_tools/silentfrompdbs /user_data/mirudhum/aether/outputs/*.pdb > /user_data/mirudhum/aether/outputs/my_designs.silent

# python dl_binder_design/helper_scripts/addFIXEDlabels.py --pdbdir /user_data/mirudhum/aether/outputs/ --trbdir /user_data/mirudhum/aether/outputs/trb_files --verbose

# dl_binder_design/mpnn_fr/dl_interface_design.py -silent /user_data/mirudhum/aether/outputs/my_designs.silent -output_intermediates -checkpoint_path dl_binder_design/mpnn_fr/ProteinMPNN/vanilla_model_weights/v_48_020.pt