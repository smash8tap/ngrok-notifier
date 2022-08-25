ps aux | grep -v grep  | grep ngrok 2> /dev/null 1>&2
if [[ $? -ne 0  ]]; then
   # Ngrok not running
   nohup ngrok tcp 8006 &
   sleep 5
   public_url=$(curl localhost:4040/api/tunnels | jq  '.tunnels' | jq '.[0].public_url' | tr -d '"' | sed "s/^tcp/https/g")  
   curl -X POST $WEBHOOK -H 'Content-Type:application/json' -d '{ "content": "'"$public_url"'"}'
fi
