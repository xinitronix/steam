#!/bin/sh

MASTER_SITES=

UBUNTU_VERSION=18.10




if ! [ -d  "ubuntu"  ]; then

           mkdir -p  ubuntu

       fi


if ! [ -d  "deb"  ]; then

           mkdir -p  deb

       fi

if ! [ -d  "tar"  ]; then

           mkdir -p  tar

       fi


                for BIN_DISTFILES in $(cat listpackages_$UBUNTU_VERSION);do

                        if ! [ -f deb/$(echo  $BIN_DISTFILES | rev | sed -r 's/\/.+//' | rev) ]; then
         
                       cd  deb &&   fetch $MASTER_SITES$BIN_DISTFILES
                       cd ../
 
                        fi 
                 done

                for DEB   in $(cat listpackages_$UBUNTU_VERSION); do
                   
                    deb2targz deb/$(echo  $DEB | rev | sed -r 's/\/.+//' | rev)

                 done


             for TARGZ in $(ls deb | grep tar.xz);do 
              
              #for TARGZ in $(cat listpackages_$UBUNTU_VERSION);do  

                    tar xf deb/$TARGZ  -C  ubuntu 
                  # tar xf deb/$(echo  $TARGZ  | rev | sed -r 's/\/.+//' | rev | sed s/.deb/.tar.*/) -C  ubuntu 

                 done


rm  -R         ubuntu/boot ubuntu/dev ubuntu/etc/fonts ubuntu/home   ubuntu/root ubuntu/tmp \
               ubuntu/var/log  ubuntu/var/tmp 

 

mkdir -p                                   ubuntu/var/run/shm
   


   #  if ! [ -f "tar/libflashsupport.so" ];then 


   #  cd tar && fetch ftp://ftp.tw.freebsd.org/pub/FreeBSD/FreeBSD/distfiles/flashplugin/9.0r48/libflashsupport.so && cd ../

   
   #  fi

 
cp       tar/libflashsupport.so            ubuntu/usr/lib
ln -s    libudev.so.1.3.5                  ubuntu/lib/i386-linux-gnu/libudev.so.0
ln -s    libcurl.so.4.3.0                  ubuntu/usr/lib/i386-linux-gnu/libcurl.so.5 
ln -s    bash                              ubuntu/bin/sh


  if ! [ -z "$(dmesg | grep radeon)" ] ; then 

        echo 'RADEON'

   
              if ! [ -f "tar/linux-c6-dri-11.0.7.txz" ]; then 

                      cd tar &&  fetch   http://pkg.freebsd.org/freebsd:11:x86:64/latest/All/linux-c6-dri-11.0.7_3.txz && cd ../

               fi

                if ! [ -f "tar/mesa-private-llvm-3.6.2-1.el6.i686.rpm" ]; then 

                     cd tar && fetch ftp://195.220.108.108/linux/centos/6.8/os/i386/Packages/mesa-private-llvm-3.6.2-1.el6.i686.rpm
                     cd ..
                  fi

              cd tar &&  rpm2cpio.pl   mesa-private-llvm-3.6.2-1.el6.i686.rpm | cpio -idmv 
          cd ..
          cp tar/usr/lib/libLLVM-3.6-mesa.so               ubuntu/usr/lib


                 tar xf tar/linux-c6-dri-11.0.7_3.txz   -C    tar  
                 cp -R tar/compat/linux/usr/lib             ubuntu/usr
                 ln -s libGL.so.1.2.0                       ubuntu/usr/lib/libGL.so.1
                 ln -s libtxc_dxtn_s2tc.so.0                ubuntu/usr/lib/i386-linux-gnu/libtxc_dxtn.so 

        else

                 cp /compat/linux/usr/lib/$(ls /compat/linux/usr/lib/ | grep libGL.so | head -3 | tail -n 1) ubuntu/usr/lib
                 cp /compat/linux/usr/lib/$(ls /compat/linux/usr/lib/ | grep libnvidia-glcore) ubuntu/usr/lib
                 cp /compat/linux/usr/lib/$(ls /compat/linux/usr/lib/ | grep libnvidia-tls) ubuntu/usr/lib
                 cp /compat/linux/usr/lib/$(ls /compat/linux/usr/lib/ | grep libGLX) ubuntu/usr/lib
                 ln -s  $(ls /compat/linux/usr/lib/ | grep libGL.so | head -3 | tail -n 1)              ubuntu/usr/lib/libGL.so.1

   fi 
 

      if ! [ -f "tar/linux-skype_oss_wrapper-0.1.1.txz" ]; then 

         cd tar && fetch  http://195.208.113.158/FreeBSD/PKG/freebsd%3A10%3Ax86%3A32/release_3/All/linux-skype_oss_wrapper-0.1.1.txz && cd ../

        fi

         tar xf tar/linux-skype_oss_wrapper-0.1.1.txz  -C ubuntu/usr/lib    -s ",/.*/,,g" "*/libpulse.so.0"





doas chroot ubuntu /usr/lib/i386-linux-gnu/gdk-pixbuf-2.0/gdk-pixbuf-query-loaders \
 >  ubuntu/usr/lib/i386-linux-gnu/gdk-pixbuf-2.0/2.10.0/loaders.cache

du -a ubuntu/usr/share/ca-certificates | sed 's/ubuntu\/usr\/share\/ca-certificates\///' |  awk '{print $2}' \
 >>  ubuntu/etc/ca-certificates.conf

doas sysctl compat.linux.osrelease=3.6.38

doas cp -R  ubuntu /compat
doas chroot /compat/ubuntu locale-gen en_US.UTF-8
doas chroot /compat/ubuntu locale-gen ru_RU.UTF-8
doas chroot /compat/ubuntu /bin/dbus-uuidgen --ensure


doas mkdir  /compat/ubuntu/tmp
doas mkdir  /compat/ubuntu/proc
doas mkdir  /compat/ubuntu/sys
doas chroot /compat/ubuntu update-ca-certificates
doas chroot /compat/ubuntu update-ca-certificates


