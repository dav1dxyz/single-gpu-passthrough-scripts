# single-gpu-passthrough-scripts
Scripts for passing GPU to VM

Make sure to do the following:
- Login to root account and do the following:
``mkdir -p /etc/systemd/system/getty@tty1.service.d/``

- Move ``override.conf`` to the directory created. This will automatically log you in to tty1 at boot

- If it doesn't work on boot, I would just delete ``override.conf``, login as root and type the following:
```
export EDITOR=nano
systemctl edit getty@tty1
```
and then paste what's in override.conf in that. Should work after that.

- In your ``~/.zprofile`` or ``~/.bash_profile`` enter the following:
```bash
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx
fi
```
or just copy the .zprofile from this github to your home directory (this assumes you're using zsh)

- You'll obviously need libvirt hooks so make sure that's set up https://passthroughpo.st/simple-per-vm-libvirt-hooks-with-the-vfio-tools-hook-helper/

- Make sure ``kvm.conf`` is in the directory ``/etc/libvirt/hooks``, and the win10 folder is in ``/etc/libvirt/hooks/qemu.d``. You'll need to make some changes to ``kvm.conf``. You'll need to add the PCI devices you're going to use, as well as edit the start.sh and revert.sh scripts with them. Also change which WM/DE you're using e.g. I currently have ``killall bspwm``, but that's what I'm using right now.
I recommend watching [mutas tutorial](https://www.youtube.com/watch?v=BUSrdUoedTo&t=429s) for anything else.
