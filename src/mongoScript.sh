#!/bin/sh

echo "Mongo Script"

ls
if test -d /app/Smart* ; then
        echo "Code already Present"
        cd SmartCert*
	git checkout -b Integration
        git pull origin Integration
        cd ../
else
        echo "Code is not available.. pulling from the git"
        git clone -b Integration --single-branch https://DarshanRaremile:d%40rsh%40n%405445@github.com/productdepot/SmartCertWebApp.git
        ls
fi
        DOCKERIP=$(ip a show | grep "global" | awk '{print $2}' | cut -f1 -d"/")
        UniversityPort=3003;
        StudentPort=3000;
        VerifierPort=3001;
        MongoPort=27017;

        cd Smart*/University
        grep -rl "http://localhost:4200" app.js | xargs sed -i "s/localhost:4200/$DOCKERIP:$UniversityPort/g"
        cd Config/
        grep -rl "127.0.0.1:27017" config.js | xargs sed -i "s/127.0.0.1:27017/$DOCKERIP:$MongoPort/g"
        cd ../../Student
        grep -rl "http://localhost:4200" app.js | xargs sed -i "s/localhost:4200/$DOCKERIP:$StudentPort/g"
        cd Config/
        grep -rl "127.0.0.1:27017" config.js | xargs sed -i "s/127.0.0.1:27017/$DOCKERIP:$MongoPort/g"
        cd ../../Verifier
        grep -rl "http://localhost:4200" app.js | xargs sed -i "s/localhost:4200/$DOCKERIP:$VerifierPort/g"
        cd Config/
        grep -rl "127.0.0.1:27017" Config.js | xargs sed -i "s/127.0.0.1:27017/$DOCKERIP:$MongoPort/g"
        cd ../../
        echo $DOCKERIP

        mongod --fork --syslog



