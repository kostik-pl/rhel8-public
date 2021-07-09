cd /root
dnf -y install glibc
curl -LOJ https://www.dropbox.com/s/5gxb2vba3ti8v38/haspd-7.90-eter2centos.x86_64.rpm?dl=0
curl -LOJ https://www.dropbox.com/s/lrma8iqmfvz86on/haspd-modules-7.90-eter2centos.x86_64.rpm?dl=0
dnf -y localinstall haspd*

dnf -y install gcc gcc-c++ make kernel-devel jansson-devel libusb.i686 elfutils-libelf-devel
cd /usr/src
curl -LOJ https://www.dropbox.com/s/5vfu54w40iedt9o/libusb_vhci-0.8.tar.gz?dl=0
curl -LOJ https://www.dropbox.com/s/ba8h9rqcezzeyht/vhci-hcd-1.15.tar.gz?dl=0
curl -LOJ https://www.dropbox.com/s/icyfpxg1i1gmmwq/UsbHasp-master.tar.gz?dl=0
tar -xpf libusb_vhci-0.8.tar.gz
tar -xpf vhci-hcd-1.15.tar.gz
tar -xpf UsbHasp-master.tar.gz
KVER=`uname -r`

cd /usr/src/vhci-hcd-1.15
mkdir -p linux/${KVER}/drivers/usb/core
cp /usr/src/kernels/${KVER}/include/linux/usb/hcd.h linux/${KVER}/drivers/usb/core
sed -i 's/#define DEBUG/\/\/#define DEBUG/' usb-vhci-hcd.c
sed -i 's/#define DEBUG/\/\/#define DEBUG/' usb-vhci-iocifc.c
sed -i 's/VERIFY_READ, //' usb-vhci-iocifc.c
sed -i 's/VERIFY_WRITE, //' usb-vhci-iocifc.c
make KVERSION=${KVER}
make install
echo "usb_vhci_hcd" | sudo tee /etc/modules-load.d/usb_vhci.conf
modprobe usb_vhci_hcd
echo "usb_vhci_iocifc" | sudo tee -a /etc/modules-load.d/usb_vhci.conf
modprobe usb_vhci_iocifc

cd /usr/src/libusb_vhci-0.8
./configure
make -s
make install
echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/libusb_vhci.conf
ldconfig

cd /usr/src/UsbHasp-master
make -s
cp dist/Release/GNU-Linux/usbhasp /usr/local/sbin

mkdir /etc/usbhaspkey/
cd /etc/usbhaspkey/
curl -LOJ https://www.dropbox.com/s/tk9l91ryuecmsog/1C_v8_MultiKey_100_user.json?dl=0
curl -LOJ https://www.dropbox.com/s/18vc13uhl83b2ok/1C_v8_MultiKey_Server_x64.json?dl=0

curl -LJ https://www.dropbox.com/s/waf85xkbv29lr0t/usbhaspemul.service?dl=0 -o /etc/systemd/system/usbhaspemul.service
systemctl daemon-reload
