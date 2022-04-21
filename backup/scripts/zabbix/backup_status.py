import urbackup_api
server = urbackup_api.urbackup_server("http://127.0.0.1:55414/x", "<user>", "<password>")
clients = server.get_status()
fail = False
for client in clients:
    #print(client)
    if (not ("file_disabled" in client and "image_disabled" in client)) and (not client["delete_pending"]) and (not client["file_ok"]):
        #print(client)
        fail = True

if fail:
    print("Fail")
else:
    print("OK")
