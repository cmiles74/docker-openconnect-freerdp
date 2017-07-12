OpenConnect and FreeRDP Docker Image
===================================================

You can pull this image from Docker Hub.

    docker pull cmiles74/docker-openconnect-freerdp
    
I have to use OpenConnect[0] at work to connect to Cisco SSL VPN endpoint and it's
not a lot of fun. Invariably I will connect, only to find that I've lost access
to the internet on my local machine. Or maybe internet service remains but
everying on my local network becomes inaccessible. Yuck!

This image comes with OpenConnect and FreeRDP[1] (as well as the supporting stuff,
like X.org) that is ready to go. You can download this image, run it, and
connect to that VPN and start RDP-ing like a pro.

Running the Image
-------------------

This image comes with a "run" script that will probably do everything that you
need. It allows X11 access for the docker user, provides access to your X server
and runs Docker in "privileged" mode[2]. We need it to run in privileged mode so
that OpenConnect can create virtual network adapters (TUN).

Once the image has started up, it will create a new tmux[3] session and drops
you at the shell (fish)[4]. From there you can connect to your VPN endpoint.

    sudo openconnect https://my-vpn-ssl-endpoint.com
    
From there you can follow the prompts and connect to your endpoint. You can
now start your RDP session.

    xfreerdp /v:my-rdp-host.com +fonts +clipboard /a:drive,shared,/shared
    
The command above will connect your your host, use anti-aliased fonts and enable
the clipboard as well as map the "shared" directory onto your host.

When you exit the tmux session, the docker instance will be removed, keeping
your workstation clean and tidy.

Customizing the Image
------------------------

Now that you know how it works, I'm sure you can think of any number of handy
scripts you might write. To get you started, there are two sample scripts in the
"developer/bin" directory. You can start by copying those into the "custom-bin"
directory and editing them to suit your needs. You can then build your own
custom version of the image.

  docker build -t yourhandle/docker-openconnect-freerdp ${PWD}
  
From there you can link the "run" command somewhere convenient on your path.

-----

[0]: http://www.infradead.org/openconnect/
[1]: http://www.freerdp.com/
[2]: https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities
[3]: http://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/
[4]: https://fishshell.com/docs/current/tutorial.html
