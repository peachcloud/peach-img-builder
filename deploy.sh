KEY_PATH=/home/notplants/.ssh/do_rsa

rsync -avzh --exclude target --exclude .idea --exclude .git --exclude *.img -e "ssh -i $KEY_PATH" . root@165.227.141.30:/srv/image-specs/

ssh -i $KEY_PATH root@165.227.141.30 'cd /srv/image-specs; echo "hi"'
