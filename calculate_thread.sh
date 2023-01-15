#!/bin/sh

# Usage: sh calculate_thread.sh

# Algorithms
# PageRank PageRankDelta Radii Components

algorithm_name="Components"

out_dir="out_"$algorithm_name
rm -rf $out_dir
mkdir $out_dir

curr_dir=$(pwd) 
dataset_dir="datasets"

# Go to ligra folder and apps
# <update according to your ligra folder>
cd ../ligra/apps

unset OPENMP
make clean && make $algorithm_name

for filename in $curr_dir/$dataset_dir/*
do
    echo "$filename"
    echo "Running with threads: 0" | tee -a $curr_dir/$out_dir/result_$(basename ${filename}).txt > /dev/null
    ./$algorithm_name -s $filename >> $curr_dir/$out_dir/result_$(basename ${filename}).txt
done

export OPENMP=1
make clean && make $algorithm_name

for filename in $curr_dir/$dataset_dir/*
do
    echo "$filename"
    thread_num=2
    for i in 0 1 2 3 4
do
    echo "Running with threads: $thread_num" | tee -a $curr_dir/$out_dir/result_$(basename ${filename}).txt > /dev/null
    export OMP_NUM_THREADS=$thread_num
    ./$algorithm_name -s $filename >> $curr_dir/$out_dir/result_$(basename ${filename}).txt
    thread_num=$((thread_num + 2))
done
done


# for filename in $dir/*
# do
#     echo "$filename"
#     python draw_graph.py $filename $quota_string
# done
