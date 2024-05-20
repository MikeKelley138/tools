#!/bin/bash

vip @513.production --yes -- wp term list post_tag --fields=term_id,name,slug,count --format=json > 513.json
vip @475.production --yes -- wp term list post_tag --fields=term_id,name,slug,count --format=json > 475.json
vip @510.production --yes -- wp term list post_tag --fields=term_id,name,slug,count --format=json > 510.json
vip @519.production --yes -- wp term list post_tag --fields=term_id,name,slug,count --format=json > 519.json
vip @371.production --yes -- wp term list post_tag --fields=term_id,name,slug,count --format=json > 371.json
vip @493.production --yes -- wp term list post_tag --fields=term_id,name,slug,count --format=json > 493.json
vip @374.production --yes -- wp term list post_tag --fields=term_id,name,slug,count --format=json > 374.json
vip @516.production --yes -- wp term list post_tag --fields=term_id,name,slug,count --format=json > 516.json
vip @487.production --yes -- wp term list post_tag --fields=term_id,name,slug,count --format=json > 487.json
vip @478.production --yes -- wp term list post_tag --fields=term_id,name,slug,count --format=json > 478.json
vip @490.production --yes -- wp term list post_tag --fields=term_id,name,slug,count --format=json > 490.json
vip @507.production --yes -- wp term list post_tag --fields=term_id,name,slug,count --format=json > 507.json
