KEY_PATH=/Users/maxfowler/.ssh/do_rsa
rm peach.img
scp -i $KEY_PATH root@165.227.141.30:/srv/image-specs/raspi_3.img peach.img