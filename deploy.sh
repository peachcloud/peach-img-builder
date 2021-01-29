KEY_PATH=/Users/maxfowler/.ssh/do_rsa

rsync -avzh -L --exclude target \
    --exclude .idea \
    --exclude .git \
    --exclude peach.img \
    --exclude peach-simple.img \
    --exclude peach-simple.img \
    --exclude raspi_3_unmodified_homebuilt.img \
    --exclude *.img.xz \
    --exclude *.img \
    -e "ssh -i $KEY_PATH" . root@165.227.141.30:/srv/image-specs/

ssh -i $KEY_PATH root@165.227.141.30 'cd /srv/image-specs; echo "hi"'
