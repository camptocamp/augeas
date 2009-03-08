module Test_haproxy =

let conf1 = "# Simple configuration

global
    option httpchk uri1
    option    httpchk uri2 # comment
    option    httpchk somemethod someuri
    debug
    option    httpchk somemethod someuri someversion
    option    blah
    daemon

listen blah 0.0.0.0:80
     option httpchk someuri
    option    httpchk someuri # comment foo bar
    option    httpchk somemethod someuri
    debug
    option    httpchk somemethod someuri someversion
    option    blah
"

test Haproxy.lns get conf1 = 
  { "#comment" = "Simple configuration" }
  {  }
  { "global"
    { "option"
      { "httpchk" = "uri1" }
    }
    { "option"
      { "httpchk" = "uri2"
        { "#comment" = "comment" }
      }
    }
    { "option"
      { "httpchk" = "somemethod someuri" }
    }
    { "debug" }
    { "option"
      { "httpchk" = "somemethod someuri someversion" }
    }
    { "option"
      { "blah" }
    }
    { "daemon" }
    {  }
  }
  { "listen"
    { "blah" = "0.0.0.0:80"
      { "option"
        { "httpchk" = "someuri" }
      }
      { "option"
        { "httpchk" = "someuri"
          { "#comment" = "comment foo bar" }
        }
      }
      { "option"
        { "httpchk" = "somemethod someuri" }
      }
      { "debug" }
      { "option"
        { "httpchk" = "somemethod someuri someversion" }
      }
      { "option"
        { "blah" }
      }
    }
  }

let conf2 = "# this config needs haproxy-1.1.28 or haproxy-1.2.1

global
	log 127.0.0.1	local0
	log 127.0.0.1	local1 notice
	#log loghost	local0 info
	maxconn 4096
	#chroot /usr/share/haproxy
	user haproxy
	group haproxy
	daemon
	#debug
	#quiet

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
	retries	3
	option redispatch
	maxconn	2000
	contimeout	5000
	clitimeout	50000
	srvtimeout	50000

listen	appli1-rewrite 0.0.0.0:10001
	cookie	SERVERID rewrite
	balance	roundrobin
	server	app1_1 192.168.34.23:8080 cookie app1inst1 check inter 2000 rise 2 fall 5
	server	app1_2 192.168.34.32:8080 cookie app1inst2 check inter 2000 rise 2 fall 5
	server	app1_3 192.168.34.27:8080 cookie app1inst3 check inter 2000 rise 2 fall 5
	server	app1_4 192.168.34.42:8080 cookie app1inst4 check inter 2000 rise 2 fall 5

listen	appli2-insert 0.0.0.0:10002
	option	httpchk
	balance	roundrobin
	cookie	SERVERID insert indirect nocache
	server	inst1 192.168.114.56:80 cookie server01 check inter 2000 fall 3
	server	inst2 192.168.114.56:81 cookie server02 check inter 2000 fall 3
	capture cookie vgnvisitor= len 32

	option	httpclose		# disable keep-alive
	rspidel ^Set-cookie:\ IP=	# do not let this cookie tell our internal IP address
	
listen	appli3-relais 0.0.0.0:10003
	dispatch 192.168.135.17:80

listen	appli4-backup 0.0.0.0:10004
	option	httpchk /index.html
	option	persist
	balance	roundrobin
	server	inst1 192.168.114.56:80 check inter 2000 fall 3
	server	inst2 192.168.114.56:81 check inter 2000 fall 3 backup

listen	ssl-relay 0.0.0.0:8443
	option	ssl-hello-chk
	balance	source
	server	inst1 192.168.110.56:443 check inter 2000 fall 3
	server	inst2 192.168.110.57:443 check inter 2000 fall 3
	server	back1 192.168.120.58:443 backup

listen	appli5-backup 0.0.0.0:10005
	option	httpchk *
	balance	roundrobin
	cookie	SERVERID insert indirect nocache
	server	inst1 192.168.114.56:80 cookie server01 check inter 2000 fall 3
	server	inst2 192.168.114.56:81 cookie server02 check inter 2000 fall 3
	server	inst3 192.168.114.57:80 backup check inter 2000 fall 3
	capture cookie ASPSESSION len 32
	srvtimeout	20000

	option	httpclose		# disable keep-alive
	option  checkcache		# block response if set-cookie & cacheable

	rspidel ^Set-cookie:\ IP=	# do not let this cookie tell our internal IP address
	
	#errorloc	502	http://192.168.114.58/error502.html
	#errorfile	503	/etc/haproxy/errors/503.http
	errorfile	400	/etc/haproxy/errors/400.http
	errorfile	403	/etc/haproxy/errors/403.http
	errorfile	408	/etc/haproxy/errors/408.http
	errorfile	500	/etc/haproxy/errors/500.http
	errorfile	502	/etc/haproxy/errors/502.http
	errorfile	503	/etc/haproxy/errors/503.http
	errorfile	504	/etc/haproxy/errors/504.http
"

