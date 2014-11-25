awk '{
  if ("x"$0 != "x") {
    print "[program:"$0"]";
    if ($0 == "xinetd") 
      print "command      = "$0"";
    else {
      SVC=$0;
      gsub("openstack-", "", SVC);
      CFG=SVC;
      gsub("swift-", "", CFG);
      print "command      = /usr/bin/python /usr/bin/"SVC" /etc/swift/"CFG".conf";
      } ### else
    print "autostart    = true";
    print "autorestart  = true";
    print "startsecs    = 3";
    print "stopwaitsecs = 3";
    print "";
    } ### if
  }' services.lis
