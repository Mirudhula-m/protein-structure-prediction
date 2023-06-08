import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

N_designs = 12
out_dir = "/user_data/mirudhum/aether/outputs/"
csv_files = []
x_labels = []
for i in range(3,N_designs):
    print("Design =",i)
    csv_files.append(out_dir+'des'+str(i)+'/mpnn_output_nocontig/mpnn_results.csv')
    x_labels.append('Config'+str(i))

data = []
# Read and extract the 'rmsd' column data from each CSV file
for file in csv_files:
    df = pd.read_csv(file)
    rmsd_values = df['rmsd'].values
    data.append(rmsd_values)

# Create a DataFrame from the data list
df_data = pd.DataFrame(data).T
df_data.columns = x_labels
print(df_data)

# Create the boxplot using seaborn
sns.boxplot(data=df_data)

# Set the x-axis labels
plt.xticks(range(len(x_labels)), x_labels)

# Set the y-axis label
plt.ylabel('RMSD')

# Show the plot
plt.savefig(out_dir+'des_boxplot.png', dpi=300)  # Specify the desired filename and DPI value
