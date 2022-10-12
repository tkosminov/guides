# Список дисков

```bash
fdisk -l
```

# Скорость диска

## hdparm

```bash
apt install hdparm
```

read:

```bash
hdparm -Tt ${disk}
```

## dd

write:

```bash
dd if=/dev/zero of=/tmp/test1.img bs=1G count=1 oflag=dsync; rm -f /tmp/test1.img
```

latency:

```bash
dd if=/dev/zero of=/tmp/test2.img bs=512 count=1000 oflag=dsync; rm -f /tmp/test2.img
```

read:

```bash
dd if=/dev/zero of=/tmp/test3.img bs=1G count=1 oflag=direct; rm -f /tmp/test3.img
```

read without cache:

```bash
hdparm -W0 /dev/sda

dd if=/dev/zero of=/tmp/test3.img bs=1G count=1 oflag=direct; rm -f /tmp/test3.img
```

## fio

```bash
apt install fio
```

Sequential READ speed with big blocks QD32:

```
fio --name TEST --eta-newline=5s --filename=fio-tempfile.dat --rw=read --size=500m --io_size=10g --blocksize=1024k --ioengine=libaio --fsync=10000 --iodepth=32 --direct=1 --numjobs=1 --runtime=60 --group_reporting
```

Sequential WRITE speed with big blocks QD32:

```bash
fio --name TEST --eta-newline=5s --filename=fio-tempfile.dat --rw=write --size=500m --io_size=10g --blocksize=1024k --ioengine=libaio --fsync=10000 --iodepth=32 --direct=1 --numjobs=1 --runtime=60 --group_reporting
```

Random 4K read QD1:

```bash
fio --name TEST --eta-newline=5s --filename=fio-tempfile.dat --rw=randread --size=500m --io_size=10g --blocksize=4k --ioengine=libaio --fsync=1 --iodepth=1 --direct=1 --numjobs=1 --runtime=60 --group_reporting
```

Mixed random 4K read and write QD1 with sync:

```bash
fio --name TEST --eta-newline=5s --filename=fio-tempfile.dat --rw=randrw --size=500m --io_size=10g --blocksize=4k --ioengine=libaio --fsync=1 --iodepth=1 --direct=1 --numjobs=1 --runtime=60 --group_reporting
```
