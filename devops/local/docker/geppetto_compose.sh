#!bin/bash

DESKTOPCODE='../../../application/client/desktop/newtest4'

COMPOSEPATH='../../../../devops/local/docker/'

ENVPATH='../../.env'


while getopts :cdrs option
do
    case "$option" in
    c)  
         echo "Creating new docker images and containers"
         cd $DESKTOPCODE
         docker build -t newtest4ui-4502 .
         docker run --name newtest4ui-4502 --restart=unless-stopped -d -p 5055:5000 newtest4ui-4502
         sleep 15
         echo "UI build is done..."

         cd $COMPOSEPATH
         docker-compose up -d --build
         echo "uploading the mongo script..."
         sleep 50
         docker cp mongo.js mongo-4502:/data/db/
         docker exec -ti mongo-4502 mongo -u admin -p 'password' --authenticationDatabase 'admin' newtest4_4502 /data/db/mongo.js
         sleep 10
         echo "Process completed"
         echo " Your application is deployed here the link, http://localhost:5055 "
         ;;
    d)
         echo "Now Deleting all containers and images"
         docker-compose down -v --rmi all 
         docker rm -f newtest4ui-4502
         docker rmi newtest4ui-4502
         echo "Process completed"
         ;;
    r)
         echo "Now Re-starting the stopped containers"
         docker-compose start
         docker restart newtest4ui-4502
         sleep 35
         echo "Process completed"
         ;;
    s)
         echo "Now stopping the running containers"
         docker-compose stop
         docker stop newtest4ui-4502
         echo "Process completed"
         ;;
    *)
        echo "Hmm, an invalid option was received. the valid option are."
        echo "Flag c - To Create new containers and images."
        echo "Flag d - To Delete all the containers and images."
        echo "Flag r - To Restart the stopped containers."
        echo "Flag s - To Stop the running containers."
        echo "Here's the usage statement:"
        echo ""
        echo "bash geppetto_compose.sh -c (or) bash geppetto_compose.sh -d (or) bash geppetto_compose.sh -r (or) bash geppetto_compose.sh -s"
       
       ;;
        esac
done

echo ""
echo "These are the usage options for help."
echo "Flag c - To Create new containers and images."
echo "Flag d - To Delete all the containers and images."
echo "Flag r - To Restart the stopped containers."
echo "Flag s - To Stop the running containers."
echo "Here's the usage statement:"
echo ""
echo "bash geppetto_compose.sh -c (or) bash geppetto_compose.sh -d (or) bash geppetto_compose.sh -r (or) bash geppetto_compose.sh -s"
