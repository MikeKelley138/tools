#!/bin/bash

#get all the post ids for the posts tagged espanol into page<number>.txt files 100 at at time
seq 1 118 | xargs -I{} sh -c "vip @5867.production --yes -- wp post list --tag=espanol --posts_per_page=1000 --field=ID --paged={} >> spanish-article-ids/page{}.txt"