test Haproxy.lns get conf2 = 
  { "#comment" = "this config needs haproxy-1.1.28 or haproxy-1.2.1" }
  {  }
  { "global"
    { "log" = "127.0.0.1\tlocal0" }
    { "log" = "127.0.0.1\tlocal1 notice" }
    { "#comment" = "log loghost\tlocal0 info" }
    { "maxconn" = "4096" }
    { "#comment" = "chroot /usr/share/haproxy" }
    { "user" = "haproxy" }
    { "group" = "haproxy" }
    { "daemon" }
    { "#comment" = "debug" }
    { "#comment" = "quiet" }
    {  }
  }
  { "defaults"
    {
      { "log" = "global" }
      { "mode" = "http" }
      { "option"
        { "httplog" }
      }
      { "option" 
        { "dontlognull" }
      }
      { "retries" = "3" }
      { "option"
        { "redispatch" }
      }
      { "maxconn" = "2000" }
      { "contimeout" = "5000" }
      { "clitimeout" = "50000" }
      { "srvtimeout" = "50000" }
      {  }
    }
  }
  { "listen"
    { "appli1-rewrite" =  "0.0.0.0:10001"
      { "cookie" = "SERVERID rewrite" }
      { "balance" = "roundrobin" }
      { "server" = "app1_1 192.168.34.23:8080 cookie app1inst1 check inter 2000 rise 2 fall 5" }
      { "server" = "app1_2 192.168.34.32:8080 cookie app1inst2 check inter 2000 rise 2 fall 5" }
      { "server" = "app1_3 192.168.34.27:8080 cookie app1inst3 check inter 2000 rise 2 fall 5" }
      { "server" = "app1_4 192.168.34.42:8080 cookie app1inst4 check inter 2000 rise 2 fall 5" }
      {  }
    }
  }
  { "listen"
    { "appli2-insert" = "0.0.0.0:10002"
      { "option"
        { "httpchk" }
      }
      { "balance" = "roundrobin" }
      { "cookie" = "SERVERID insert indirect nocache" }
      { "server" = "inst1 192.168.114.56:80 cookie server01 check inter 2000 fall 3" }
      { "server" = "inst2 192.168.114.56:81 cookie server02 check inter 2000 fall 3" }
      { "capture" = "cookie vgnvisitor= len 32" }
      {  }
      { "option"
        { "httpclose"
          { "#comment" = "disable keep-alive" }
        }
      }
      { "rspidel" = "^Set-cookie:\ IP="
        { "#comment" = "do not let this cookie tell our internal IP address" }
      }
      {  }
    }
  }
  { "listen"
    { "appli3-relais" = "0.0.0.0:10003"
      { "dispatch" = "192.168.135.17:80" }
      {  }
    }
  }
  { "listen"
    { "appli4-backup" = "0.0.0.0:10004"
      { "option"
        { "httpchk" = "/index.html" }
      }
      { "option"
        { "persist" }
      }
      { "balance" = "roundrobin" }
      { "server" = "inst1 192.168.114.56:80 check inter 2000 fall 3" }
      { "server" = "inst2 192.168.114.56:81 check inter 2000 fall 3 backup" }
      {  }
    }
  }
  { "listen"
    { "ssl-relay" =  "0.0.0.0:8443"
      { "option" 
        { "ssl-hello-chk" }
      }
      { "balance" = "source" }
      { "server" = "inst1 192.168.110.56:443 check inter 2000 fall 3" }
      { "server" = "inst2 192.168.110.57:443 check inter 2000 fall 3" }
      { "server" = "back1 192.168.120.58:443 backup" }
      {  }
    }
  }
  { "listen"
    { "appli5-backup" = "0.0.0.0:10005"
      { "option" 
        { "httpchk" = "*" }
      }
      { "balance" = "roundrobin" }
      { "cookie" = "SERVERID insert indirect nocache" }
      { "server" = "inst1 192.168.114.56:80 cookie server01 check inter 2000 fall 3" }
      { "server" = "inst2 192.168.114.56:81 cookie server02 check inter 2000 fall 3" }
      { "server" = "inst3 192.168.114.57:80 backup check inter 2000 fall 3" }
      { "capture" = "cookie ASPSESSION len 32" }
      { "srvtimeout" = "20000" }
      {  }
      { "option" 
        { "httpclose"
          { "#comment" = "disable keep-alive" }
        }
      }
      { "option"
        { "checkcache"
          { "#comment" = "block response if set-cookie & cacheable" }
        }
      }
      {  }
      { "rspidel" = "^Set-cookie:\ IP="
        { "#comment" = "do not let this cookie tell our internal IP address" }
      }
      {  }
      { "#comment" = "errorloc\t502\thttp://192.168.114.58/error502.html" }
      { "#comment" = "errorfile\t503\t/etc/haproxy/errors/503.http" }
      { "errorfile" = "400\t/etc/haproxy/errors/400.http" }
      { "errorfile" = "403\t/etc/haproxy/errors/403.http" }
      { "errorfile" = "408\t/etc/haproxy/errors/408.http" }
      { "errorfile" = "500\t/etc/haproxy/errors/500.http" }
      { "errorfile" = "502\t/etc/haproxy/errors/502.http" }
      { "errorfile" = "503\t/etc/haproxy/errors/503.http" }
      { "errorfile" = "504\t/etc/haproxy/errors/504.http" }
    }
  }

let conf3 = "# Convoluted sample

global
  maxconn 1024
  option httpchk 1234 

defaults blah
  acl invalid_src  src          0.0.0.0/7 224.0.0.0/3 # Comment
  acl invalid_src  src_port     0:1023
  acl local_dst    hdr(host) -i localhost
  # delay every incoming request by 2 seconds
  tcp-request inspect-delay 2s
  tcp-request content accept if WAIT_END

  # don't immediately tell bad guys they are rejected
  tcp-request inspect-delay 10s
  acl goodguys src 10.0.0.0/24
  acl badguys  src 10.0.1.0/24
  tcp-request content accept if goodguys
  tcp-request content reject if badguys WAIT_END
  tcp-request content reject

  acl missing_cl hdr_cnt(Content-length) eq 0
  block if HTTP_URL_STAR !METH_OPTIONS || METH_POST missing_cl
  block if METH_GET HTTP_CONTENT
  block unless METH_GET or METH_POST or METH_OPTIONS

listen
  mode http

listen blah
  mode http

listen foo 0.0.0.0:1234
  mode http
"



test Haproxy.lns get conf3 = ?
