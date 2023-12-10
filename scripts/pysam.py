import pysam
import matplotlib.pyplot as plt

def count_primary_alignments(sam_file):
    primary_alignments = 0

    with pysam.AlignmentFile(sam_file, "r") as sam:
        for read in sam:
            if not read.is_secondary and not read.is_supplementary:
                primary_alignments += 1

    return primary_alignments

def save_alignment_plot(sam_file, output_file):
    alignment_counts = []
    with pysam.AlignmentFile(sam_file, "r") as sam:
        for i, read in enumerate(sam):
            alignment_counts.append(count_primary_alignments(sam_file))
            if i >= 1000:
                break

    plt.plot(alignment_counts)
    plt.xlabel('Read index')
    plt.ylabel('Number of primary alignments')
    plt.title('Primary Alignments per Read')
    plt.savefig(output_file)
    plt.show()

# Usage example
sam_file = "/lustre/groups/hpc/urban_lab/projects/amit/metagang/indexer/barcode20_porechop_nanofilt-nt.k28.w19.sam"
output_file = "~/temp/plot.png"
save_alignment_plot(sam_file, output_file)

