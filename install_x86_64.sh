#!/bin/sh

MASTER_SITES=http://de.archive.ubuntu.com/ubuntu/
RPM_SITES=http://mirror.centos.org/centos/6.8/os/x86_64/Packages/
UBUNTU_VERSION=14.04
ubuntu=ubuntu_x86_64
tar=tar_x86_64
deb=deb_x86_64

if ! [ -d  "$ubuntu"  ]; then

           mkdir -p  $ubuntu

       fi


if ! [ -d  "$deb"  ]; then

           mkdir -p  $deb

       fi

if ! [ -d  "$tar"  ]; then

           mkdir -p  $tar

       fi

            for RPM_DISTFILES in $(cat rpmlist);do

                        if ! [ -f $tar/$(echo  $RPM_DISTFILES | rev | sed -r 's/\/.+//' | rev) ]; then
         
                       cd  $tar &&   fetch $RPM_SITES$RPM_DISTFILES
                       cd ../
 
                        fi 
                 done


            for RPM   in $(cat rpmlist); do
                  
             cd  $tar && rpm2cpio.pl   $(echo  $RPM | rev | sed -r 's/\/.+//' | rev) | cpio -idmv
             cd ../

                 done





                for BIN_DISTFILES in $(cat listpackages_$UBUNTU_VERSION"_x86_64");do

                        if ! [ -f $deb/$(echo  $BIN_DISTFILES | rev | sed -r 's/\/.+//' | rev) ]; then
         
                                 cd  $deb &&   fetch $MASTER_SITES$BIN_DISTFILES
                                 cd ../
 
                        fi 
                 done

   
                for DEB   in $(cat listpackages_$UBUNTU_VERSION"_x86_64"); do
                   
                    deb2targz $deb/$(echo  $DEB | rev | sed -r 's/\/.+//' | rev)

                 done


                for TARGZ in $(cat listpackages_$UBUNTU_VERSION"_x86_64");do  

                    tar xf $deb/$(echo  $TARGZ  | rev | sed -r 's/\/.+//' | rev | sed s/.deb/.tar.*/) -C  $ubuntu 

                 done


rm  -R         $ubuntu/boot $ubuntu/dev $ubuntu/etc/fonts $ubuntu/home   $ubuntu/root ubuntu/tmp \
               $ubuntu/var/log  $ubuntu/var/tmp 

 

mkdir -p                                   $ubuntu/var/run/shm
   


     if ! [ -f "$tar/libflashsupport.so" ];then 

      cd $tar && fetch ftp://ftp.tw.freebsd.org/pub/FreeBSD/FreeBSD/distfiles/flashplugin/9.0r31/libflashsupport.so && cd ../
   
      fi

 
