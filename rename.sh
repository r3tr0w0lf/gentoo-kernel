for patch in patches/*
do
    new_name=$(echo $patch | sed 's/patch/000/2;s/_/-/g;s/\.diff/\.patch/')
    mv $patch $new_name
done