##### Killing processes with grep #####
ps -ef | grep {search} | awk '{ print $2 }' | xargs kill -9

##### Compiling Vim #####
./configure --with-features=huge --enable-python3interp  # Fixed make by adding -lrt at the end of failing large gcc command

##### Remove all linux cache #####
sync; echo 3 > /proc/sys/vm/drop_caches

##### Install bat with ripgrep conflict #####
sudo apt install -o Dpkg::Options::="--force-overwrite" bat ripgrep
##### Latest bat with gruvbox available #####
https://github.com/sharkdp/bat/releases

##### Check linux distribution #####
lsb_release -a

##### Turn off git pager #####
git config --global core.pager "cat"

##### Network tui #####
nmtui
##### Connect to eduroam #####
nmcli connection add type wifi con-name "eduroam" ifname wlp59s0 ssid "eduroam" wifi-sec.key-mgmt wpa-eap 802-1x.identity "nwitten3@gatech.edu" 802-1x.password "xxx" 802-1x.system-ca-certs yes 802-1x.eap "peap" 802-1x.phase2-auth mschapv2
##### List available wifi #####
nmcli device wifi list
##### Connect to a wifi #####
nmcli device wifi connect <ssid_or_bss>
##### List previous connections #####
nmcli connection show
##### Delete a previous connection #####
nmcli connection delete <name_or_uuid>
##### Turn off wifi #####
nmcli radio wifi off
##### Edit a connection #####
nmcli connection edit <name>

##### Arduino CLI list connected boards #####
arduino-cli board list
##### Compile and upload #####
arduino-cli compile --fqbn arduino:megaavr:nona4809 --build-property compiler.cpp.extra_flags=-DHOST_BUILD=1 --output-dir BUILD -u -p/dev/ttyACM0 -v <sketch>