cp       $tar/libflashsupport.so            $ubuntu/usr/lib
ln -s    libudev.so.1.3.5                  $ubuntu/lib/i386-linux-gnu/libudev.so.0
ln -s    libcurl.so.4.3.0                  $ubuntu/usr/lib/i386-linux-gnu/libcurl.so.5 
ln -s    bash                              $ubuntu/bin/sh
rm                                $ubuntu/lib/ld-linux.so.2
ln -s         ../lib32/ld-2.19.so $ubuntu/lib/ld-linux.so.2
rm                                $ubuntu/lib64/ld-linux-x86-64.so.2
ln -s         ../lib/x86_64-linux-gnu/ld-2.19.so   $ubuntu/lib64/ld-linux-x86-64.so.2




  if ! [ -z "$(dmesg | grep radeon)" ] ; then 

        echo 'RADEON'

   
              if ! [ -f "$tar/linux-c6-dri-11.0.7.txz" ]; then 

                      cd $tar &&  fetch   http://pkg.freebsd.org/freebsd:11:x86:64/latest/All/linux-c6-dri-11.0.7_3.txz && cd ../

               fi

                if ! [ -f "$tar/mesa-private-llvm-3.6.2-1.el6.i686.rpm" ]; then 

                     cd $tar && fetch ftp://195.220.108.108/linux/centos/6.8/os/i386/Packages/mesa-private-llvm-3.6.2-1.el6.i686.rpm
                     cd ..
                  fi

              cd $tar &&  rpm2cpio.pl   mesa-private-llvm-3.6.2-1.el6.i686.rpm | cpio -idmv 
          cd ..
          cp $tar/usr/lib/libLLVM-3.6-mesa.so               $ubuntu/usr/lib32


                 tar xf $tar/linux-c6-dri-11.0.7.txz   -C    $tar  
                 cp -R  $tar/compat/linux/usr/lib            $ubuntu/usr
                 ln -s  libtxc_dxtn_s2tc.so.0                $ubuntu/usr/lib/i386-linux-gnu/libtxc_dxtn.so 
                 ln -s  libtxc_dxtn_s2tc.so.0.0.0            $ubuntu/usr/lib/x86_64-linux-gnu/libtxc_dxtn.so


                 cp    -rf $tar/usr/lib64/*                  $ubuntu/usr/lib/x86_64-linux-gnu
                 ln -s lib/x86_64-linux-gnu                  $ubuntu/usr/lib64






        else

                 cp /compat/linux/usr/lib/$(ls /compat/linux/usr/lib/ | grep libGL.so | head -3 | tail -n 1) $ubuntu/usr/lib
                 cp /compat/linux/usr/lib/$(ls /compat/linux/usr/lib/ | grep libnvidia-glcore) $ubuntu/usr/lib
                 cp /compat/linux/usr/lib/$(ls /compat/linux/usr/lib/ | grep libnvidia-tls)  $ubuntu/usr/lib
                 ln -s  $(ls /compat/linux/usr/lib/ | grep libGL.so   | head -3 | tail -n 1) $ubuntu/usr/lib/libGL.so.1

                            if ! [ -f "$tar/NVIDIA-Linux-x86_64-375.26.run" ]; then 
                cd $tar && fetch http://ru.download.nvidia.com/XFree86/Linux-x86_64/375.26/NVIDIA-Linux-x86_64-375.26.run
                chmod +x NVIDIA-Linux-x86_64-375.26.run
                cd ..
                             fi  
          cd $tar &&  ./NVIDIA-Linux-x86_64-375.26.run -x
                 cd ..
          cp    $tar/NVIDIA-Linux-x86_64-375.26/libGL.so.375.26                  $ubuntu/usr/lib/x86_64-linux-gnu
          ln -s libGL.so.375.26                                                  $ubuntu/usr/lib/x86_64-linux-gnu/libGL.so.1
          cp    $tar/NVIDIA-Linux-x86_64-375.26/libnvidia-tls.so.375.26          $ubuntu/usr/lib/x86_64-linux-gnu
          cp    $tar/NVIDIA-Linux-x86_64-375.26/libnvidia-glcore.so.375.26       $ubuntu/usr/lib/x86_64-linux-gnu
   fi 
 

      if ! [ -f "$tar/linux-skype_oss_wrapper-0.1.1.txz" ]; then 

         cd $tar && fetch http://pkg.freebsd.org/freebsd:11:x86:64/latest/All/linux-skype_oss_wrapper-0.1.1.txz && cd ../

        fi

         tar xf $tar/linux-skype_oss_wrapper-0.1.1.txz  -C $ubuntu/usr/lib    -s ",/.*/,,g" "*/libpulse.so.0"





doas chroot $ubuntu /usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0/gdk-pixbuf-query-loaders \
 >  $ubuntu/usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0/2.10.0/loaders.cache

doas chroot $ubuntu /usr/lib32/gdk-pixbuf-2.0/gdk-pixbuf-query-loaders \
 >  ubuntu/usr/lib32/gdk-pixbuf-2.0/2.10.0/loaders.cache

du -a $ubuntu/usr/share/ca-certificates | sed "s/$ubuntu\/usr\/share\/ca-certificates\///" |  awk '{print $2}' \
 >>  $ubuntu/etc/ca-certificates.conf

mkdir -p    $ubuntu/usr/lib/i386-linux-gnu/gdk-pixbuf-2.0/2.10.0/
cp          ubuntu/usr/lib/i386-linux-gnu/gdk-pixbuf-2.0/2.10.0/loaders.cache  $ubuntu/usr/lib/i386-linux-gnu/gdk-pixbuf-2.0/2.10.0/
cp -R       ubuntu/usr/lib/i386-linux-gnu/gdk-pixbuf-2.0/2.10.0/loaders     $ubuntu/usr/lib/i386-linux-gnu/gdk-pixbuf-2.0/2.10.0/
cp -rf      ubuntu/usr/lib/i386-linux-gnu/*  $ubuntu/usr/lib32
cp -rf      ubuntu/lib/i386-linux-gnu/*      $ubuntu/usr/lib32
rm          $ubuntu/bin/sh

doas cp -R  $ubuntu /compat/
doas chroot /compat/$ubuntu locale-gen en_US.UTF-8
doas chroot /compat/$ubuntu locale-gen ru_RU.UTF-8
doas chroot /compat/$ubuntu /bin/dbus-uuidgen --ensure


doas chroot /compat/$ubuntu update-ca-certificates
doas chroot /compat/$ubuntu update-ca-certificates

